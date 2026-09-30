# Módulo: Krea-2 Turbo (Estética Artística y Rápida)

**Categoría:** `image_generation`  
**Plantilla Oficial:** `image_krea2_turbo_t2i.json`  

---

## 🎯 Descripción y Capacidades

Modelo de difusión ultra-rápido de Krea AI con acabado artístico curado, excelente estilización y renderizado dinámico en 4-8 pasos.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `diffusion_model` | `krea2_turbo_fp8.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/Krea-2/resolve/main/split_files/diffusion_models/krea2_turbo_fp8.safetensors) |
| `text_encoder` | `qwen2.5_vl_7b_fp8.safetensors` | `models/text_encoders/` | [Descargar](https://huggingface.co/Comfy-Org/Krea-2/resolve/main/split_files/text_encoders/qwen2.5_vl_7b_fp8.safetensors) |
| `vae` | `krea2_vae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/Krea-2/resolve/main/split_files/vae/krea2_vae.safetensors) |

---

## 🧩 Nodos y Dependencias

Nodos requeridos para el funcionamiento en RunPod / RTX 5090:

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)

---

## 🚀 Instalación Rápida (RunPod)

```bash
bash catalog/modules/image_generation/krea2_turbo/bootstrap.sh
```
