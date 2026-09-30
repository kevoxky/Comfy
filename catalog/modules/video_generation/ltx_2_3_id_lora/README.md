# Módulo: LTX-2.3 ID LoRA (Consistencia Facial y Lip-Sync)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_ltx2_3_id_lora.json`  

---

## 🎯 Descripción y Capacidades

Animación de video y sincronización labial con LTX-2.3 utilizando un LoRA de identidad para garantizar que los rasgos faciales del actor no muten a lo largo de las tomas.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `checkpoint` | `ltx-2.3-22b-dev-fp8.safetensors` | `models/checkpoints/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.3-fp8/resolve/main/ltx-2.3-22b-dev-fp8.safetensors) |
| `text_encoder` | `gemma_3_12B_it_fp4_mixed.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-LTXVideo**: [https://github.com/Lightricks/ComfyUI-LTXVideo.git](https://github.com/Lightricks/ComfyUI-LTXVideo.git)
- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/video_generation/ltx_2_3_id_lora/bootstrap.sh
```
