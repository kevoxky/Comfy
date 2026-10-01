#!/usr/bin/env bash
# ==============================================================================
# Paso 01: Detección de Hardware, GPU y Entorno RunPod (Soporte Blackwell / Ada / Ampere)
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}=== [1/6] Verificando Hardware, GPU y Arquitectura... ===${NC}"

# 1. Validar GPU NVIDIA con detección avanzada de Arquitectura y VRAM
if command -v nvidia-smi &> /dev/null; then
    GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1 | xargs)
    GPU_VRAM_RAW=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -n 1 | xargs)
    DRIVER_VER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -n 1 | xargs)
    CUDA_VER=$(nvidia-smi | grep -o "CUDA Version: [0-9.]*" | head -n 1 | awk '{print $3}')

    # Calcular VRAM en GB aproximada y limpia
    if [ -n "$GPU_VRAM_RAW" ] && [ "$GPU_VRAM_RAW" -gt 0 ] 2>/dev/null; then
        VRAM_GB=$(( (GPU_VRAM_RAW + 512) / 1024 ))
        VRAM_DISPLAY="~$VRAM_GB GB"
    else
        VRAM_DISPLAY="Desconocida"
    fi

    # Identificación estricta de la Arquitectura de GPU
    if [[ "$GPU_NAME" =~ Blackwell|B100|B200|GB200|6000|5090 ]]; then
        GPU_ARCH="Blackwell"
    elif [[ "$GPU_NAME" =~ 4090|4080|Ada|L40|L4 ]]; then
        GPU_ARCH="Ada Lovelace"
    elif [[ "$GPU_NAME" =~ H100|H200|Hopper ]]; then
        GPU_ARCH="Hopper"
    elif [[ "$GPU_NAME" =~ A100|A10|A6000|Ampere|3090 ]]; then
        GPU_ARCH="Ampere"
    else
        GPU_ARCH="NVIDIA GPU (General)"
    fi

    echo -e "${GREEN}✓ GPU Detectada:${NC} ${BOLD}$GPU_NAME${NC}"
    echo -e "${GREEN}✓ VRAM:${NC} ${BOLD}$VRAM_DISPLAY${NC}"
    echo -e "${GREEN}✓ Arquitectura:${NC} ${BOLD}$GPU_ARCH${NC}"
    echo -e "${GREEN}✓ Driver / CUDA:${NC} Driver ${DRIVER_VER:-N/A} / CUDA ${CUDA_VER:-N/A}"

    # Verificación de compatibilidad con el pipeline (Qwen 2511 + MiniMax H3)
    # RTX PRO 6000 Blackwell (~48GB) o RTX 5090 (~32GB) son óptimas
    if [ -n "$GPU_VRAM_RAW" ] && [ "$GPU_VRAM_RAW" -ge 24000 ] 2>/dev/null; then
        echo -e "${GREEN}✓ GPU compatible con este workflow (Capacidad óptima para Qwen 2511 + MiniMax H3)${NC}"
    elif [ -n "$GPU_VRAM_RAW" ] && [ "$GPU_VRAM_RAW" -ge 16000 ] 2>/dev/null; then
        echo -e "${YELLOW}ℹ GPU compatible con offloading de memoria para modelos DiT.${NC}"
    else
        echo -e "${YELLOW}⚠ Advertencia: VRAM menor a 16GB. La generación cinemática de MiniMax H3 podría requerir quantización adicional.${NC}"
    fi
else
    GPU_NAME="GPU No Detectada"
    GPU_ARCH="Desconocida"
    VRAM_DISPLAY="N/A"
    echo -e "${YELLOW}⚠ Advertencia: nvidia-smi no disponible. Continuando en modo genérico.${NC}"
fi

# 2. Validar Python y PyTorch con CUDA nativo (sin modificar librerías)
if command -v python3 &> /dev/null; then
    PY_VER=$(python3 --version 2>&1)
    echo -e "\n${GREEN}✓ Entorno Python:${NC} $PY_VER"

    # Verificar si PyTorch detecta CUDA nativamente
    python3 - << 'PYEOF' || true
import torch
print(f"\033[0;32m✓ PyTorch:\033[0m {torch.__version__} (CUDA de compilación: {torch.version.cuda or 'N/A'})")
if torch.cuda.is_available():
    dev_name = torch.cuda.get_device_name(0)
    cap = torch.cuda.get_device_capability(0)
    print(f"\033[0;32m✓ PyTorch CUDA:\033[0m Activo ({dev_name} | Compute Capability: {cap[0]}.{cap[1]})")
    # Verificar compatibilidad de atención nativa (SDPA)
    try:
        from torch.nn.functional import scaled_dot_product_attention
        print("\033[0;32m✓ Atención Nativa (SDPA):\033[0m Disponible (máximo rendimiento sin necesidad de xformers binario)")
    except ImportError:
        pass
else:
    print("\033[1;33m⚠ PyTorch CUDA no detectado aún en el intérprete de Python (se verificará en el paso 02/05).\033[0m")
PYEOF
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

# 4. Resolver WORKFLOW_DIR específico
TARGET_WORKFLOW="${1:-$WORKFLOW_DIR}"
if [ -z "$TARGET_WORKFLOW" ]; then
    TARGET_WORKFLOW="workflows/commercial_product_video"
fi

if [ ! -d "$TARGET_WORKFLOW" ] && [ -d "workflows/$TARGET_WORKFLOW" ]; then
    TARGET_WORKFLOW="workflows/$TARGET_WORKFLOW"
fi

TARGET_WORKFLOW_ABS="$(cd "$TARGET_WORKFLOW" 2>/dev/null && pwd || echo "$TARGET_WORKFLOW")"
WORKFLOW_NAME="$(basename "$TARGET_WORKFLOW_ABS")"

echo -e "${GREEN}✓ Workflow Objetivo Seleccionado:${NC} $WORKFLOW_NAME"
echo -e "   Directorio: $TARGET_WORKFLOW_ABS"

# 5. Guardar variables persistentes para los siguientes pasos
cat << EOF > .env.runtime
export COMFY_ROOT="$COMFY_DIR"
export WORKFLOW_DIR="$TARGET_WORKFLOW_ABS"
export WORKFLOW_NAME="$WORKFLOW_NAME"
export GPU_NAME="$GPU_NAME"
export GPU_ARCH="$GPU_ARCH"
export GPU_VRAM="$VRAM_DISPLAY"
EOF
chmod +x .env.runtime
echo -e "${GREEN}✓ Entorno y perfil de GPU registrados en .env.runtime${NC}"
