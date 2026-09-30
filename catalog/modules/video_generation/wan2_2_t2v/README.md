# Módulo: Wan 2.2 14B (Texto a Video Directo)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_wan2_2_14B_t2v.json`  

---

## 🎯 Descripción y Capacidades

Generación directa de video de 14B parámetros desde un prompt textual en Wan 2.2 con soporte para física compleja y simulación de fluidos.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `wan2.2_t2v_14B_fp8_scaled.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_14B_fp8_scaled.safetensors) |
| `text_encoder` | `umt5_xxl_fp8_e4m3fn_scaled.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors) |
| `vae` | `wan_2.1_vae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/video_generation/wan2_2_t2v/bootstrap.sh
```
