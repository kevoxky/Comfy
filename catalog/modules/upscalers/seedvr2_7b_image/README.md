# Módulo: SeedVR2 7B Int8 (Image Upscaler de Élite)

**Categoría:** `upscalers`  
**Plantilla Oficial:** `utility_seedvr2_7b_int8_upscale_image.json`  

---

## 🎯 Descripción y Capacidades

El upscaler de imágenes más avanzado para ComfyUI basado en el modelo SeedVR2 de 7B cuantizado en Int8. Restaura detalles ultrafinos de piel, cabello, tela y arquitectura sin inventar artefactos irreales.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `upscaler_model` | `seedvr2_7b_int8_scaled.safetensors` | `models/upscale_models/` | [Descargar](https://huggingface.co/Comfy-Org/SeedVR2/resolve/main/split_files/upscale_models/seedvr2_7b_int8_scaled.safetensors) |
| `vae` | `ae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/upscalers/seedvr2_7b_image/bootstrap.sh
```
