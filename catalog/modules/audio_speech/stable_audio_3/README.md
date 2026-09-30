# Módulo: Stable Audio 3.0 Medium (Stability AI)

**Categoría:** `audio_speech`  
**Plantilla Oficial:** `audio_stable_audio_3_medium.json`  

---

## 🎯 Descripción y Capacidades

Modelo fundacional de audio de Stability AI para generación de efectos de sonido cinematográficos, ambientes espaciales y texturas musicales de alta definición.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `checkpoint` | `stable_audio_3_medium.safetensors` | `models/checkpoints/` | [Descargar](https://huggingface.co/Comfy-Org/stable-audio-3/resolve/main/checkpoints/stable_audio_3_medium.safetensors) |
| `text_encoder_t5gemma` | `t5gemma_b_b_ul2.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/stable-audio-3/resolve/main/text_encoders/t5gemma_b_b_ul2.safetensors) |
| `text_encoder_qwen` | `qwen3.5_2b_bf16.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/Qwen3.5/resolve/main/text_encoders/qwen3.5_2b_bf16.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/audio_speech/stable_audio_3/bootstrap.sh
```
