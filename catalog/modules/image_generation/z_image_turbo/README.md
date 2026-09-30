# Módulo: Z-Image-Turbo (y versión Int8)

**Categoría:** `image_generation`  
**Plantilla Oficial:** `image_z_image_turbo.json`  

---

## 🎯 Descripción y Capacidades

Generador ultraligero y rápido en 4-8 pasos con soporte para cuantización Int8 nativa. Excelente para prototipado rápido de concepts y assets.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `z_image_turbo_fp8.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/z-image/resolve/main/z_image_turbo_fp8.safetensors) |
| `vae` | `ae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/image_generation/z_image_turbo/bootstrap.sh
```
