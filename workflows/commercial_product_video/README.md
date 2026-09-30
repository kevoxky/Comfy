# 🎬 Workflow: Spot Publicitario Universal (Modelo + Producto)

Este workflow profesional permite tomar la **foto de un modelo/personaje** y la **foto de cualquier producto** para generar un **video publicitario cinemático de alta gama** con **música ambiental y efectos de sonido de estudio integrados**.

---

## ⚡ Requisitos en RunPod (RTX 5090)

- **GPU:** NVIDIA RTX 5090 (32 GB VRAM)
- **Container Disk (Disco efímero):** Asignar **80 GB - 100 GB** al crear el pod.
- **Tiempo de descarga:** ~1 a 2 minutos gracias a la red de alta velocidad de RunPod y el script multihilo `aria2c`.
- **Tiempo de renderizado:** ~30 a 50 segundos por video con el motor Turbo LoRA activado.

---

## 🚀 Puesta en marcha en 1-Click (RunPod)

En la terminal web de RunPod (o vía SSH), ejecuta:

```bash
bash workflows/commercial_product_video/bootstrap.sh
```

El script se encargará automáticamente de:
1. Actualizar ComfyUI a la última versión compatible.
2. Descargar todos los modelos y pesajes necesarios (`MiniMax H3` unet, text encoder, VAEs de video y audio, y Turbo LoRA de 8 pasos).
3. Instalar los custom nodes esenciales (`ComfyUI-Manager`, `ComfyUI-VideoHelperSuite`).

---

## 🎨 Cómo usar el Workflow en ComfyUI

1. Abre la interfaz web de ComfyUI en tu navegador.
2. Arrastra el archivo [`workflow.json`](workflow.json) al lienzo de ComfyUI o cárgalo desde el menú **Load**.
3. **Carga tus imágenes en los nodos de la izquierda:**
   - **Nodo 1 (📸 Foto del Modelo):** Sube la foto del personaje o modelo.
   - **Nodo 2 (📦 Foto del Producto):** Sube la foto del producto (de preferencia con buena iluminación o fondo recortado/transparente).
4. **Ajusta el Prompt del Spot (Nodo central ✍️):**
   Puedes usar una de las fórmulas universales que se muestran abajo.
5. **Haz clic en `Queue Prompt`:**
   El resultado final se guardará automáticamente en formato MP4 con su pista de audio estéreo en la carpeta `output/commercial/`.

---

## 📝 Fórmulas de Prompts Universales para Comerciales

El motor de video y audio entiende descripciones cinematográficas divididas en tomas de cámara y estilo sonoro. Aquí tienes 3 plantillas listas para copiar y pegar:

### 💎 Plantilla A: Estudio de Lujo y Elegancia (Perfumes, Relojes, Joyería, Moda)
```text
Luxury commercial film. The model presents the product in a sleek dark studio void with subtle reflective ground and warm amber rim lighting.
SHOT 1: The camera executes a slow, deliberate push-in towards the product as delicate highlights glisten along the contours and logo.
SHOT 2: Gentle camera orbit, the model holds the product with elegance, warm soft flares reflecting across the surface.
Audio: deep elegant cinematic bass pulse, soft glassy sweeps, delicate tactile mechanical clicks, and modern luxury electronic swell resolving smoothly.
```

### ⚡ Plantilla B: Tecnología y Gadgets (Auriculares, Periféricos, Electrónica)
```text
High-tech commercial film. The model interacts with the product in a futuristic dark room with neon cyan and magenta studio lighting.
SHOT 1: Macro cinematic push-in focusing on the detailed textures, buttons, and metallic finish of the product.
SHOT 2: Low-angle beauty orbit, the lights slowly pulse brighter, creating sharp neon streaks and crisp shadows.
Audio: deep futuristic sub-bass room tone, sharp tactile clicks, sweeping electronic whoosh on camera moves, and a modern synth swell.
```

### 🌿 Plantilla C: Frescura, Belleza y Alimentos (Bebidas, Skincare, Cosmética Natural)
```text
Fresh commercial aesthetic film. The model holds the product in a bright, sun-drenched minimalist studio with soft morning light and natural shadows.
SHOT 1: Clean camera push-in showing crisp condensation or natural textures on the product.
SHOT 2: The model smiles gently as sunlight creates a golden lens flare across the frame.
Audio: uplifting and airy ambient music, subtle crisp water droplets or bottle opening sound effect, smooth airy acoustic swell.
```

---

## ⚙️ Parámetros Recomendados

- **Resolución:** `1280x720` (horizontal cinematográfico) o `720x1280` (vertical 9:16 para TikTok / Reels / Shorts). *Ambos deben ser múltiplos de 32.*
- **Duración:** `5.0` segundos (estándar comercial rápido).
- **Turbo Mode:** Activado por defecto (`turbo_mode: true`, `turbo_steps: 8`) para obtener resultados en menos de 1 minuto en la RTX 5090.
