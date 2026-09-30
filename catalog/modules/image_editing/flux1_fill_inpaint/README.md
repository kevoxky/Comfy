# Módulo: Flux.1 Fill Dev (Relleno Generativo e Inpainting)

**Categoría:** `image_editing`  
**Plantilla Oficial:** `flux_fill_inpaint_example.json`  

---

## 🎯 Descripción y Capacidades

Relleno generativo e inpainting con Flux.1 Fill Dev. Elimina o sustituye cualquier sección de una imagen delimitada por una máscara sin dejar costuras visibles.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `flux1-fill-dev.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/black-forest-labs/FLUX.1-Fill-dev/resolve/main/flux1-fill-dev.safetensors) |
| `vae` | `ae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/image_editing/flux1_fill_inpaint/bootstrap.sh
```
