# Módulo: Qwen Image Edit 2509 (ControlNet Relight & Depth)

**Categoría:** `image_editing`  
**Plantilla Oficial:** `image_qwen_image_edit_2509.json`  

---

## 🎯 Descripción y Capacidades

ControlNet avanzado para reiluminación (relighting), pose y edición precisa de elementos sobre modelos Qwen.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `qwen_image_edit_2509_bf16.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_bf16.safetensors) |
| `vae` | `qwen_image_vae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/image_editing/qwen_image_edit_2509/bootstrap.sh
```
