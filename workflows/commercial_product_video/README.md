# 🎬 Workflow: Pipeline Publicitario de Lujo (Multi-Shot Ready)

Pipeline profesional de publicidad para **productos de lujo, cosmética y perfumería** a partir de una foto de modelo y una foto de producto real.

Diseñado bajo una arquitectura **modular multi-shot**: en lugar de intentar forzar un anuncio completo en una sola generación, el sistema produce **tomas cinematográficas individuales de alta fidelidad (~5 segundos cada una)** listas para ensamblar en edición.

---

## 🏗️ Arquitectura del Pipeline

```text
[📸 Foto Modelo] ──┐
                  ├──➔ [🧩 QWEN IMAGE EDIT 2511] ──┬──➔ [🖼️ Hero Shot Still (4K)]
[📦 Foto Producto] ─┘              │               │
                                   │               └──➔ [🎬 MINIMAX H3 (Shot 01)] ──➔ [💾 MP4 con Audio]
[✍️ Hero Prompt] ──────────────────┤                                   │
[🛡️ Reglas Preservación] ─────────┘               [✍️ Dirección Cinemática + Audio] ──┘
```

---

## 🧩 Nodos del Workflow

| ID | Nodo | Tipo | Función |
| :--- | :--- | :--- | :--- |
| **1** | `📸 1. Foto de la Modelo / Personaje` | `LoadImage` | Carga el rostro y cuerpo de la modelo de campaña. |
| **2** | `📦 2. Foto Real del Producto` | `LoadImage` | Carga el producto real (frasco, packaging, joyería, etc.). |
| **3** | `✍️ Prompt de Fusión Hero Shot` | `PrimitiveStringMultiline` | Instrucciones fotográficas de integración fotorrealista. |
| **8** | `🛡️ Preservación de Producto e Identidad` | `PrimitiveStringMultiline` | Reglas negativas para evitar deformaciones y mantener fidelidad. |
| **4** | `🧩 FASE 1: Fusión Modelo + Producto` | Subgrafo Qwen 2511 | Integra modelo y producto con iluminación y anatomía de estudio. |
| **9** | `🖼️ Guardar Hero Shot` | `SaveImage` | Exporta la imagen fija en 4K (`commercial/shot_01_hero_still`). |
| **5** | `✍️ Dirección Cinemática y Audio` | `PrimitiveStringMultiline` | Dirección de cámara continua (slow push-in) y pista sonora ambiental. |
| **6** | `🎬 FASE 2: Animación Cinemática Shot 01` | Subgrafo MiniMax H3 | Genera el video continuo de 5 seg con audio estéreo sincronizado. |
| **7** | `💾 Exportación: Shot 01 Hero` | `SaveVideo` | Renderiza el video master MP4 (`commercial/shot_01_hero`). |
| **10** | `📌 Arquitectura Multi-Shot` | `MarkdownNote` | Guía en lienzo para duplicar y crear Shots 2, 3 y 4. |
| **11** | `📐 Selector de Formato` | `MarkdownNote` | Parámetros para alternar entre 16:9 y 9:16. |

---

## 💎 Prompts Optimizados para Campaña de Lujo

### 1. Fusión de Campaña (Nodo 3 — Qwen Image Edit)
```text
High-end commercial campaign photography for a luxury cosmetics and perfume brand. The elegant model from image 1 is gracefully holding the exact product from image 2 with natural, anatomical finger placement and delicate contact. Strict preservation of the model's exact facial identity, bone structure, eye gaze, skin tone, hair style, and physical proportions. The perfume or cosmetic product from image 2 is replicated with 100% fidelity: completely preserving the exact bottle shape, glass bevels, metallic cap, label typography, brand logo, and formulation color. Editorial studio lighting with soft diffused key light, dramatic rim light, and natural caustics reflecting through the glass bottle. Pristine skin texture with visible pores, shallow depth of field, 85mm luxury portraiture, ultra-sharp focus on the product, cinematic color grading, authentic commercial advertising photograph, no AI artifacts.
```

### 2. Preservación e Integridad (Nodo 8 — Reglas Negativas)
```text
deformed fingers, extra digits, missing fingers, malformed hands, distorted grip, unnatural finger bending, altered product shape, modified bottle geometry, warped cap, wrong logo, misspelled text, modified label, changed brand colors, low resolution, blurry details, cartoonish, oversaturated, plastic mannequin skin, CGI appearance, flat amateur lighting, inconsistent facial features, distorted face.
```

### 3. Dirección Cinemática y Audio (Nodo 5 — MiniMax H3: Shot 01)
```text
SHOT 1: Single continuous luxury commercial hero shot. The camera executes a slow, steady cinematic push-in towards the model holding the premium product. The model performs a minimal, graceful motion, subtly turning the product towards the lens with calm, confident elegance. The product remains perfectly rigid, stable, and photorealistic, preserving every detail of the glass bottle, metallic cap, and label. Soft studio rim highlights glide over the surface. Continuous single take, no scene cuts, no camera jumps, no morphing, cinematic 24fps motion blur, high-end perfume commercial.
Audio: deep warm cinematic sub-bass drone, ultra-soft luxury studio air ambience, delicate crystal-clear glass resonance, subtle elegant whoosh synced with the slow camera push-in, pristine high-end sound design, modern sophisticated boutique aesthetic, pure ambient instrumentation without voices.
```

---

## 📐 Selector de Formato (Horizontal vs Vertical)

En el **Nodo 6 (MiniMax H3)**, ajusta los campos de resolución:

* **📺 Horizontal 16:9 (YouTube, TV, Master Web):**
  * `width`: `1280`
  * `height`: `720`
* **📱 Vertical 9:16 (TikTok, Instagram Reels, YouTube Shorts):**
  * `width`: `720`
  * `height`: `1280`

*Nota:* Se mantiene la duración en **`5.0` segundos** para garantizar coherencia temporal y evitar artefactos de movimiento.

---

## 🎬 Cómo Expandir a Multi-Shot (Shot 2, 3 y 4)

Para producir un comercial completo de 15 a 20 segundos sin sobrecargar la generación:

1. **Shot 01 (Hero Shot):** Generado por defecto en este workflow ➔ `commercial/shot_01_hero.mp4`.
2. **Shot 02 (Product Close-Up Macro):**
   * Duplica los Nodos 5, 6 y 7 (`Ctrl+C` y `Ctrl+V`).
   * Conecta la entrada `first_frame` de la nueva copia directamente a la foto del producto (**Nodo 2**).
   * Cambia el prompt a una órbita macro sobre la botella y sus reflejos.
   * Cambia el prefijo de salida a `commercial/shot_02_product`.
3. **Shot 03 (Beauty Shot):**
   * Duplica el bloque MiniMax conectando el resultado de una pose secundaria de la modelo.
   * Cambia el prefijo de salida a `commercial/shot_03_beauty`.
4. **Shot 04 (Packshot / CTA Final):**
   * Plano estático sobre pedestal con destellos de luz e iluminación de catálogo.
   * Cambia el prefijo de salida a `commercial/shot_04_packshot`.

Al terminar las generaciones, solo importas los 4 archivos MP4 en tu editor de video (Premiere, DaVinci Resolve o CapCut) y ya tienes tu spot comercial con música y sonido sincronizado.

---

## 🚀 Despliegue en RunPod

```bash
git clone https://github.com/kevoxky/Comfy.git && cd Comfy && bash workflows/commercial_product_video/bootstrap.sh
```
