# 🎬 Workflow: Commercial Product Video (Full 4-Shot Pipeline)

Pipeline profesional publicitario para **productos de lujo, perfumería y cosmética** a partir de una fotografía de una modelo y una fotografía real de un producto.

El workflow contiene **físicamente implementados los 4 bloques de rodaje (Shots 1 al 4)**, cada uno con su propia integración fotográfica (Qwen Image Edit 2511), su dirección cinemática y diseño sonoro exclusivo (MiniMax H3), y su exportación independiente tanto de video MP4 como de fotografía publicitaria fija en 4K.

---

## 🏗️ Mapa de Rodaje Multi-Shot

```text
[📸 Foto Modelo] ──┬──➔ [SHOT 1: Hero Model + Product] ──➔ Still 4K + MP4 (shot_01_hero)
[📦 Foto Producto] ─┼──➔ [SHOT 2: Product Close-Up]     ──➔ Still 4K + MP4 (shot_02_product)
                   ├──➔ [SHOT 3: Model Beauty Shot]    ──➔ Still 4K + MP4 (shot_03_beauty)
                   └──➔ [SHOT 4: Final Packshot / CTA] ──➔ Still 4K + MP4 (shot_04_packshot)
```

---

## 📋 Estructura de los 4 Shots Implementados

### 🎬 SHOT 1 — HERO MODEL + PRODUCT (Presentación Principal)
* **Objetivo:** La modelo sostiene el producto de forma elegante con un slow cinematic push-in.
* **Fusión (Qwen 2511):** Nodo 4 (`qwen_image_edit_2511_bf16`)
* **Imagen Fija 4K:** Nodo 9 ➔ `output/commercial/shot_01_hero_still`
* **Animación (MiniMax H3):** Nodo 6 (Duración: 5.0 seg)
* **Video Final:** Nodo 7 ➔ `output/commercial/shot_01_hero.mp4`
* **Audio:** Deep warm sub-bass drone, ambiente de estudio de lujo, sutil barrido sincronizado con la cámara.

### 🎬 SHOT 2 — PRODUCT CLOSE-UP / MACRO (Detalle y Reflejos)
* **Objetivo:** Primerísimo plano macro del envase, destacando facetas de vidrio, relieve del logo y tapa metálica.
* **Fusión (Qwen 2511):** Nodo 13
* **Imagen Fija 4K:** Nodo 14 ➔ `output/commercial/shot_02_product_still`
* **Animación (MiniMax H3):** Nodo 16 (Duración: 5.0 seg, slow orbit)
* **Video Final:** Nodo 17 ➔ `output/commercial/shot_02_product.mp4`
* **Audio:** Texturas cristalinas de alta frecuencia, sutil fricción sobre vidrio, micro-clicks elegantes.

### 🎬 SHOT 3 — MODEL BEAUTY SHOT (Primer Plano Sensorial)
* **Objetivo:** Plano medio cerrado de la modelo apreciando o presentando el producto cerca de su cuello/rostro.
* **Fusión (Qwen 2511):** Nodo 19
* **Imagen Fija 4K:** Nodo 20 ➔ `output/commercial/shot_03_beauty_still`
* **Animación (MiniMax H3):** Nodo 22 (Duración: 5.0 seg, suave glide vertical)
* **Video Final:** Nodo 23 ➔ `output/commercial/shot_03_beauty.mp4`
* **Audio:** Drone sensual cálido, shimmer etéreo, roce suave de telas, sofisticado pulso contemporáneo.

### 🎬 SHOT 4 — FINAL PACKSHOT / HERO CTA (Packshot sobre Pedestal)
* **Objetivo:** El producto como protagonista absoluto sobre pedestal de mármol pulido con espacio superior limpio para logotipo y slogan.
* **Fusión (Qwen 2511):** Nodo 25
* **Imagen Fija 4K:** Nodo 26 ➔ `output/commercial/shot_04_packshot_still`
* **Animación (MiniMax H3):** Nodo 28 (Duración: 5.0 seg, pedestal rise & tilt-up)
* **Video Final:** Nodo 29 ➔ `output/commercial/shot_04_packshot.mp4`
* **Audio:** Acorde de sub-bass resolutivo, crescendo con pad orquestal/sintetizador premium, glint sonoro final.

---

## 🛡️ Control Global de Preservación (Nodo 8)

Conectado simultáneamente a las 4 instancias de Qwen 2511 para garantizar:
* Cero deformaciones en manos y dedos.
* 100% de preservación de la forma de la botella, tapa, tipografía, logo y colores originales.
* Fidelidad absoluta de la fisonomía, tono de piel y mirada de la modelo.

---

## 📐 Selector de Formato (Horizontal 16:9 vs Vertical 9:16)

En cualquiera de los nodos MiniMax H3 (Nodos 6, 16, 22 y 28), puedes cambiar la resolución:

* **📺 Formato Horizontal 16:9 (YouTube, TV, Master Web):**
  * `width`: `1280`
  * `height`: `720`
* **📱 Formato Vertical 9:16 (TikTok, Instagram Reels, YouTube Shorts):**
  * `width`: `720`
  * `height`: `1280`

---

## ⚡ Cómo Ejecutar los Shots (Juntos o Individualmente)

1. **Generar los 4 Shots juntos:**
   * Haz clic en **Queue Prompt**. ComfyUI generará en secuencia los 4 Still Images y los 4 Videos MP4 con audio en la carpeta `output/commercial/`.
2. **Generar un solo Shot (Ejemplo: Solo el Shot 1):**
   * Si en algún momento solo quieres generar uno de los shots sin esperar los demás, selecciona los nodos del resto de los shots, haz clic derecho y selecciona **Mute** (o presiona `Ctrl+M`).
   * Para reactivarlo, haz clic derecho y selecciona **Never** (desmutear).

---

## 🚀 Despliegue en 1-Click (RunPod RTX 5090)

```bash
git clone https://github.com/kevoxky/Comfy.git && cd Comfy && bash workflows/commercial_product_video/bootstrap.sh
```
