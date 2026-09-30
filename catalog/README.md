# 📚 Catálogo Maestro de Módulos y Nodos Verificados para ComfyUI

Este catálogo contiene las fichas técnicas, grafos de referencia, modelos certificados y scripts de aprovisionamiento `bootstrap.sh` para **NVIDIA RTX 5090 en RunPod**.

---

## 🔍 Super-Resolución y Escalado (Upscalers)

| Módulo ID | Nombre Oficial | Modelos / Pesajes Clave | Manual de Ingeniería |
| :--- | :--- | :--- | :--- |
| `seedvr2_3b_video` | **SeedVR2 3B Int8 (Video Upscaler Coherente)** | `seedvr2_3b_int8_scaled.safetensors` | [Ver Manual](modules/upscalers/seedvr2_3b_video/README.md) |
| `seedvr2_7b_image` | **SeedVR2 7B Int8 (Image Upscaler de Élite)** | `seedvr2_7b_int8_scaled.safetensors`<br>`ae.safetensors` | [Ver Manual](modules/upscalers/seedvr2_7b_image/README.md) |

---

## 🎬 Generación y Edición de Video

| Módulo ID | Nombre Oficial | Modelos / Pesajes Clave | Manual de Ingeniería |
| :--- | :--- | :--- | :--- |
| `bernini_r_video_edit` | **Bernini-R (Edición y Transformación de Video)** | `bernini_r_video_edit_fp8.safetensors` | [Ver Manual](modules/video_generation/bernini_r_video_edit/README.md) |
| `fastvideo_fasth3` | **FastVideo FastH3 (8-Step Accelerated I2V)** | `minimax_h3_fl2va_pruned_int8_convrot.safetensors`<br>`qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors`<br>`minimax_h3_video_vae_int8_convrot.safetensors`<br>*(+2 más)* | [Ver Manual](modules/video_generation/fastvideo_fasth3/README.md) |
| `ltx_2_3` | **Lightricks LTX-2.3 (DiT 22B + Gemma 3 12B + Latent Spatial Upscaler)** | `ltx-2.3-22b-dev-fp8.safetensors`<br>`gemma_3_12B_it_fp4_mixed.safetensors`<br>`ltx_2.3_22b_distilled_1.1_lora_dynamic_fro09_avg_rank_111_bf16.safetensors`<br>*(+2 más)* | [Ver Manual](modules/video_generation/ltx_2_3/README.md) |
| `ltx_2_3_id_lora` | **LTX-2.3 ID LoRA (Consistencia Facial y Lip-Sync)** | `ltx-2.3-22b-dev-fp8.safetensors`<br>`gemma_3_12B_it_fp4_mixed.safetensors` | [Ver Manual](modules/video_generation/ltx_2_3_id_lora/README.md) |
| `ltx_2_3_lipsync` | **LTX-2.3 Lip-Sync (Imagen y Audio a Video)** | `ltx-2.3-22b-dev-fp8.safetensors`<br>`gemma_3_12B_it_fp4_mixed.safetensors`<br>`ltx_2.3_22b_distilled_1.1_lora_dynamic_fro09_avg_rank_111_bf16.safetensors`<br>*(+1 más)* | [Ver Manual](modules/video_generation/ltx_2_3_lipsync/README.md) |
| `ltx_2_5` | **Lightricks LTX-2.5 (DiT 22B + Gemma 4 12B)** | `ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors`<br>`gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors`<br>`ltx-2.5-video-vae-bf16.safetensors`<br>*(+2 más)* | [Ver Manual](modules/video_generation/ltx_2_5/README.md) |
| `ltx_2_5_flf2v` | **LTX-2.5 FLF2V (First & Last Frame Interpolation)** | `ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors`<br>`gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors`<br>`ltx-2.5-video-vae-bf16.safetensors` | [Ver Manual](modules/video_generation/ltx_2_5_flf2v/README.md) |
| `minimax_h3` | **MiniMax H3 Video & Audio Generation** | `minimax_h3_fl2va_pruned_int8_convrot.safetensors`<br>`qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors`<br>`minimax_h3_video_vae_int8_convrot.safetensors`<br>*(+3 más)* | [Ver Manual](modules/video_generation/minimax_h3/README.md) |
| `minimax_h3_r2v` | **MiniMax H3 Reference to Video (R2V)** | `minimax_h3_fl2va_pruned_int8_convrot.safetensors`<br>`qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors`<br>`minimax_h3_video_vae_int8_convrot.safetensors`<br>*(+2 más)* | [Ver Manual](modules/video_generation/minimax_h3_r2v/README.md) |
| `scail2_character_replacement` | **SCAIL-2 (Reemplazo de Personaje en Video)** | `scail2_wan21_14b_fp8.safetensors`<br>`wan_2.1_vae.safetensors` | [Ver Manual](modules/video_generation/scail2_character_replacement/README.md) |
| `wan2_2_14b` | **Wan 2.2 14B (Alibaba Video Generation)** | `wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`<br>`wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`<br>`umt5_xxl_fp8_e4m3fn_scaled.safetensors`<br>*(+3 más)* | [Ver Manual](modules/video_generation/wan2_2_14b/README.md) |
| `wan2_2_t2v` | **Wan 2.2 14B (Texto a Video Directo)** | `wan2.2_t2v_14B_fp8_scaled.safetensors`<br>`umt5_xxl_fp8_e4m3fn_scaled.safetensors`<br>`wan_2.1_vae.safetensors` | [Ver Manual](modules/video_generation/wan2_2_t2v/README.md) |
| `wan_animate2` | **Wan Animate 2 (Transferencia de Movimiento)** | `wan2.1_animate_14B_fp8.safetensors`<br>`umt5_xxl_fp8_e4m3fn_scaled.safetensors`<br>`wan_2.1_vae.safetensors` | [Ver Manual](modules/video_generation/wan_animate2/README.md) |

---

## 🎨 Generación de Imagen (Text-to-Image)

| Módulo ID | Nombre Oficial | Modelos / Pesajes Clave | Manual de Ingeniería |
| :--- | :--- | :--- | :--- |
| `anima_base_v1` | **Anima Base v1.0 (Anime e Ilustración 2D)** | `anima_base_v1.0_bf16.safetensors` | [Ver Manual](modules/image_generation/anima_base_v1/README.md) |
| `flux2_dev` | **Flux.2 Dev (Black Forest Labs)** | `flux2-dev-fp8.safetensors`<br>`t5xxl_fp8_e4m3fn_scaled.safetensors`<br>`clip_l.safetensors`<br>*(+1 más)* | [Ver Manual](modules/image_generation/flux2_dev/README.md) |
| `krea2_turbo` | **Krea-2 Turbo (Estética Artística y Rápida)** | `krea2_turbo_fp8.safetensors`<br>`qwen2.5_vl_7b_fp8.safetensors`<br>`krea2_vae.safetensors` | [Ver Manual](modules/image_generation/krea2_turbo/README.md) |
| `qwen_image_2512` | **Qwen Image 2512 (Última Generación Visual)** | `qwen_image_2512_bf16.safetensors` | [Ver Manual](modules/image_generation/qwen_image_2512/README.md) |
| `qwen_image_2_1` | **Qwen Image 2.1 (Texto a Imagen Nativo 2K)** | `qwen_image_2.1_bf16.safetensors`<br>`qwen3vl_8b_bf16.safetensors`<br>`qwen_image_2.1_vae_bf16.safetensors` | [Ver Manual](modules/image_generation/qwen_image_2_1/README.md) |
| `z_image_turbo` | **Z-Image-Turbo (y versión Int8)** | `z_image_turbo_fp8.safetensors`<br>`ae.safetensors` | [Ver Manual](modules/image_generation/z_image_turbo/README.md) |

---

## ✂️ Edición de Imagen, Inpainting y ControlNet

| Módulo ID | Nombre Oficial | Modelos / Pesajes Clave | Manual de Ingeniería |
| :--- | :--- | :--- | :--- |
| `firered_image_edit1_1` | **FireRed Image Edit 1.1** | `firered_image_edit_1.1_fp8.safetensors`<br>`ae.safetensors` | [Ver Manual](modules/image_editing/firered_image_edit1_1/README.md) |
| `flux1_fill_inpaint` | **Flux.1 Fill Dev (Relleno Generativo e Inpainting)** | `flux1-fill-dev.safetensors`<br>`ae.safetensors` | [Ver Manual](modules/image_editing/flux1_fill_inpaint/README.md) |
| `flux2_klein_9b` | **Flux.2 [Klein] 9B (Edición de Imagen)** | `flux2_klein_9b_base.safetensors`<br>`t5xxl_fp8_e4m3fn_scaled.safetensors`<br>`ae.safetensors` | [Ver Manual](modules/image_editing/flux2_klein_9b/README.md) |
| `flux_kontext_dev` | **Flux Kontext Dev (Edición Contextual)** | `flux1-kontext-dev.safetensors`<br>`ae.safetensors` | [Ver Manual](modules/image_editing/flux_kontext_dev/README.md) |
| `qwen_image_2_1_edit` | **Qwen Image 2.1 (Edición de Imagen Multimodal)** | `qwen_image_2.1_bf16.safetensors`<br>`qwen3vl_8b_bf16.safetensors`<br>`qwen_image_2.1_vae_bf16.safetensors` | [Ver Manual](modules/image_editing/qwen_image_2_1_edit/README.md) |
| `qwen_image_edit_2509` | **Qwen Image Edit 2509 (ControlNet Relight & Depth)** | `qwen_image_edit_2509_bf16.safetensors`<br>`qwen_image_vae.safetensors` | [Ver Manual](modules/image_editing/qwen_image_edit_2509/README.md) |
| `qwen_image_edit_2511` | **Qwen Image Edit 2511 (Reemplazo de Materiales)** | `qwen_image_edit_2511_bf16.safetensors`<br>`qwen_2.5_vl_7b_fp8_scaled.safetensors`<br>`qwen_image_vae.safetensors` | [Ver Manual](modules/image_editing/qwen_image_edit_2511/README.md) |
| `qwen_multiangle_character` | **Qwen 2511 Multi-Angle (Personaje en 8 Ángulos)** | `qwen_image_edit_2511_bf16.safetensors` | [Ver Manual](modules/image_editing/qwen_multiangle_character/README.md) |
| `z_image_turbo_controlnet` | **Z-Image-Turbo ControlNet (Fun Union)** | `z_image_turbo_fp8.safetensors`<br>`z_image_fun_union_controlnet.safetensors` | [Ver Manual](modules/image_editing/z_image_turbo_controlnet/README.md) |

---

## 🎵 Audio, Voz y Síntesis Musical

| Módulo ID | Nombre Oficial | Modelos / Pesajes Clave | Manual de Ingeniería |
| :--- | :--- | :--- | :--- |
| `ace_step_1_5` | **ACE-Step 1.5XL Turbo (Texto a Música y Canciones)** | `acestep_v1.5_xl_turbo_bf16.safetensors`<br>`ace_1.5_vae.safetensors`<br>`qwen_4b_ace15.safetensors`<br>*(+1 más)* | [Ver Manual](modules/audio_speech/ace_step_1_5/README.md) |
| `audio_separation_melband` | **MelBandRoFormer (Separación de Pistas y Voz)** | `MelBandRoformer_fp16.safetensors` | [Ver Manual](modules/audio_speech/audio_separation_melband/README.md) |
| `chatterbox_tts` | **ChatterBox TTS (Clonación de Voz y Multilingüe)** | *Nativo / Ligero* | [Ver Manual](modules/audio_speech/chatterbox_tts/README.md) |
| `minimax_music_3` | **MiniMax Music 3 (Texto a Música DiT)** | `minimax_music3_dit_int8_convrot.safetensors`<br>`minimax_music3_text_encoder_pruned_int8_convrot.safetensors`<br>`minimax_music3_dav.safetensors` | [Ver Manual](modules/audio_speech/minimax_music_3/README.md) |
| `stable_audio_3` | **Stable Audio 3.0 Medium (Stability AI)** | `stable_audio_3_medium.safetensors`<br>`t5gemma_b_b_ul2.safetensors`<br>`qwen3.5_2b_bf16.safetensors` | [Ver Manual](modules/audio_speech/stable_audio_3/README.md) |

---

## 🛠️ Cómo Componer un Workflow Personalizado

1. **Elige los módulos que necesitas:**
   - *Generación Base:* `flux2_dev` o `anima_base_v1`
   - *Edición / Modificación:* `flux_kontext_dev` o `flux1_fill_inpaint`
   - *Voz:* `chatterbox_tts`
   - *Video & Movimiento:* `wan_animate2` (motion transfer) o `ltx_2_3_id_lora` (lip-sync)
   - *Post-procesado:* `seedvr2_3b_video` (escalado 4K coherente)
2. **Conecta los puertos certificados:** Las conexiones `IMAGE`, `AUDIO` y `VIDEO` están garantizadas sin errores de tipo.
3. **Script Bootstrap unificado:** Combinamos las descargas de los módulos elegidos para aprovisionar tu Pod efímero en 1-click.
