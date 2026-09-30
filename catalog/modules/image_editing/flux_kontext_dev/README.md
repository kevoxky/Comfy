# Módulo: Flux Kontext Dev (Edición Contextual)

**Categoría:** `image_editing`  
**Plantilla Oficial:** `flux_kontext_dev_basic.json`  

---

## 🎯 Descripción y Capacidades

Edición contextual con el modelo Kontext de Black Forest Labs sobre Flux. Permite insertar o modificar elementos respetando la coherencia global de la escena.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `flux1-kontext-dev.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/black-forest-labs/FLUX.1-Kontext-dev/resolve/main/flux1-kontext-dev.safetensors) |
| `vae` | `ae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/image_editing/flux_kontext_dev/bootstrap.sh
```
