# Módulo: Qwen Image Edit 2511 (Reemplazo de Materiales)

**Categoría:** `image_editing`  
**Plantilla Oficial:** `image_qwen_image_edit_2511.json`  

---

## 🎯 Descripción y Capacidades

Reemplazo fotográfico de materiales (textil, cuero, mármol, vidrio, metal) manteniendo la iluminación y geometría del objeto original.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `qwen_image_edit_2511_bf16.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2511_bf16.safetensors) |
| `text_encoder` | `qwen_2.5_vl_7b_fp8_scaled.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors) |
| `vae` | `qwen_image_vae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors) |
| `lora` | `Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors` | `models/loras/` | [Descargar](https://huggingface.co/lightx2v/Qwen-Image-Edit-2511-Lightning/resolve/main/Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/image_editing/qwen_image_edit_2511/bootstrap.sh
```
