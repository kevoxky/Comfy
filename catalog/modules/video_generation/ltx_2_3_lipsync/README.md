# Módulo: LTX-2.3 Lip-Sync (Imagen y Audio a Video)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_ltx2_3_ia2v.json`  

---

## 🎯 Descripción y Capacidades

Variante de LTX-2.3 alimentada con audio de entrada y fotograma para sincronización labial realista y animación condicionada por voz.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `checkpoint` | `ltx-2.3-22b-dev-fp8.safetensors` | `models/checkpoints/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.3-fp8/resolve/main/ltx-2.3-22b-dev-fp8.safetensors) |
| `text_encoder` | `gemma_3_12B_it_fp4_mixed.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors) |
| `distilled_lora` | `ltx_2.3_22b_distilled_1.1_lora_dynamic_fro09_avg_rank_111_bf16.safetensors` | `models/loras/` | [Descargar](https://huggingface.co/Comfy-Org/ltx-2.3/resolve/main/split_files/loras/ltx_2.3_22b_distilled_1.1_lora_dynamic_fro09_avg_rank_111_bf16.safetensors) |
| `latent_spatial_upscaler` | `ltx-2.3-spatial-upscaler-x2-1.1.safetensors` | `models/latent_upscale_models/` | [Descargar](https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-LTXVideo**: [https://github.com/Lightricks/ComfyUI-LTXVideo.git](https://github.com/Lightricks/ComfyUI-LTXVideo.git)
- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)
- **ComfyUI-VideoHelperSuite**: [https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/video_generation/ltx_2_3_lipsync/bootstrap.sh
```
