#!/usr/bin/env bash
# ==============================================================================
# Commercial Product Video (Universal Workflow) - Bootstrap Script for RunPod
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
echo "   Spot Publicitario Universal: Modelo + Producto (RTX 5090)     "
echo "=================================================================="
echo -e "${NC}"

# 1. Locate ComfyUI
echo -e "${CYAN}[1/5] Detectando ComfyUI...${NC}"
COMFY_ROOT="/workspace/ComfyUI"
POSSIBLE_PATHS=(
    "$COMFY_PATH"
    "$COMFYUI_PATH"
    "/workspace/ComfyUI"
    "/workspace/runpod-slim/ComfyUI"
    "/root/ComfyUI"
    "$(pwd)/ComfyUI"
    "$(pwd)"
)

for p in "${POSSIBLE_PATHS[@]}"; do
    if [ -n "$p" ] && [ -f "$p/main.py" ]; then
        COMFY_ROOT="$p"
        break
    fi
done

echo -e "${GREEN}✓ ComfyUI localizado en: ${BOLD}$COMFY_ROOT${NC}"
cd "$COMFY_ROOT"

# 2. Update ComfyUI & Tools (aria2c)
echo -e "\n${CYAN}[2/5] Actualizando ComfyUI y verificando herramientas...${NC}"
if [ -d ".git" ]; then
    git pull origin master || git pull || true
fi

if ! command -v aria2c &> /dev/null; then
    echo -e "${YELLOW}Instalando aria2 para descargas multihilo a máxima velocidad...${NC}"
    if command -v apt-get &> /dev/null; then
        apt-get update -qq && apt-get install -y -qq aria2 || true
    fi
fi

fast_download() {
    local url="$1"
    local dest_dir="$2"
    local filename="$3"

    mkdir -p "$dest_dir"
    local target_path="$dest_dir/$filename"

    if [ -f "$target_path" ] && [ $(stat -c%s "$target_path" 2>/dev/null || echo 0) -gt 1048576 ]; then
        echo -e "${GREEN}✓ Ya existe:${NC} $filename"
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

# 3. Model Downloads
echo -e "\n${CYAN}[3/5] Descargando modelos requeridos...${NC}"

# 3.1 FASE 1: Qwen Image Edit 2511 (Fusión Modelo + Producto)
echo -e "${YELLOW}Descargando modelos de la Fase 1 (Fusión Fotorrealista)...${NC}"
fast_download \
    "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2511_bf16.safetensors" \
    "$COMFY_ROOT/models/diffusion_models" \
    "qwen_image_edit_2511_bf16.safetensors"

fast_download \
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" \
    "$COMFY_ROOT/models/text_encoders" \
    "qwen_2.5_vl_7b_fp8_scaled.safetensors"

fast_download \
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors" \
    "$COMFY_ROOT/models/vae" \
    "qwen_image_vae.safetensors"

fast_download \
    "https://huggingface.co/lightx2v/Qwen-Image-Edit-2511-Lightning/resolve/main/Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors" \
    "$COMFY_ROOT/models/loras" \
    "Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors"

# 3.2 FASE 2: MiniMax H3 (Video Cinemático + Audio Estéreo Nativo)
echo -e "\n${YELLOW}Descargando modelos de la Fase 2 (Video y Audio Cinemático)...${NC}"
fast_download \
    "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors" \
    "$COMFY_ROOT/models/diffusion_models" \
    "minimax_h3_fl2va_pruned_int8_convrot.safetensors"

fast_download \
    "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors" \
    "$COMFY_ROOT/models/text_encoders" \
    "qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors"

fast_download \
    "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_int8_convrot.safetensors" \
    "$COMFY_ROOT/models/vae" \
    "minimax_h3_video_vae_int8_convrot.safetensors"

fast_download \
    "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors" \
    "$COMFY_ROOT/models/vae" \
    "minimax_h3_audio_vae_fp32.safetensors"

fast_download \
    "https://huggingface.co/lightx2v/Minimax-h3-Turbo/resolve/main/minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors" \
    "$COMFY_ROOT/models/loras" \
    "minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors"

# 3.3 Imágenes de muestra inicial (listas para probar de inmediato)
fast_download \
    "https://raw.githubusercontent.com/Comfy-Org/workflow_templates/refs/heads/main/input/portrait_model_denim.png" \
    "$COMFY_ROOT/input" \
    "model_reference.png"

fast_download \
    "https://raw.githubusercontent.com/Comfy-Org/workflow_templates/refs/heads/main/input/transparent_rgb_gaming_mouse.png" \
    "$COMFY_ROOT/input" \
    "product_reference.png"

# 4. Custom Nodes
echo -e "\n${CYAN}[4/5] Instalando Custom Nodes...${NC}"
mkdir -p "$COMFY_ROOT/custom_nodes"
cd "$COMFY_ROOT/custom_nodes"

clone_or_update() {
    local repo="$1"
    local folder="$2"
    if [ ! -d "$folder" ]; then
        git clone "$repo" "$folder"
    else
        (cd "$folder" && git pull || true)
    fi
    if [ -f "$folder/requirements.txt" ]; then
        pip install --no-cache-dir -r "$folder/requirements.txt" || true
    fi
}

clone_or_update "https://github.com/ltdrdata/ComfyUI-Manager.git" "ComfyUI-Manager"
clone_or_update "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git" "ComfyUI-VideoHelperSuite"

cd "$COMFY_ROOT"
pip install --no-cache-dir torchaudio torchvision soundfile av || true

# 5. Done
echo -e "\n${GREEN}${BOLD}=================================================================="
echo "    ¡ENTORNO LISTO! Modelos y Nodos Instalados al 100%           "
echo "==================================================================${NC}"
echo "1. Abre la interfaz web de ComfyUI."
echo "2. Arrastra 'workflows/commercial_product_video/workflow.json'."
echo "3. Sube la foto del modelo (nodo 1) y del producto (nodo 2)."
echo "4. Haz clic en 'Queue Prompt' para generar tu spot publicitario."
echo "=================================================================="
