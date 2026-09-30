#!/usr/bin/env bash
# ==============================================================================
# Lightricks LTX-2.3 (DiT 22B + Gemma 3 12B) - Bootstrap Script for RunPod
# Optimized for NVIDIA RTX 5090 (32GB VRAM) & ComfyUI
# ==============================================================================

set -e

# ANSI Color Codes
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${PURPLE}${BOLD}"
echo "=================================================================="
echo "    Lightricks LTX-2.3 Provisioning (RunPod / RTX 5090)           "
echo "=================================================================="
echo -e "${NC}"

# ------------------------------------------------------------------------------
# 1. Locate ComfyUI Directory
# ------------------------------------------------------------------------------
echo -e "${CYAN}[1/5] Detectando directorio de ComfyUI...${NC}"

POSSIBLE_PATHS=(
    "$COMFY_PATH"
    "$COMFYUI_PATH"
    "/workspace/ComfyUI"
    "/workspace/runpod-slim/ComfyUI"
    "/root/ComfyUI"
    "$(pwd)/ComfyUI"
    "$(pwd)"
)

COMFY_ROOT=""
for p in "${POSSIBLE_PATHS[@]}"; do
    if [ -n "$p" ] && [ -f "$p/main.py" ]; then
        COMFY_ROOT="$p"
        break
    fi
done

if [ -z "$COMFY_ROOT" ]; then
    echo -e "${YELLOW}ComfyUI no encontrado en rutas por defecto. Instalando en /workspace/ComfyUI...${NC}"
    mkdir -p /workspace
    cd /workspace
    git clone https://github.com/comfyanonymous/ComfyUI.git
    COMFY_ROOT="/workspace/ComfyUI"
fi

echo -e "${GREEN}✓ ComfyUI localizado en: ${BOLD}$COMFY_ROOT${NC}"
cd "$COMFY_ROOT"

# ------------------------------------------------------------------------------
# 2. Update ComfyUI & Tools (aria2c)
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[2/5] Actualizando ComfyUI y verificando herramientas...${NC}"

if [ -d ".git" ]; then
    echo -e "Haciendo git pull en ComfyUI..."
    git pull origin master || git pull || echo -e "${YELLOW}Aviso: No se pudo hacer git pull, continuando...${NC}"
fi

if ! command -v aria2c &> /dev/null; then
    echo -e "${YELLOW}Instalando aria2 para descargas multihilo a máxima velocidad...${NC}"
    if command -v apt-get &> /dev/null; then
        apt-get update -qq && apt-get install -y -qq aria2
    fi
fi

fast_download() {
    local url="$1"
    local dest_dir="$2"
    local filename="$3"

    mkdir -p "$dest_dir"
    local target_path="$dest_dir/$filename"

    if [ -f "$target_path" ] && [ $(stat -c%s "$target_path" 2>/dev/null || stat -f%z "$target_path" 2>/dev/null || echo 0) -gt 1048576 ]; then
        echo -e "${GREEN}✓ Ya existe:${NC} $filename (${BOLD}$dest_dir${NC})"
        return 0
    fi

    echo -e "${YELLOW}⬇ Descargando:${NC} $filename -> $dest_dir"
    if command -v aria2c &> /dev/null; then
        aria2c --console-log-level=warn \
               --summary-interval=10 \
               -x 16 -s 16 -k 1M -c \
               -d "$dest_dir" -o "$filename" "$url"
    elif command -v wget &> /dev/null; then
        wget -c -q --show-progress -O "$target_path" "$url"
    else
        curl -L -C - --progress-bar -o "$target_path" "$url"
    fi
    echo -e "${GREEN}✓ Descargado:${NC} $filename"
}

# ------------------------------------------------------------------------------
# 3. Model Downloads (LTX-2.3 Weights ~40 GB total)
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[3/5] Descargando modelos oficiales de LTX-2.3 (~40 GB total)...${NC}"

# 3.1 Checkpoint DiT 22B (FP8 dev)
fast_download \
    "https://huggingface.co/Lightricks/LTX-2.3-fp8/resolve/main/ltx-2.3-22b-dev-fp8.safetensors" \
    "$COMFY_ROOT/models/checkpoints" \
    "ltx-2.3-22b-dev-fp8.safetensors"

# 3.2 Text Encoder (Gemma 3 12B IT FP4 mixed)
fast_download \
    "https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors" \
    "$COMFY_ROOT/models/text_encoders" \
    "gemma_3_12B_it_fp4_mixed.safetensors"

# 3.3 LoRA Distilled 1.1 (Inferencia acelerada)
fast_download \
    "https://huggingface.co/Comfy-Org/ltx-2.3/resolve/main/split_files/loras/ltx_2.3_22b_distilled_1.1_lora_dynamic_fro09_avg_rank_111_bf16.safetensors" \
    "$COMFY_ROOT/models/loras" \
    "ltx_2.3_22b_distilled_1.1_lora_dynamic_fro09_avg_rank_111_bf16.safetensors"

# 3.4 LoRA Text Encoder (Gemma 3 12B IT Abliterated)
fast_download \
    "https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/loras/gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors" \
    "$COMFY_ROOT/models/loras" \
    "gemma-3-12b-it-abliterated_lora_rank64_bf16.safetensors"

# 3.5 Latent Spatial Upscaler x2 (Super-resolución en espacio latente)
fast_download \
    "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors" \
    "$COMFY_ROOT/models/latent_upscale_models" \
    "ltx-2.3-spatial-upscaler-x2-1.1.safetensors"

# 3.6 Sample Input Asset
fast_download \
    "https://raw.githubusercontent.com/Comfy-Org/workflow_templates/main/input/egyptian_queen.png" \
    "$COMFY_ROOT/input" \
    "egyptian_queen.png"

# ------------------------------------------------------------------------------
# 4. Custom Nodes
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[4/5] Instalando Custom Nodes recomendados para LTX-2.3...${NC}"
mkdir -p "$COMFY_ROOT/custom_nodes"
cd "$COMFY_ROOT/custom_nodes"

clone_or_update_node() {
    local repo_url="$1"
    local dir_name="$2"

    if [ -d "$dir_name" ]; then
        echo -e "${GREEN}✓ Nodo presente:${NC} $dir_name (actualizando...)"
        (cd "$dir_name" && git pull || true)
    else
        echo -e "${YELLOW}Clonando:${NC} $dir_name..."
        git clone "$repo_url" "$dir_name"
    fi

    if [ -f "$dir_name/requirements.txt" ]; then
        echo -e "Instalando dependencias de $dir_name..."
        pip install --no-cache-dir -r "$dir_name/requirements.txt" || true
    fi
}

clone_or_update_node "https://github.com/Lightricks/ComfyUI-LTXVideo.git" "ComfyUI-LTXVideo"
clone_or_update_node "https://github.com/ltdrdata/ComfyUI-Manager.git" "ComfyUI-Manager"
clone_or_update_node "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git" "ComfyUI-VideoHelperSuite"

cd "$COMFY_ROOT"
pip install --no-cache-dir torchaudio torchvision soundfile av sentencepiece || true

# ------------------------------------------------------------------------------
# 5. Summary
# ------------------------------------------------------------------------------
echo -e "\n${GREEN}${BOLD}=================================================================="
echo "    ¡CONFIGURACIÓN COMPLETADA! LTX-2.3 listo en ComfyUI           "
echo "==================================================================${NC}"
echo -e "${CYAN}Pesos descargados:${NC}"
echo -e "  • ${BOLD}Checkpoint DiT 22B:${NC}      models/checkpoints/ltx-2.3-22b-dev-fp8.safetensors (27 GB)"
echo -e "  • ${BOLD}Text Encoder Gemma 3:${NC}    models/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors (8.8 GB)"
echo -e "  • ${BOLD}Distilled LoRA:${NC}          models/loras/ltx_2.3_22b_distilled_1.1_... (2.5 GB)"
echo -e "  • ${BOLD}Gemma LoRA:${NC}              models/loras/gemma-3-12b-it-abliterated_... (0.6 GB)"
echo -e "  • ${BOLD}Spatial Upscaler (2x):${NC}   models/latent_upscale_models/ltx-2.3-spatial-upscaler-x2-1.1.safetensors (0.9 GB)"
echo -e "  • ${BOLD}Input Asset:${NC}             input/egyptian_queen.png"
echo "=================================================================="
