#!/usr/bin/env bash
# Bootstrap script for Lightricks LTX-2.5 (DiT 22B + Gemma 4 12B) (RunPod / RTX 5090)
set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=== Provisioning: Lightricks LTX-2.5 (DiT 22B + Gemma 4 12B) ===${NC}"

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
fast_dl "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/diffusion_models/ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors" "$COMFY_ROOT/models/diffusion_models" "ltx-2.5-22b-distilled-transformer-comfy-int8-convrot.safetensors"
fast_dl "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/text_encoders/gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors" "$COMFY_ROOT/models/text_encoders" "gemma4-12b-with-proj-ltx-2.5-comfy-int8-convrot.safetensors"
fast_dl "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-video-vae-bf16.safetensors" "$COMFY_ROOT/models/vae" "ltx-2.5-video-vae-bf16.safetensors"
fast_dl "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/vae/ltx-2.5-audio-vae-bf16.safetensors" "$COMFY_ROOT/models/vae" "ltx-2.5-audio-vae-bf16.safetensors"
fast_dl "https://huggingface.co/Lightricks/LTX-2.5/resolve/main/latent_upscale_models/ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors" "$COMFY_ROOT/models/latent_upscale_models" "ltx-2.5-latent-spatial-upscaler-x2-bf16-1.0.safetensors"

echo -e "\n${CYAN}Instalando nodos personalizados...${NC}"
mkdir -p "$COMFY_ROOT/custom_nodes"
cd "$COMFY_ROOT/custom_nodes"
if [ ! -d "ComfyUI-LTXVideo" ]; then
    git clone "https://github.com/Lightricks/ComfyUI-LTXVideo.git" "ComfyUI-LTXVideo"
else
    (cd "ComfyUI-LTXVideo" && git pull || true)
fi
if [ -f "ComfyUI-LTXVideo/requirements.txt" ]; then pip install --no-cache-dir -r "ComfyUI-LTXVideo/requirements.txt" || true; fi
if [ ! -d "ComfyUI-Manager" ]; then
    git clone "https://github.com/ltdrdata/ComfyUI-Manager.git" "ComfyUI-Manager"
else
    (cd "ComfyUI-Manager" && git pull || true)
fi
if [ -f "ComfyUI-Manager/requirements.txt" ]; then pip install --no-cache-dir -r "ComfyUI-Manager/requirements.txt" || true; fi
if [ ! -d "ComfyUI-VideoHelperSuite" ]; then
    git clone "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git" "ComfyUI-VideoHelperSuite"
else
    (cd "ComfyUI-VideoHelperSuite" && git pull || true)
fi
if [ -f "ComfyUI-VideoHelperSuite/requirements.txt" ]; then pip install --no-cache-dir -r "ComfyUI-VideoHelperSuite/requirements.txt" || true; fi
cd "$COMFY_ROOT"
echo -e "\n${GREEN}✓ ¡Entorno listo para cargar este módulo!${NC}"
