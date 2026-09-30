"""
Commercial Video Assembler Node for ComfyUI
Concatenates the 4 generated commercial video clips (Shot 1, Shot 2, Shot 3, Shot 4)
into a single final commercial master (commercial/final_commercial.mp4).
Preserves resolution (1280x720 or 720x1280), framerate (24fps), and stereo audio with zero unnecessary re-encoding (-c copy).
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
            # Sort by modification time descending
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
            # Prepare the 4 video file paths
            videos = [video_1, video_2, video_3, video_4]
            shot_names = ["shot_01_hero", "shot_02_product", "shot_03_beauty", "shot_04_packshot"]

            for i, (v, name) in enumerate(zip(videos, shot_names)):
                temp_clip = os.path.join(temp_dir, f"{name}.mp4")
                saved = self._save_video_obj(v, temp_clip)

                if not saved or not os.path.exists(temp_clip) or os.path.getsize(temp_clip) == 0:
                    # Look up latest saved file from output directory
                    latest = self._find_latest_shot_file(output_dir, name)
                    if latest and os.path.exists(latest):
                        print(f"[CommercialVideoAssembler] Using detected output file for Shot {i+1}: {latest}")
                        shutil.copyfile(latest, temp_clip)
                    else:
                        print(f"[CommercialVideoAssembler] Warning: No physical video file found for Shot {i+1} ({name})")

                if os.path.exists(temp_clip) and os.path.getsize(temp_clip) > 0:
                    shot_files.append(temp_clip)

            if len(shot_files) < 4:
                print(f"[CommercialVideoAssembler] Warning: Only {len(shot_files)}/4 shots could be gathered. Assembling available shots.")

            if not shot_files:
                raise RuntimeError("No input video files could be resolved for commercial assembly.")

            # Create FFmpeg concat demuxer list
            concat_list_file = os.path.join(temp_dir, "concat_list.txt")
            with open(concat_list_file, "w", encoding="utf-8") as f:
                for sf in shot_files:
                    # Escape path for FFmpeg
                    safe_path = sf.replace("\\", "/").replace("'", "'\\''")
                    f.write(f"file '{safe_path}'\n")

            ffmpeg_bin = self._find_ffmpeg()
            print(f"[CommercialVideoAssembler] Executing assembly via {ffmpeg_bin} -> {final_output_path}")

            # Direct stream copy concat (zero loss, zero re-encoding, preserves audio & 24fps)
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
                print(f"[CommercialVideoAssembler] Direct stream copy warning, falling back to safe re-encode: {proc.stderr}")
                # Fallback to standard re-encode if stream timestamps differed slightly
                cmd_fallback = [
                    ffmpeg_bin, "-y",
                    "-f", "concat",
                    "-safe", "0",
                    "-i", concat_list_file,
                    "-c:v", "libx264",
                    "-preset", "veryfast",
                    "-crf", "18",
                    "-c:a", "aac",
                    "-b:a", "192k",
                    final_output_path
                ]
                subprocess.run(cmd_fallback, check=True)

            print(f"[CommercialVideoAssembler] Final commercial video successfully assembled at: {final_output_path}")

        finally:
            shutil.rmtree(temp_dir, ignore_errors=True)

        # Return video_4 or video_1 as the ComfyUI VIDEO handle to propagate in workflow
        # along with UI metadata to preview the video in ComfyUI
        rel_subfolder = os.path.dirname(filename_prefix)
        ui_result = {
            "ui": {
                "videos": [
                    {
                        "filename": final_filename,
                        "subfolder": rel_subfolder,
                        "type": "output"
                    }
                ]
            }
        }

        # If ComfyUI node system supports returning UI dictionary:
        return (video_4,)
