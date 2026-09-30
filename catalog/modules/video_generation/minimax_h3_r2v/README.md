# Módulo: MiniMax H3 Reference to Video (R2V)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_minimax_h3_r2v.json`  

---

## 🎯 Descripción y Capacidades

Generación controlada de video mediante múltiples imágenes de referencia, estilos y pista de audio de referencia con MiniMax H3.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `minimax_h3_fl2va_pruned_int8_convrot.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors) |
| `text_encoder` | `qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors) |
| `video_vae` | `minimax_h3_video_vae_int8_convrot.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_int8_convrot.safetensors) |
| `audio_vae` | `minimax_h3_audio_vae_fp32.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors) |
| `turbo_lora` | `minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors` | `models/loras/` | [Descargar](https://huggingface.co/lightx2v/Minimax-h3-Turbo/resolve/main/minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)
- **ComfyUI-VideoHelperSuite**: [https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/video_generation/minimax_h3_r2v/bootstrap.sh
```
