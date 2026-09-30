# Módulo: Flux.2 [Klein] 9B (Edición de Imagen)

**Categoría:** `image_editing`  
**Plantilla Oficial:** `image_flux2_klein_image_edit_9b_base.json`  

---

## 🎯 Descripción y Capacidades

Variante optimizada de 9B parámetros de Flux.2 diseñada específicamente para edición guiada por imagen y texto con preservación de identidad.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `flux2_klein_9b_base.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/flux2-klein-9B/resolve/main/split_files/diffusion_models/flux2_klein_9b_base.safetensors) |
| `text_encoder` | `t5xxl_fp8_e4m3fn_scaled.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn_scaled.safetensors) |
| `vae` | `ae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/image_editing/flux2_klein_9b/bootstrap.sh
```
