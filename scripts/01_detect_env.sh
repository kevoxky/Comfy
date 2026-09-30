#!/usr/bin/env bash
# ==============================================================================
# Paso 01: Detección de Hardware, GPU y Entorno RunPod
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== [1/6] Verificando Hardware y GPU... ===${NC}"

# 1. Validar GPU NVIDIA
if command -v nvidia-smi &> /dev/null; then
    GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1)
    GPU_VRAM=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader | head -n 1)
    CUDA_VER=$(nvidia-smi | grep -o "CUDA Version: [0-9.]*" | head -n 1)
    echo -e "${GREEN}✓ GPU Detectada:${NC} $GPU_NAME ($GPU_VRAM)"
    echo -e "${GREEN}✓ Driver / CUDA:${NC} $CUDA_VER"
else
    echo -e "${YELLOW}⚠ Advertencia: nvidia-smi no disponible. Continuando en modo genérico.${NC}"
fi

# 2. Validar Python y PyTorch
if command -v python3 &> /dev/null; then
    PY_VER=$(python3 --version 2>&1)
    echo -e "${GREEN}✓ Entorno Python:${NC} $PY_VER"
fi

# 3. Localizar o definir COMFY_ROOT
echo -e "\n${BLUE}=== Localizando instalación de ComfyUI... ===${NC}"
COMFY_DIR=""
POSSIBLE_PATHS=(
    "$COMFY_ROOT"
    "$COMFY_PATH"
    "/workspace/runpod-slim/ComfyUI"
    "/workspace/ComfyUI"
    "/root/ComfyUI"
    "$(pwd)/../ComfyUI"
    "$(pwd)/ComfyUI"
)

for p in "${POSSIBLE_PATHS[@]}"; do
    if [ -n "$p" ] && [ -f "$p/main.py" ]; then
        COMFY_DIR="$p"
        break
    fi
done

if [ -z "$COMFY_DIR" ]; then
    # Por defecto en RunPod estándar
    if [ -d "/workspace/runpod-slim" ]; then
        COMFY_DIR="/workspace/runpod-slim/ComfyUI"
    elif [ -d "/workspace" ]; then
        COMFY_DIR="/workspace/ComfyUI"
    else
        COMFY_DIR="$(pwd)/ComfyUI"
    fi
    echo -e "${YELLOW}ℹ ComfyUI se configurará en la ruta por defecto:${NC} $COMFY_DIR"
else
    echo -e "${GREEN}✓ ComfyUI localizado en:${NC} $COMFY_DIR"
fi

# Guardar variable persistente para los siguientes pasos
echo "export COMFY_ROOT=\"$COMFY_DIR\"" > .env.runtime
chmod +x .env.runtime
echo -e "${GREEN}✓ Entorno de ejecución registrado en .env.runtime${NC}"
