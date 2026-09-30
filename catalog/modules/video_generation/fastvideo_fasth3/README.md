# Módulo: FastVideo FastH3 (8-Step Accelerated I2V)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_fastvideo_fasth3_i2v.json`  

---

## 🎯 Descripción y Capacidades

Inferencia hiper-optimizada de MiniMax H3 acelerada con FastVideo FastH3 8-Step V2 para generación en tiempo récord.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `minimax_h3_fl2va_pruned_int8_convrot.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors) |
| `text_encoder` | `qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors) |
| `video_vae` | `minimax_h3_video_vae_int8_convrot.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_int8_convrot.safetensors) |
| `audio_vae` | `minimax_h3_audio_vae_fp32.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors) |
| `fastvideo_lora` | `FastH3_8steps_v2.safetensors` | `models/loras/` | [Descargar](https://huggingface.co/FastVideo/FastH3/resolve/main/FastH3_8steps_v2.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)
- **ComfyUI-VideoHelperSuite**: [https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/video_generation/fastvideo_fasth3/bootstrap.sh
```
