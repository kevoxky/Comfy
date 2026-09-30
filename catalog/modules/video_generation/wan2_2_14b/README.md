# Módulo: Wan 2.2 14B (Alibaba Video Generation)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_wan2_2_14B_i2v.json`  

---

## 🎯 Descripción y Capacidades

Modelo fundacional de video Wan 2.2 de 14B parámetros de Alibaba. Genera dinámicas físicas hiperrealistas, movimiento fluido y soporte para LoRA 4-steps LightX2V.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model_high_noise` | `wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors) |
| `diffusion_model_low_noise` | `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors) |
| `text_encoder` | `umt5_xxl_fp8_e4m3fn_scaled.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors) |
| `vae` | `wan_2.1_vae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors) |
| `lora_4step_high` | `wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors` | `models/loras/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors) |
| `lora_4step_low` | `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors` | `models/loras/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)
- **ComfyUI-VideoHelperSuite**: [https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/video_generation/wan2_2_14b/bootstrap.sh
```
