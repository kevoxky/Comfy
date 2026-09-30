# Módulo: Lightricks LTX-2.5 (DiT 22B + Gemma 4 12B)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_ltx2_5_i2v.json`  

---

## 🎯 Descripción y Capacidades

La generación más moderna de Lightricks con text encoder Gemma 4 12B, consistencia multi-shot nativa, audio estéreo integrado y reescalador latente 2x.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.5/resolve/main/diffusion_models/ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors) |
| `text_encoder` | `gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.5/resolve/main/text_encoders/gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors) |
| `video_vae` | `ltx-2.5-video-vae-bf16.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-video-vae-bf16.safetensors) |
| `audio_vae` | `ltx-2.5-audio-vae-bf16.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-audio-vae-bf16.safetensors) |
| `latent_spatial_upscaler` | `ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors` | `models/latent_upscale_models/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.5/resolve/main/latent_upscale_models/ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-LTXVideo**: [https://github.com/Lightricks/ComfyUI-LTXVideo.git](https://github.com/Lightricks/ComfyUI-LTXVideo.git)
- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)
- **ComfyUI-VideoHelperSuite**: [https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/video_generation/ltx_2_5/bootstrap.sh
```
