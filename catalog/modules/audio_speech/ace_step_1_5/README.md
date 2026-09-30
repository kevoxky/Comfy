# Módulo: ACE-Step 1.5XL Turbo (Texto a Música y Canciones)

**Categoría:** `audio_speech`  
**Plantilla Oficial:** `audio_ace_step1_5_xl_turbo.json`  

---

## 🎯 Descripción y Capacidades

Modelo avanzado de composición musical con soporte para generación de pistas instrumentales completas, armonías, percusión y canciones con estructura lírica.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `acestep_v1.5_xl_turbo_bf16.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/ace_step_1.5_ComfyUI_files/resolve/main/split_files/diffusion_models/acestep_v1.5_xl_turbo_bf16.safetensors) |
| `vae` | `ace_1.5_vae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/ace_step_1.5_ComfyUI_files/resolve/main/split_files/vae/ace_1.5_vae.safetensors) |
| `text_encoder_4b` | `qwen_4b_ace15.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/ace_step_1.5_ComfyUI_files/resolve/main/split_files/text_encoders/qwen_4b_ace15.safetensors) |
| `text_encoder_0.6b` | `qwen_0.6b_ace15.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/ace_step_1.5_ComfyUI_files/resolve/main/split_files/text_encoders/qwen_0.6b_ace15.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/audio_speech/ace_step_1_5/bootstrap.sh
```
