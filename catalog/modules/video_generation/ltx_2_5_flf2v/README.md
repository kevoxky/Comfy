# Módulo: LTX-2.5 FLF2V (First & Last Frame Interpolation)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_ltx2_5_flf2v.json`  

---

## 🎯 Descripción y Capacidades

Interpolación cinematográfica entre fotograma inicial y fotograma final en la arquitectura LTX-2.5 con super-resolución latente 2x.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.5/resolve/main/diffusion_models/ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors) |
| `text_encoder` | `gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.5/resolve/main/text_encoders/gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors) |
| `video_vae` | `ltx-2.5-video-vae-bf16.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-video-vae-bf16.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-LTXVideo**: [https://github.com/Lightricks/ComfyUI-LTXVideo.git](https://github.com/Lightricks/ComfyUI-LTXVideo.git)
- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/video_generation/ltx_2_5_flf2v/bootstrap.sh
```
