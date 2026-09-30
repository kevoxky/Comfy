# Módulo: Lightricks LTX-2.3 (DiT 22B + Gemma 3 12B + Latent Spatial Upscaler)

Ficha técnica y manual de ingeniería para el modelo fundacional de video **LTX-2.3** de Lightricks en ComfyUI. Este documento detalla su funcionamiento, puertos y especificaciones para su futura integración en workflows personalizados.

---

## 🎯 ¿Qué hace este módulo?

LTX-2.3 es uno de los modelos de video de código abierto más avanzados de la industria:
- **Arquitectura DiT de 22 Mil Millones de Parámetros:** Modelo de difusión transformer de gran escala capaz de mantener coherencia anatómica, iluminación física creíble y movimientos complejos de cámara.
- **Comprensión Semántica con Gemma 3 12B IT:** Utiliza el modelo de lenguaje de Google (Gemma 3) con cuantización FP4 mixta y un LoRA "abliterated" (sin censura de razonamiento). Interpreta escenarios complejos, descripciones temporales por etapas y relaciones físicas espaciales.
- **Generación Nativa de Audio Estéreo:** Al igual que MiniMax H3, modela audio y video conjuntamente, sintetizando voces, efectos de sonido de ambiente (viento, pasos, explosiones) y diálogos hablados.
- **Reescalador Espacial en Espacio Latente (2x):** Incorpora el modelo `ltx-2.3-spatial-upscaler-x2-1.1.safetensors` que duplica la resolución directamente sobre los latentes antes de decodificar mediante el VAE, ofreciendo nitidez cinematográfica sin los artefactos de un upscaler de píxeles convencional.
- **Prompt Enhancer Automático:** Integra el nodo LLM `TextGenerateLTX2Prompt` (activable con `prompt_enhance: true`) para reescribir y optimizar la descripción antes de enviarla al DiT.

---

## 🔌 Interfaz de Conexión (Inputs y Outputs)

### Puertos de Entrada (Inputs)
| Puerto | Tipo de Dato | Obligatorio | Descripción / Conexión típica |
| :--- | :--- | :--- | :--- |
| `first_frame` | `IMAGE` | No | Fotograma inicial para Image-to-Video. Si no se conecta o se deja vacío, genera directamente en modo Text-to-Video. |
| `prompt` | `STRING` | Sí | Texto estructurado en 3 componentes: (1) Acciones temporales, (2) Detalles visuales, (3) Sonidos y diálogos entre comillas. |
| `prompt_enhance` | `BOOLEAN` | No | `true` para activar el LLM interno que pule y expande el prompt cinematográficamente; `false` para usar el prompt tal cual. |
| `width` | `INT` | Sí | Ancho en píxeles (default `1280`, múltiplo de 32). |
| `height` | `INT` | Sí | Alto en píxeles (default `720`, múltiplo de 32). |
| `duration` | `INT` | Sí | Duración en segundos (típico `5`). |
| `fps` | `INT` | Sí | Tasa de fotogramas (estándar `25` fps). |
| `seed` | `INT` | No | Semilla de ruido aleatorio. |

### Puertos de Salida (Outputs)
| Puerto | Tipo de Dato | Descripción / Conexión típica |
| :--- | :--- | :--- |
| `video` | `VIDEO` | Objeto de video MP4 con pista de audio estéreo sincronizada. Se conecta directamente a `SaveVideo` o a nodos de postprocesado. |

---

## 🧩 Nodos Técnicos de ComfyUI Utilizados

Este módulo se encapsula en el subgrafo nativo `Image to Video (LTX-2.3)` (UUID: `2454ad83-157c-40dd-9f19-5daaf4041ce0`):

- **Nodos Clave de Carga:**
  - `CheckpointLoaderSimple`: Carga `ltx-2.3-22b-dev-fp8.safetensors` (modelo DiT principal).
  - `LTXAVTextEncoderLoader`: Carga el text encoder `gemma_3_12B_it_fp4_mixed.safetensors` junto con el checkpoint.
  - `LTXVAudioVAELoader` y `LTXVAudioVAEDecode`: Gestión de latentes de audio y síntesis de onda sonora.
  - `LatentUpscaleModelLoader`: Carga el reescalador espacial latente 2x.
  - `LoraLoaderModelOnly`: Inyección del `distilled_lora` para aceleración de muestreo.
  - `LoraLoader`: Inyección del LoRA abliterated en el encoder de texto Gemma 3.
- **Nodos de Procesamiento de Latentes:**
  - `EmptyLTXVLatentVideo` y `LTXVEmptyLatentAudio`: Crean las cuadrículas latentes vacías temporales.
  - `LTXVPreprocess` y `LTXVImgToVideoInplace`: Inyectan la imagen de entrada en los latentes de video.
  - `LTXVConcatAVLatent` y `LTXVSeparateAVLatent`: Concatenan y separan los canales latentes de audio y video para el sampling conjunto.
  - `LTXVLatentUpsampler`: Duplica la resolución espacial en espacio latente.
  - `VAEDecodeTiled`: Decodifica por teselas para optimizar el consumo de VRAM en alta resolución.
  - `CreateVideo`: Empaqueta los frames y la señal de audio en el contenedor final.

---

## 💾 Modelos y Pesajes Requeridos (~40 GB)

| Tipo | Archivo | Destino en ComfyUI | Tamaño | Enlace de Descarga |
| :--- | :--- | :--- | :--- | :--- |
| **Checkpoint DiT 22B** | `ltx-2.3-22b-dev-fp8.safetensors` | `models/checkpoints/` | 27.14 GB | [HuggingFace](https://huggingface.co/Lightricks/LTX-2.3-fp8/resolve/main/ltx-2.3-22b-dev-fp8.safetensors) |
| **Text Encoder (Gemma 3)** | `gemma_3_12B_it_fp4_mixed.safetensors` | `models/text_encoders/` | 8.80 GB | [HuggingFace](https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors) |
| **Distilled LoRA (1.1)** | `ltx_2.3_22b_distilled_1.1_lora_dynamic_fro09_avg_rank_111_bf16.safetensors` | `models/loras/` | 2.55 GB | [HuggingFace](https://huggingface.co/Comfy-Org/ltx-2.3/resolve/main/split_files/loras/ltx_2.3_22b_distilled_1.1_lora_dynamic_fro09_avg_rank_111_bf16.safetensors) |
| **Gemma LoRA (Abliterated)** | `gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors` | `models/loras/` | 0.59 GB | [HuggingFace](https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors) |
| **Spatial Upscaler (2x)** | `ltx-2.3-spatial-upscaler-x2-1.1.safetensors` | `models/latent_upscale_models/` | 0.93 GB | [HuggingFace](https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors) |

---

## 🧠 Estructura Óptima del Prompt para LTX-2.3

El modelo Gemma 3 responde mejor si divides el prompt en tres bloques dentro del mismo texto:
1. **Acciones continuas en el tiempo:** Describe qué hace la cámara y qué hacen los personajes cronológicamente (ej: *"The camera executes a slow push-in; the character turns her head, pauses, and speaks"*).
2. **Detalles visuales específicos:** Iluminación, vestuario, clima y texturas (ej: *"Blue-and-gold headdress, golden embroidery, desert sand drifting with the wind"*).
3. **Audio y Diálogos:** Efectos sonoros y frases exactas entre comillas (ej: *"Sound of wind over dunes, mechanical footsteps. She says: 'The old gods are silent. I am not.'"*).

---

## 🚀 Desempeño en RTX 5090 (32 GB VRAM)

- **Ajuste de Memoria:** El checkpoint FP8 (27 GB) y el Text Encoder FP4 (8.8 GB) se gestionan con el offloading nativo de ComfyUI. Primero codifica con Gemma 3 y luego descarga el encoder para dar el 100% de la VRAM al DiT de 22B, garantizando velocidad máxima sin out-of-memory.
- **Tiempo de Inferencia:** Gracias al LoRA destilado, genera un video de 5 segundos a 720p/1080p en menos de 45 segundos en una RTX 5090.
- **Container Disk en RunPod:** Asignar **80 GB - 100 GB** de disco efímero al iniciar el pod.

---

## 🔗 Comparativa de Arquitectura: MiniMax H3 vs LTX-2.3

| Característica | MiniMax H3 | Lightricks LTX-2.3 |
| :--- | :--- | :--- |
| **Text Encoder** | Qwen3-VL 32B NVFP4 (14.6 GB) | Gemma 3 12B IT FP4 (8.8 GB) |
| **Checkpoint DiT** | UNet Pruned INT8 (19.5 GB) | DiT 22B FP8 (27.1 GB) |
| **Audio** | Audio VAE dedicado (0.56 GB) | Audio VAE integrado en el checkpoint LTXV |
| **Super-Resolución** | Basada en píxeles externos | **Latent Spatial Upscaler 2x integrado** |
| **Estilos por Token** | 10 Embeddings específicos (`embedding:*`) | Prompt Enhancer LLM (`TextGenerateLTX2Prompt`) |
| **Puntos Fuertes** | Interpolar First & Last frame, efectos de sonido | Movimientos cinematográficos de cámara, upscaling latente, razonamiento contextual |
