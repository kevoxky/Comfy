# Módulo: MiniMax Music 3 (Texto a Música DiT)

**Categoría:** `audio_speech`  
**Plantilla Oficial:** `audio_minimax_music_3.json`  

---

## 🎯 Descripción y Capacidades

Generador musical DiT de MiniMax capaz de crear canciones vocales con letra completa, instrumentales y arreglos orquestales/electrónicos.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `minimax_music3_dit_int8_convrot.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-Music-3/resolve/main/diffusion_models/minimax_music3_dit_int8_convrot.safetensors) |
| `text_encoder` | `minimax_music3_text_encoder_pruned_int8_convrot.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-Music-3/resolve/main/text_encoders/minimax_music3_text_encoder_pruned_int8_convrot.safetensors) |
| `audio_vae` | `minimax_music3_dav.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/MiniMax-Music-3/resolve/main/vae/minimax_music3_dav.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/audio_speech/minimax_music_3/bootstrap.sh
```
