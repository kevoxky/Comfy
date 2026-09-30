# Módulo: FireRed Image Edit 1.1

**Categoría:** `image_editing`  
**Plantilla Oficial:** `image_firered_image_edit1_1.json`  

---

## 🎯 Descripción y Capacidades

Modelo especializado en edición facial, alteración de atuendos, cambio de fondos y edición guiada de sujetos humanos.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `firered_image_edit_1.1_fp8.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/FireRed-Image-Edit-1.1/resolve/main/firered_image_edit_1.1_fp8.safetensors) |
| `vae` | `ae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/image_editing/firered_image_edit1_1/bootstrap.sh
```
