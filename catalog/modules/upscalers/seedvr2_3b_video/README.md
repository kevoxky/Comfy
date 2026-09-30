# Módulo: SeedVR2 3B Int8 (Video Upscaler Coherente)

**Categoría:** `upscalers`  
**Plantilla Oficial:** `utility_seedvr2_3b_int8_upscale_video.json`  

---

## 🎯 Descripción y Capacidades

Super-resolución temporal de video con SeedVR2 3B. Escala videos a resolución 4K manteniendo coherencia matemática estricta entre fotogramas para eliminar el parpadeo (flickering).

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `upscaler_video_model` | `seedvr2_3b_int8_scaled.safetensors` | `models/upscale_models/` | [Descargar](https://huggingface.co/Comfy-Org/SeedVR2/resolve/main/split_files/upscale_models/seedvr2_3b_int8_scaled.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)
- **ComfyUI-VideoHelperSuite**: [https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/upscalers/seedvr2_3b_video/bootstrap.sh
```
