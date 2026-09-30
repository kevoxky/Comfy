#!/usr/bin/env bash
# Bootstrap script for MelBandRoFormer (Separación de Pistas y Voz) (RunPod / RTX 5090)
set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=== Provisioning: MelBandRoFormer (Separación de Pistas y Voz) ===${NC}"

COMFY_ROOT="/workspace/ComfyUI"
for p in "$COMFY_PATH" "/workspace/ComfyUI" "/root/ComfyUI" "$(pwd)"; do
    if [ -n "$p" ] && [ -f "$p/main.py" ]; then COMFY_ROOT="$p"; break; fi
done
cd "$COMFY_ROOT"

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

echo -e "\n${CYAN}Descargando modelos...${NC}"
fast_dl "https://huggingface.co/Kijai/MelBandRoFormer_comfy/resolve/main/MelBandRoformer_fp16.safetensors" "$COMFY_ROOT/models/audio_separation" "MelBandRoformer_fp16.safetensors"

echo -e "\n${CYAN}Instalando nodos de audio...${NC}"
mkdir -p "$COMFY_ROOT/custom_nodes"
cd "$COMFY_ROOT/custom_nodes"
if [ ! -d "ComfyUI-MelBandRoFormer" ]; then
    git clone "https://github.com/kijai/ComfyUI-MelBandRoFormer.git" "ComfyUI-MelBandRoFormer"
else
    (cd "ComfyUI-MelBandRoFormer" && git pull || true)
fi
if [ -f "ComfyUI-MelBandRoFormer/requirements.txt" ]; then pip install --no-cache-dir -r "ComfyUI-MelBandRoFormer/requirements.txt" || true; fi
if [ ! -d "ComfyUI-Manager" ]; then
    git clone "https://github.com/ltdrdata/ComfyUI-Manager.git" "ComfyUI-Manager"
else
    (cd "ComfyUI-Manager" && git pull || true)
fi
if [ -f "ComfyUI-Manager/requirements.txt" ]; then pip install --no-cache-dir -r "ComfyUI-Manager/requirements.txt" || true; fi
cd "$COMFY_ROOT"
pip install --no-cache-dir torchaudio soundfile av librosa || true
echo -e "\n${GREEN}✓ Módulo de audio configurado correctamente.${NC}"
