# Módulo: Wan Animate 2 (Transferencia de Movimiento)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_wan_animate2.json`  

---

## 🎯 Descripción y Capacidades

Transferencia de movimiento completa (Motion Transfer). Extrae la pose, dinámica y cinemática de un video real y se la transfiere a una imagen estática de cualquier personaje usando el motor Wan 2.2 / 2.1.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `wan_animate_model` | `wan2.1_animate_14B_fp8.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_animate_14B_fp8.safetensors) |
| `text_encoder` | `umt5_xxl_fp8_e4m3fn_scaled.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors) |
| `vae` | `wan_2.1_vae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)
- **ComfyUI-VideoHelperSuite**: [https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/video_generation/wan_animate2/bootstrap.sh
```
