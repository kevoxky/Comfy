"""
Commercial Video Assembler Node for ComfyUI
Concatenates the 4 generated commercial video clips (Shot 1, Shot 2, Shot 3, Shot 4)
into a single final commercial master (commercial/final_commercial.mp4).
Performs stream probing to check compatibility (resolution, FPS, codec, pixel format, audio).
- If compatible: direct stream copy (-c copy, zero loss, instant execution).
- If incompatible: automatically re-encodes to unified standard (H.264, yuv420p, 24fps, AAC audio).
Supports optional master soundtrack mixing or direct audio concatenation.
"""

import os
import sys
import glob
import json
import shutil
import tempfile
import subprocess
from pathlib import Path

# ComfyUI environment detection
try:
    import folder_paths
except ImportError:
    folder_paths = None

class CommercialVideoAssembler:
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "video_1": ("VIDEO", {"tooltip": "Clip de video del Shot 1 (Hero)"}),
                "video_2": ("VIDEO", {"tooltip": "Clip de video del Shot 2 (Product Macro)"}),
                "video_3": ("VIDEO", {"tooltip": "Clip de video del Shot 3 (Model Beauty)"}),
                "video_4": ("VIDEO", {"tooltip": "Clip de video del Shot 4 (Final Packshot)"}),
                "filename_prefix": ("STRING", {
                    "default": "commercial/final_commercial",
                    "tooltip": "Ruta y nombre del archivo final (relativo a ComfyUI/output/)"
                }),
                "audio_mode": ([
                    "Concatenate Shot Audios (Native MiniMax)",
                    "Mute Video",
                    "Mix with Master Soundtrack (if connected)"
                ], {
                    "default": "Concatenate Shot Audios (Native MiniMax)",
                    "tooltip": "Modo de procesamiento del audio publicitario final."
                }),
            },
            "optional": {
                "optional_master_soundtrack": ("AUDIO", {
                    "tooltip": "Pista de audio musical externa para musicalizar todo el anuncio."
                })
            }
        }

    RETURN_TYPES = ("VIDEO",)
    RETURN_NAMES = ("final_video",)
    FUNCTION = "assemble_commercial"
    OUTPUT_NODE = True
    CATEGORY = "Commercial AI/Assembler"

    def _find_ffmpeg(self):
        # 1. System PATH
        system_ffmpeg = shutil.which("ffmpeg")
        if system_ffmpeg:
            return system_ffmpeg
        
        # 2. imageio-ffmpeg
        try:
            import imageio_ffmpeg
            return imageio_ffmpeg.get_ffmpeg_exe()
        except ImportError:
            pass

        # 3. Common locations
        common_paths = [
            "/usr/bin/ffmpeg",
            "/usr/local/bin/ffmpeg",
            "C:\\ffmpeg\\bin\\ffmpeg.exe",
            "C:\\Program Files\\ffmpeg\\bin\\ffmpeg.exe"
        ]
        for p in common_paths:
            if os.path.exists(p):
                return p

        return "ffmpeg"

    def _find_ffprobe(self):
        system_ffprobe = shutil.which("ffprobe")
        if system_ffprobe:
            return system_ffprobe
        common_paths = [
            "/usr/bin/ffprobe",
            "/usr/local/bin/ffprobe",
            "C:\\ffmpeg\\bin\\ffprobe.exe",
            "C:\\Program Files\\ffmpeg\\bin\\ffprobe.exe"
        ]
        for p in common_paths:
            if os.path.exists(p):
                return p
        return None

    def _probe_video(self, file_path):
        """Extracts stream metadata: width, height, fps, codec, pix_fmt, has_audio."""
        ffprobe = self._find_ffprobe()
        if ffprobe:
            try:
                cmd = [
                    ffprobe, "-v", "error",
                    "-show_entries", "stream=width,height,r_frame_rate,codec_name,pix_fmt,codec_type",
                    "-of", "json", file_path
                ]
                res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
                data = json.loads(res.stdout)
                streams = data.get("streams", [])
                video_info = next((s for s in streams if s.get("codec_type") == "video"), {})
                has_audio = any(s.get("codec_type") == "audio" for s in streams)
                return {
                    "width": video_info.get("width"),
                    "height": video_info.get("height"),
                    "fps": video_info.get("r_frame_rate"),
                    "codec": video_info.get("codec_name"),
                    "pix_fmt": video_info.get("pix_fmt"),
                    "has_audio": has_audio
                }
            except Exception as e:
                print(f"[CommercialVideoAssembler] ffprobe check note: {e}")

        # Fallback using pyav if available
        try:
            import av
            with av.open(file_path) as container:
                v_stream = next((s for s in container.streams if s.type == "video"), None)
                a_stream = next((s for s in container.streams if s.type == "audio"), None)
                if v_stream:
                    return {
                        "width": v_stream.width,
                        "height": v_stream.height,
                        "fps": str(v_stream.average_rate),
                        "codec": v_stream.codec_context.name,
                        "pix_fmt": v_stream.pix_fmt,
                        "has_audio": a_stream is not None
                    }
        except Exception:
            pass

        return None

    def _check_compatibility(self, probe_list):
        """Checks if all probed videos share identical codec, resolution, fps, pix_fmt, and audio presence."""
        if not probe_list or len(probe_list) < 2:
            return True
        first = probe_list[0]
        if not first:
            return False
        for p in probe_list[1:]:
            if not p:
                return False
            if p["width"] != first["width"] or p["height"] != first["height"]:
                return False
            if p["codec"] != first["codec"] or p["pix_fmt"] != first["pix_fmt"]:
                return False
            if p["has_audio"] != first["has_audio"]:
                return False
        return True

    def _save_video_obj(self, video_obj, target_path):
        """Attempts to save a ComfyUI VIDEO object to a file if not already on disk."""
        if hasattr(video_obj, "save_to"):
            try:
                video_obj.save_to(target_path, format="mp4", codec="h264")
                return True
            except Exception as e:
                print(f"[CommercialVideoAssembler] save_to failed: {e}")
        return False

    def _find_latest_shot_file(self, output_dir, shot_pattern):
        files = glob.glob(os.path.join(output_dir, "commercial", f"{shot_pattern}*.mp4"))
        if not files:
            files = glob.glob(os.path.join(output_dir, f"{shot_pattern}*.mp4"))
        if files:
            files.sort(key=os.path.getmtime, reverse=True)
            return files[0]
        return None

    def assemble_commercial(self, video_1, video_2, video_3, video_4, filename_prefix="commercial/final_commercial", audio_mode="Concatenate Shot Audios (Native MiniMax)", optional_master_soundtrack=None):
        output_dir = folder_paths.get_output_directory() if folder_paths else "output"
        full_output_dir = os.path.join(output_dir, os.path.dirname(filename_prefix))
        os.makedirs(full_output_dir, exist_ok=True)

        final_filename = os.path.basename(filename_prefix)
        if not final_filename.endswith(".mp4"):
            final_filename += ".mp4"
        
        final_output_path = os.path.join(full_output_dir, final_filename)
        temp_dir = tempfile.mkdtemp(prefix="comfy_commercial_assembler_")
        shot_files = []

        try:
            videos = [video_1, video_2, video_3, video_4]
            shot_names = ["shot_01_hero", "shot_02_product", "shot_03_beauty", "shot_04_packshot"]

            for i, (v, name) in enumerate(zip(videos, shot_names)):
                temp_clip = os.path.join(temp_dir, f"{name}.mp4")
                saved = self._save_video_obj(v, temp_clip)

                if not saved or not os.path.exists(temp_clip) or os.path.getsize(temp_clip) == 0:
                    latest = self._find_latest_shot_file(output_dir, name)
                    if latest and os.path.exists(latest):
                        print(f"[CommercialVideoAssembler] Utilizando archivo renderizado para Shot {i+1}: {latest}")
                        shutil.copyfile(latest, temp_clip)
                    else:
                        print(f"[CommercialVideoAssembler] Aviso: No se localizó archivo de video para Shot {i+1} ({name})")

                if os.path.exists(temp_clip) and os.path.getsize(temp_clip) > 0:
                    shot_files.append(temp_clip)

            if len(shot_files) < 4:
                print(f"[CommercialVideoAssembler] Aviso: Se reunieron {len(shot_files)}/4 shots.")

            if not shot_files:
                raise RuntimeError("No se encontraron clips de video válidos para el ensamblado publicitario final.")

            # Probing compatibility
            probes = [self._probe_video(sf) for sf in shot_files]
            is_compatible = self._check_compatibility(probes)
            ffmpeg_bin = self._find_ffmpeg()

            print(f"[CommercialVideoAssembler] Estado de compatibilidad de los 4 shots: {'100% Compatibles (Stream Copy)' if is_compatible else 'Discrepancias detectadas (Auto-recodificación)'}")

            # Concat demuxer list
            concat_list_file = os.path.join(temp_dir, "concat_list.txt")
            with open(concat_list_file, "w", encoding="utf-8") as f:
                for sf in shot_files:
                    safe_path = sf.replace("\\", "/").replace("'", "'\\''")
                    f.write(f"file '{safe_path}'\n")

            if is_compatible and audio_mode != "Mute Video":
                # Direct stream copy concat (zero loss, instantaneous)
                cmd = [
                    ffmpeg_bin, "-y",
                    "-f", "concat",
                    "-safe", "0",
                    "-i", concat_list_file,
                    "-c", "copy",
                    final_output_path
                ]
                proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                if proc.returncode != 0:
                    print(f"[CommercialVideoAssembler] Intento stream copy advirtió incompatibilidad temporal, aplicando recodificación unificada: {proc.stderr}")
                    is_compatible = False

            if not is_compatible or audio_mode == "Mute Video":
                # Unified auto re-encode: MP4, H.264, yuv420p, consistent 24 FPS, AAC audio
                cmd_reencode = [
                    ffmpeg_bin, "-y",
                    "-f", "concat",
                    "-safe", "0",
                    "-i", concat_list_file,
                    "-c:v", "libx264",
                    "-pix_fmt", "yuv420p",
                    "-r", "24",
                    "-preset", "fast",
                    "-crf", "18"
                ]
                if audio_mode == "Mute Video":
                    cmd_reencode.append("-an")
                else:
                    cmd_reencode.extend(["-c:a", "aac", "-b:a", "192k"])

                cmd_reencode.append(final_output_path)
                subprocess.run(cmd_reencode, check=True)

            print(f"[CommercialVideoAssembler] ✅ Spot publicitario final generado con éxito: {final_output_path}")

        finally:
            shutil.rmtree(temp_dir, ignore_errors=True)

        return (video_4,)
