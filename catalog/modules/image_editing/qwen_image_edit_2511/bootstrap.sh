#!/usr/bin/env bash
# Bootstrap script for Qwen Image Edit 2511 (Reemplazo de Materiales) (RunPod / RTX 5090)
set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=== Provisioning: Qwen Image Edit 2511 (Reemplazo de Materiales) ===${NC}"

# Locate ComfyUI
COMFY_ROOT="/workspace/ComfyUI"
for p in "$COMFY_PATH" "/workspace/ComfyUI" "/root/ComfyUI" "$(pwd)"; do
    if [ -n "$p" ] && [ -f "$p/main.py" ]; then COMFY_ROOT="$p"; break; fi
done
cd "$COMFY_ROOT"

# Update ComfyUI & ensure aria2
if [ -d ".git" ]; then git pull || true; fi
if ! command -v aria2c &> /dev/null; then
    apt-get update -qq && apt-get install -y -qq aria2 || true
fi

fast_dl() {
    local url="$1"; local dir="$2"; local name="$3"
    mkdir -p "$dir"
    local target="$dir/$name"
    if [ -f "$target" ] && [ $(stat -c%s "$target" 2>/dev/null || echo 0) -gt 1048576 ]; then
        echo -e "${GREEN}✓ Ya existe:${NC} $name"
        return 0
    fi
    echo -e "${YELLOW}⬇ Descargando:${NC} $name -> $dir"
    if command -v aria2c &> /dev/null; then
        aria2c --console-log-level=warn --summary-interval=10 -x 16 -s 16 -k 1M -c -d "$dir" -o "$name" "$url"
    else
        curl -L -C - --progress-bar -o "$target" "$url"
    fi
}

echo -e "\n${CYAN}Descargando modelos requeridos...${NC}"
fast_dl "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2511_bf16.safetensors" "$COMFY_ROOT/models/diffusion_models" "qwen_image_edit_2511_bf16.safetensors"
fast_dl "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" "$COMFY_ROOT/models/text_encoders" "qwen_2.5_vl_7b_fp8_scaled.safetensors"
fast_dl "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors" "$COMFY_ROOT/models/vae" "qwen_image_vae.safetensors"
fast_dl "https://huggingface.co/lightx2v/Qwen-Image-Edit-2511-Lightning/resolve/main/Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors" "$COMFY_ROOT/models/loras" "Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors"

echo -e "\n${CYAN}Instalando nodos personalizados...${NC}"
mkdir -p "$COMFY_ROOT/custom_nodes"
cd "$COMFY_ROOT/custom_nodes"
if [ ! -d "ComfyUI-Manager" ]; then
    git clone "https://github.com/ltdrdata/ComfyUI-Manager.git" "ComfyUI-Manager"
else
    (cd "ComfyUI-Manager" && git pull || true)
fi
if [ -f "ComfyUI-Manager/requirements.txt" ]; then pip install --no-cache-dir -r "ComfyUI-Manager/requirements.txt" || true; fi
cd "$COMFY_ROOT"
echo -e "\n${GREEN}✓ ¡Entorno listo para cargar este módulo!${NC}"
