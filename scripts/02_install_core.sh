#!/usr/bin/env bash
# ==============================================================================
# Paso 02: Instalación de Dependencias Core, aria2c, FFmpeg y ComfyUI
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

if [ -f ".env.runtime" ]; then
    source .env.runtime
fi

if [ -z "$COMFY_ROOT" ]; then
    COMFY_ROOT="/workspace/runpod-slim/ComfyUI"
fi

echo -e "${BLUE}=== [2/6] Preparando herramientas de descarga, FFmpeg y ComfyUI Core... ===${NC}"

# 1. Instalar aria2 para descargas multihilo ultra-rápidas y FFmpeg para ensamblado
if ! command -v aria2c &> /dev/null || ! command -v ffmpeg &> /dev/null; then
    echo -e "${YELLOW}Instalando aria2c y ffmpeg del sistema...${NC}"
    if command -v apt-get &> /dev/null; then
        apt-get update -qq && apt-get install -y -qq aria2 ffmpeg || true
    fi
else
    echo -e "${GREEN}✓ aria2c y ffmpeg ya están instalados y disponibles.${NC}"
fi

# 2. Clonar ComfyUI si no existe o actualizarlo si ya existe
if [ ! -f "$COMFY_ROOT/main.py" ]; then
    echo -e "${YELLOW}Clonando repositorio oficial de ComfyUI en: $COMFY_ROOT...${NC}"
    mkdir -p "$(dirname "$COMFY_ROOT")"
    git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY_ROOT"
else
    echo -e "${GREEN}✓ ComfyUI encontrado en $COMFY_ROOT. Verificando actualizaciones...${NC}"
    if [ -d "$COMFY_ROOT/.git" ]; then
        (cd "$COMFY_ROOT" && git pull || true)
    fi
fi

# 3. Validar y preservar el PyTorch del contenedor (especialmente en Blackwell / CUDA 13.x)
if python3 -c "import torch; assert torch.cuda.is_available()" 2>/dev/null; then
    echo -e "${GREEN}✓ PyTorch con aceleración CUDA detectado. Preservando versión nativa del contenedor (Blackwell/CUDA).${NC}"
    # Instalar dependencias multimedia y de visión por computador sin tocar torch
    echo -e "${YELLOW}Instalando librerías multimedia y aceleración de visión (opencv, onnxruntime, timm, einops)...${NC}"
    pip install --no-cache-dir soundfile av imageio-ffmpeg opencv-python onnxruntime-gpu timm einops kornia scipy -q || true
    if [ -f "$COMFY_ROOT/requirements.txt" ]; then
        echo -e "${YELLOW}Instalando dependencias de ComfyUI (preservando PyTorch nativo)...${NC}"
        pip install --no-cache-dir -r "$COMFY_ROOT/requirements.txt" --no-deps -q || true
    fi
else
    echo -e "${YELLOW}Instalando dependencias multimedia y ComfyUI core...${NC}"
    pip install --no-cache-dir torchaudio torchvision soundfile av imageio-ffmpeg opencv-python onnxruntime-gpu timm einops kornia scipy -q || true
    if [ -f "$COMFY_ROOT/requirements.txt" ]; then
        pip install --no-cache-dir -r "$COMFY_ROOT/requirements.txt" -q || true
    fi
fi

echo -e "${GREEN}✓ Dependencias Core y multimedia listas.${NC}"
