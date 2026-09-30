# Módulo: Qwen Image 2.1 (Edición de Imagen Multimodal)

**Categoría:** `image_editing`  
**Plantilla Oficial:** `image_qwen_image_2_1_image_edit.json`  

---

## 🎯 Descripción y Capacidades

Edición contextual en lenguaje natural de imágenes existentes con resolución nativa de hasta 2048x2048.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `qwen_image_2.1_bf16.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/Qwen-Image-2.1/resolve/main/diffusion_models/qwen_image_2.1_bf16.safetensors) |
| `text_encoder` | `qwen3vl_8b_bf16.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/Qwen-Image-2.1/resolve/main/text_encoders/qwen3vl_8b_bf16.safetensors) |
| `vae` | `qwen_image_2.1_vae_bf16.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/Qwen-Image-2.1/resolve/main/vae/qwen_image_2.1_vae_bf16.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/image_editing/qwen_image_2_1_edit/bootstrap.sh
```
