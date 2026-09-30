# Módulo: Z-Image-Turbo ControlNet (Fun Union)

**Categoría:** `image_editing`  
**Plantilla Oficial:** `image_z_image_turbo_fun_union_controlnet.json`  

---

## 🎯 Descripción y Capacidades

ControlNet todo-en-uno (Canny, Depth, Pose) acelerado sobre Z-Image Turbo para condicionamiento ultra veloz de bocetos o poses.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `z_image_turbo_fp8.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/z-image/resolve/main/z_image_turbo_fp8.safetensors) |
| `controlnet` | `z_image_fun_union_controlnet.safetensors` | `models/controlnet/` | [Descargar](https://huggingface.co/Comfy-Org/z-image/resolve/main/z_image_fun_union_controlnet.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/image_editing/z_image_turbo_controlnet/bootstrap.sh
```
