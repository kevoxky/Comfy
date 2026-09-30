# Módulo: SCAIL-2 (Reemplazo de Personaje en Video)

**Categoría:** `video_generation`  
**Plantilla Oficial:** `video_wan21_scail2_character_replacement.json`  

---

## 🎯 Descripción y Capacidades

Reemplazo de actores y personajes en secuencias de video existentes con el modelo SCAIL-2 sobre Wan 2.1. Sustituye al sujeto manteniendo intacta la iluminación de la escena, la interacción con objetos y la vestimenta.

---

## 💾 Modelos Requeridos

| Rol | Archivo | Destino en ComfyUI | Enlace |
| :--- | :--- | :--- | :--- |
| `scail_model` | `scail2_wan21_14b_fp8.safetensors` | `models/diffusion_models/` | [Descargar](https://huggingface.co/Comfy-Org/SCAIL-2/resolve/main/scail2_wan21_14b_fp8.safetensors) |
| `vae` | `wan_2.1_vae.safetensors` | `models/vae/` | [Descargar](https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors) |

---

## 🧩 Nodos y Dependencias

- **ComfyUI-Manager**: [https://github.com/ltdrdata/ComfyUI-Manager.git](https://github.com/ltdrdata/ComfyUI-Manager.git)
- **ComfyUI-VideoHelperSuite**: [https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git)

---

## 🚀 Instalación en RunPod

```bash
bash catalog/modules/video_generation/scail2_character_replacement/bootstrap.sh
```
