# ComfyUI Architecture & Custom Workflows (RunPod / RTX 5090)

Sistema de desarrollo modular para crear y ejecutar workflows profesionales de **ComfyUI** en pods efímeros de **RunPod** con GPUs **NVIDIA RTX 5090 (32 GB VRAM)**.

---

## 🗂️ Arquitectura del Repositorio

El proyecto se divide estrictamente en dos áreas:

```text
Comfy/
├── catalog/                     # 📚 BANCO DE COMPONENTES Y MÓDULOS VERIFICADOS (35 Módulos)
│   ├── README.md                # Índice maestro de componentes registrados
│   └── modules/                 # Especificaciones técnicas por categoría
│       ├── upscalers/           # Ej: SeedVR2 7B Image, SeedVR2 3B Video 4K...
│       ├── video_generation/    # Ej: MiniMax H3, Wan 2.2, Wan Animate 2, LTX-2.5, SCAIL-2...
│       ├── image_generation/    # Ej: Flux.2 Dev, Krea-2, Qwen Image 2.1, Anima Base v1...
│       ├── image_editing/       # Ej: Flux Kontext, Flux.1 Fill Inpaint, Qwen 2511...
│       └── audio_speech/        # Ej: ChatterBox TTS, Stable Audio 3.0, ACE-Step 1.5...
│
└── workflows/                   # 🚀 WORKFLOWS PERSONALIZADOS (Listos para producción)
    └── commercial_product_video/ # Spot publicitario universal: Modelo + Producto ➔ Video 4K
        ├── workflow.json        # Grafo JSON ensamblado y validado
        ├── bootstrap.sh         # Instalador 1-click automático para RunPod
        └── README.md            # Guía operativa y fórmulas de prompts comerciales
```

---

## 🚀 Workflows Personalizados Listos para Usar

| Workflow | Objetivo | Entradas | Salida | Manual |
| :--- | :--- | :--- | :--- | :--- |
| **Spot Publicitario Universal** (`commercial_product_video`) | Genera un comercial cinematográfico con música cinemática y SFX de ambiente para cualquier producto y modelo. | 📸 Foto del Modelo<br>📦 Foto del Producto | 🎬 Video MP4 con audio estéreo sincronizado | [Ver Guía](workflows/commercial_product_video/README.md) |

---

## 📚 Banco de Componentes ([Ver Catálogo Completo](catalog/README.md))

Contamos con **35 módulos de ingeniería certificados**. Cada módulo incluye su especificación técnica, interfaz de puertos (`IMAGE`, `LATENT`, `VIDEO`, `AUDIO`), modelos directos de Hugging Face y script de descarga `aria2c`.

---

## ⚡ Despliegue en 1 Clic en RunPod (Modo Piloto Automático)

Cada vez que inicias un Pod limpio con la **RTX 5090 (32 GB VRAM)**, solo abre la **Terminal Web** y ejecuta este único comando:

```bash
git clone https://github.com/kevoxky/Comfy.git && cd Comfy && bash bootstrap.sh
```

El script se encargará automáticamente de:
1. **Detectar el Hardware:** Valida la GPU (RTX 5090), CUDA y los 32 GB de VRAM.
2. **Instalar el Núcleo:** Localiza o clona ComfyUI e instala `aria2c` para descargas a máxima velocidad.
3. **Instalar Nodos Esenciales:** Clona e instala dependencias de los repositorios declarados en `configs/custom_nodes.json` (`ComfyUI-Manager`, `ComfyUI-VideoHelperSuite`).
4. **Descargar Modelos:** Descarga acelerada mediante `aria2c` (16 hilos) de los pesos oficiales declarados en `configs/models.json` (Qwen Image Edit 2511 + MiniMax H3 + Video/Audio VAEs + LoRAs + imágenes de prueba).
5. **Verificar el Estado:** Ejecuta un *Health Check* automático comprobando la integridad de cada archivo.
6. **Arrancar ComfyUI:** Inicia el servidor optimizado en el puerto `8188`.

Al finalizar, solo presiona **Connect -> HTTP (Port 8188)** en RunPod y tu interfaz estará 100% lista para trabajar. Arrastra `workflows/commercial_product_video/workflow.json` y presiona **Queue Prompt**.

