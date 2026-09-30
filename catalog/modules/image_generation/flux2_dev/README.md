# Módulo: Flux.2 Dev (Black Forest Labs)

**Categoría:** `image_generation`  
**Plantilla Oficial:** `image_flux2.json`  

---

## 🎯 Descripción y Capacidades

Nueva generación Flux.2 de Black Forest Labs con fotorrealismo extremo, fidelidad de texto inigualable y renderizado de piel y materiales de máxima fidelidad.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `flux2-dev-fp8.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/flux2-dev/resolve/main/split_files/diffusion_models/flux2-dev-fp8.safetensors) |
| `text_encoder_t5` | `t5xxl_fp8_e4m3fn_scaled.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn_scaled.safetensors) |
| `text_encoder_clip` | `clip_l.safetensors` | `models/clip/` | [Descargar](https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors) |
| `vae` | `ae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/image_generation/flux2_dev/bootstrap.sh
```
