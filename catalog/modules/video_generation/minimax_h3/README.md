# Módulo: MiniMax H3 (Video & Audio Nativo)

Ficha técnica y manual de integración para el modelo omnimodal **MiniMax H3** en ComfyUI. Este documento sirve como referencia de ingeniería para conectar este módulo dentro de futuros workflows personalizados.

---

## 🎯 ¿Qué hace este módulo?

MiniMax H3 es un modelo omnimodal de última generación que comprende texto, imagen, video y audio conjuntamente. Su mayor diferenciador es que **genera video con audio estéreo nativo en un solo pase hacia adelante** (diálogos, efectos de sonido y música de fondo modelados en conjunto, no superpuestos a posteriori).

- **Modos de operación:**
  - **Text-to-Video (T2V):** Generación directa desde un prompt descriptivo.
  - **Image-to-Video (I2V):** Animación realista a partir de una imagen inicial (`first_frame`).
  - **First & Last Frame to Video (FL2V):** Genera la transición de movimiento coherente entre dos fotogramas (`first_frame` y `last_frame`).
- **Rendimiento:** Hasta resolución 2K, 24 fps, y duraciones de hasta ~15 segundos.
- **Aceleración Turbo:** Admite LoRAs destilados para generar en tan solo 8 o 4 pasos.

---

## 🔌 Interfaz de Conexión (Inputs y Outputs)

Para conectar este módulo con otros nodos en un workflow compuesto:

### Puertos de Entrada (Inputs)
| Puerto | Tipo de Dato ComfyUI | Obligatorio | Descripción / Conexión típica |
| :--- | :--- | :--- | :--- |
| `first_frame` | `IMAGE` | No | Imagen inicial. Se puede conectar a la salida `IMAGE` de cualquier nodo generador (FLUX, SDXL, LoadImage, etc.). Si está vacío, opera como T2V. |
| `last_frame` | `IMAGE` | No | Imagen final para interpolación temporal controlada entre dos estados. |
| `prompt` | `STRING` | Sí | Texto descriptivo de video y audio. Admite sintaxis `embedding:minimaxh3_<estilo>`. |
| `width` | `INT` | Sí | Ancho en píxeles. Debe ser múltiplo de 32 (ej. 1344, 768, 1024). |
| `height` | `INT` | Sí | Alto en píxeles. Debe ser múltiplo de 32 (ej. 768, 1344, 1024). Eje corto recomendado: 768px. |
| `duration` | `FLOAT` | Sí | Duración en segundos (el modelo ajusta a la cuadrícula de 17k+5 frames a 24fps). |
| `turbo_mode` | `BOOLEAN` | No | `true` para inferencia rápida con Turbo LoRA, `false` para modo estándar. |
| `turbo_steps`| `INT` | No | Número de pasos si `turbo_mode` está activo (`8` o `4`). |

### Puertos de Salida (Outputs)
| Puerto | Tipo de Dato ComfyUI | Descripción / Conexión típica |
| :--- | :--- | :--- |
| `video` | `VIDEO` | Objeto de video nativo con canal de audio multiplexado. Se conecta directamente a nodos de salida como `SaveVideo`, o a procesadores posteriores de video. |

---

## 🧩 Nodos Técnicos de ComfyUI Utilizados

Este módulo utiliza la arquitectura nativa de subgrafos de ComfyUI (incorporada desde la versión `0.33.0`):

- **Nodo Subgrafo:** `Image to Video (MiniMax H3)` (UUID: `4c314f31-ecda-4b08-ae98-faaba1bf613f`).
- **Nodos internos del subgrafo:**
  - `MiniMaxH3ImageToVideo`: Nodo central que procesa la condición multimodal.
  - `UNETLoader`: Carga del modelo de difusión.
  - `CLIPLoader`: Carga del encoder de lenguaje Qwen3-VL con tipo `'minimax'`.
  - `VAELoader` (x2): Carga independiente del VAE de video y del VAE de audio.
  - `LoraLoaderModelOnly`: Inyección del Turbo LoRA cuando `turbo_mode = true`.
  - `SamplerCustomAdvanced` / `KSamplerSelect` / `BasicScheduler`: Motor de muestreo.
  - `VAEDecode`: Decodificación de latentes de video a frames.
  - `VAEDecodeAudio`: Decodificación de latentes de audio a forma de onda estéreo.
  - `CreateVideo`: Combina frames de video y audio en un único contenedor `VIDEO`.

---

## 💾 Modelos y Pesos Requeridos (~41 GB)

| Tipo | Archivo | Destino en ComfyUI | Tamaño | Fuente |
| :--- | :--- | :--- | :--- | :--- |
| **Diffusion Model** | `minimax_h3_fl2va_pruned_int8_convrot.safetensors` | `models/diffusion_models/` | 19.53 GB | [HuggingFace](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors) |
| **Text Encoder** | `qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors` | `models/text_encoders/` | 14.61 GB | [HuggingFace](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors) |
| **Video VAE** | `minimax_h3_video_vae_int8_convrot.safetensors` | `models/vae/` | 2.62 GB | [HuggingFace](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_int8_convrot.safetensors) |
| **Audio VAE** | `minimax_h3_audio_vae_fp32.safetensors` | `models/vae/` | 0.56 GB | [HuggingFace](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors) |
| **Turbo LoRA (8s)** | `minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors` | `models/loras/` | 1.82 GB | [HuggingFace](https://huggingface.co/lightx2v/Minimax-h3-Turbo/resolve/main/minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors) |
| **Turbo LoRA (4s)** | `minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors` | `models/loras/` | 1.82 GB | [HuggingFace](https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/loras/minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors) |
| **Embeddings (x10)** | `minimaxh3_*.safetensors` | `models/embeddings/` | ~5 MB c/u | [HuggingFace](https://huggingface.co/Comfy-Org/MiniMax-H3/tree/main/embeddings) |

---

## 🎨 Embeddings de Estilo Oficiales

Para forzar un estilo específico en el prompt de video y audio, se añade el prefijo `embedding:<nombre>`:
- `embedding:minimaxh3_art_is_explosion`: Efectos pirotécnicos y explosiones dinámicas.
- `embedding:minimaxh3_bullet_time`: Efecto Matrix en cámara superlenta con rotación.
- `embedding:minimaxh3_dark_magic`: Estilo místico y hechicería oscura.
- `embedding:minimaxh3_blooming_flowers`: Lapso de tiempo orgánico floral.
- `embedding:minimaxh3_fire_breath`: Llamas y elementos ígneos.
- `embedding:minimaxh3_four_seasons`: Transición estacional ambiental.
- `embedding:minimaxh3_kiss_camera`: Enfoque cinematográfico de romance/acercamiento.
- `embedding:minimaxh3_spiral_ascent`: Movimiento de cámara helicoidal ascendente.
- `embedding:minimaxh3_storm_magic`: Rayos, tormentas y efectos elementales.
- `embedding:minimaxh3_truman_show`: Estilo satírico televisivo / gran angular retro.

---

## 🔗 Ideas de Integración en Workflows Personalizados

1. **Pipeline: Generador de Personaje ➔ Animación con Voz:**
   - Un módulo de generación de imágenes (ej. FLUX.1 o SDXL) crea un retrato hiperrealista.
   - La salida `IMAGE` del sampler se conecta directamente al `first_frame` de MiniMax H3.
   - El prompt de MiniMax H3 describe el diálogo o la acción y MiniMax genera el video animado con la voz sincronizada.
2. **Pipeline: Storyboard de 2 Cuadros ➔ Transición:**
   - Dos samplers de imagen generan la escena inicial y la escena final.
   - Se conectan a `first_frame` y `last_frame` de MiniMax H3 para crear una transición cinematográfica suave entre ambas escenas con efectos de sonido de ambiente.
3. **Pipeline: MiniMax H3 ➔ Video Upscaler:**
   - La salida `video` se desempaqueta en frames para alimentar un modelo de reescalado de video (ej. Compact/RealESRGAN o Topaz AI en pod) para elevar la resolución a 4K.
