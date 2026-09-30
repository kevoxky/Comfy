# Módulo: MelBandRoFormer (Separación de Pistas y Voz)

**Categoría:** `audio_speech`  
**Plantilla Oficial:** `audio_melbandroformer_audio_separation.json`  

---

## 🎯 Descripción y Capacidades

Aislamiento de voz humana y separación de stems (voz acapella, bajo, batería, instrumentos) con calidad de estudio usando MelBand-RoFormer.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `separation_model` | `MelBandRoformer_fp16.safetensors` | `models/audio_separation/` | [Descargar](https://huggingface.co/Kijai/MelBandRoFormer_comfy/resolve/main/MelBandRoformer_fp16.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-MelBandRoFormer**: [https://github.com/kijai/ComfyUI-MelBandRoFormer.git](https://github.com/kijai/ComfyUI-MelBandRoFormer.git)
- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/audio_speech/audio_separation_melband/bootstrap.sh
```
