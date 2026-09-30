# 🎬 Workflow: Commercial Product Video (AI Director & Automated Assembly)

Pipeline profesional integral para la producción de **anuncios comerciales cinematográficos de lujo, perfumería y cosmética**, potenciado por un **Director Creativo IA** y un **Sistema de Montaje y Ensamblado Automático Final**.

---

## 🌟 Arquitectura Conceptual Completa

```text
               💡 [IDEA GENERAL DEL ANUNCIO]
                           │
                           ▼
             🎬 [DIRECTOR CREATIVO IA (Nodo 33)]
             ├── Plan de Rodaje & Dirección Artística (JSON)
             ├── Selector Dinámico de Formato (16:9 / 9:16)
             └── Generador de los 8 Prompts Técnicos
                           │
       ┌───────────────────┼───────────────────┬───────────────────┐
       ▼                   ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ 🎬 SHOT 1     │   │ 🎬 SHOT 2     │   │ 🎬 SHOT 3     │   │ 🎬 SHOT 4     │
│ Hero Present. │   │ Product Macro │   │ Model Beauty  │   │ Final Packshot│
│               │   │               │   │               │   │               │
│ Qwen 2511     │   │ Qwen 2511     │   │ Qwen 2511     │   │ Qwen 2511     │
│       ↓       │   │       ↓       │   │       ↓       │   │       ↓       │
│ MiniMax H3    │   │ MiniMax H3    │   │ MiniMax H3    │   │ MiniMax H3    │
│       ↓       │   │       ↓       │   │       ↓       │   │       ↓       │
│ Shot 1 Video  │   │ Shot 2 Video  │   │ Shot 3 Video  │   │ Shot 4 Video  │
└───────┬───────┘   └───────┬───────┘   └───────┬───────┘   └───────┬───────┘
        │                   │                   │                   │
        └───────────────────┼───────────────────┴───────────────────┘
                            ▼
              🎞️ [VIDEO ASSEMBLER (Nodo 35)]
              - Concatenación de clips 1 ➔ 2 ➔ 3 ➔ 4
              - Muxing de pistas de audio estéreo
              - Copia de flujo sin pérdida (-c copy)
                            │
                            ▼
              🏆 [FINAL COMMERCIAL (Nodo 36)]
              output/commercial/final_commercial.mp4
```

---

## 🧠 FASE 1: Director Creativo IA (Nodos 30 a 34)

El usuario no necesita redactar manualmente prompts complejos ni copiar y pegar textos.

### Controles Principales al Inicio del Workflow:
1. **💡 Idea General del Anuncio (Nodo 30):**
   * Describe en lenguaje natural lo que deseas para la campaña.
   * *Ejemplo:* `"Quiero un anuncio de lujo para este perfume. La modelo está en un ambiente nocturno elegante, transmite sensualidad y sofisticación. El producto debe sentirse exclusivo y premium."`
2. **🎨 Estilo Visual (Nodo 33):**
   * Presets disponibles: `Luxury & Exclusive`, `Beauty & Cosmetics`, `Cinematic & Moody`, `High-Tech Minimalist`, `Fresh & Vibrant`.
3. **📐 Selector de Formato (16:9 vs 9:16):**
   * Conmuta dinámicamente entre horizontal (`1280x720`) y vertical (`720x1280`).
   * **Se propaga automáticamente a los 4 MiniMax H3** sin alterar manualmente cada nodo.
4. **⏱️ Duración por Shot:**
   * Ajustable globalmente (5.0 segundos por defecto, para un comercial completo de 20 segundos).

### Salida Conectada de 8 Prompts:
El Director IA produce y conecta directamente los cables hacia:
* `shot_01_image_prompt` ➔ Qwen Shot 1 (Fusión Modelo + Producto)
* `shot_01_video_prompt` ➔ MiniMax Shot 1 (Movimiento de cámara y diseño de audio)
* `shot_02_image_prompt` ➔ Qwen Shot 2 (Composición Macro)
* `shot_02_video_prompt` ➔ MiniMax Shot 2 (Órbita cinemática y audio cristalino)
* `shot_03_image_prompt` ➔ Qwen Shot 3 (Beauty Shot)
* `shot_03_video_prompt` ➔ MiniMax Shot 3 (Glide íntimo y pulso atmosférico)
* `shot_04_image_prompt` ➔ Qwen Shot 4 (Packshot Final con espacio para CTA)
* `shot_04_video_prompt` ➔ MiniMax Shot 4 (Ascenso de pedestal y acorde de cierre)

---

## 🎬 FASE 2: Arquitectura de Rodaje (Shots 1 al 4)

Cada shot se ejecuta de forma física e independiente:
* **SHOT 1 (Hero Model + Product):** Nodo 4 (Qwen) ➔ Nodo 6 (MiniMax) ➔ Nodo 7 (`shot_01_hero.mp4`) + Nodo 9 (Still 4K).
* **SHOT 2 (Product Close-Up / Macro):** Nodo 13 (Qwen) ➔ Nodo 16 (MiniMax) ➔ Nodo 17 (`shot_02_product.mp4`) + Nodo 14 (Still 4K).
* **SHOT 3 (Model Beauty Shot):** Nodo 19 (Qwen) ➔ Nodo 22 (MiniMax) ➔ Nodo 23 (`shot_03_beauty.mp4`) + Nodo 20 (Still 4K).
* **SHOT 4 (Final Packshot / CTA):** Nodo 25 (Qwen) ➔ Nodo 28 (MiniMax) ➔ Nodo 29 (`shot_04_packshot.mp4`) + Nodo 26 (Still 4K).

---

## 🎞️ FASE 3: Montaje y Ensamblado Automático (Nodos 35 y 36)

Una vez generados los 4 clips individuales:
1. **Ensamblado Secuencial (Nodo 35):**
   * Concatena en orden estricto: `SHOT 1` ➔ `SHOT 2` ➔ `SHOT 3` ➔ `SHOT 4`.
   * Preserva resolución, tasa de cuadros (24 FPS) y calidad original sin recodificación innecesaria gracias a FFmpeg stream copy (`-c copy`).
2. **Audio Master Sincronizado:**
   * Mantiene el audio estéreo individual generado por cada MiniMax en perfecta sincronía temporal.
   * Dispone del socket opcional `optional_master_soundtrack` para conectar una pista musical integral en el futuro.
3. **Exportación Final (Nodo 36):**
   * Genera el master publicitario definitivo en:
     `output/commercial/final_commercial.mp4`

---

## 🚀 Despliegue Automatizado en RunPod (RTX 5090)

```bash
git clone https://github.com/kevoxky/Comfy.git && cd Comfy && bash workflows/commercial_product_video/bootstrap.sh
```

El bootstrap detectará el hardware, instalará ComfyUI y las dependencias (FFmpeg, PyAV, VideoHelperSuite), aprovisionará los modelos de difusión y codificadores de texto, y desplegará automáticamente la extensión local `ComfyUI-Commercial-Director`.
