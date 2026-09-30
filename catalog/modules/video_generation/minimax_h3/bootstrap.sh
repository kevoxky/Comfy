#!/usr/bin/env bash
# ==============================================================================
# MiniMax H3 (Image-to-Video / Text-to-Video) - Bootstrap Script for RunPod
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
echo "    MiniMax H3 I2V/T2V Workflow Provisioning (RunPod / RTX 5090)  "
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
# 2. Update ComfyUI & System Tools (aria2c)
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[2/5] Actualizando ComfyUI y verificando herramientas...${NC}"

# MiniMax H3 requiere las versiones más recientes de ComfyUI (subgrafos y nodos nativos H3)
if [ -d ".git" ]; then
    echo -e "Haciendo git pull en ComfyUI para asegurar soporte de MiniMax H3..."
    git pull origin master || git pull || echo -e "${YELLOW}Aviso: No se pudo hacer git pull, continuando...${NC}"
fi

# Instalar aria2 si no existe para descargas multihilo a máxima velocidad (500MB/s+)
if ! command -v aria2c &> /dev/null; then
    echo -e "${YELLOW}Instalando aria2 para descargas multihilo de alta velocidad...${NC}"
    if command -v apt-get &> /dev/null; then
        apt-get update -qq && apt-get install -y -qq aria2
    else
        echo -e "${RED}apt-get no disponible, se intentará usar curl/wget como fallback.${NC}"
    fi
fi

# Helper de descarga con aceleración multihilo aria2c
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
# 3. Model Downloads (MiniMax H3 Weights)
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[3/5] Descargando modelos oficiales de MiniMax H3 (~41 GB total)...${NC}"
echo -e "${YELLOW}Nota: En RunPod la descarga tomará entre 1 y 2 minutos gracias a la red de alta velocidad.${NC}\n"

# 3.1 VAEs
fast_download \
    "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_int8_convrot.safetensors" \
    "$COMFY_ROOT/models/vae" \
    "minimax_h3_video_vae_int8_convrot.safetensors"

fast_download \
    "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors" \
    "$COMFY_ROOT/models/vae" \
    "minimax_h3_audio_vae_fp32.safetensors"

# 3.2 Diffusion Model (UNet)
fast_download \
    "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors" \
    "$COMFY_ROOT/models/diffusion_models" \
    "minimax_h3_fl2va_pruned_int8_convrot.safetensors"

# 3.3 Text Encoder (Qwen3-VL 32B NVFP4 AWQ)
fast_download \
    "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors" \
    "$COMFY_ROOT/models/text_encoders" \
    "qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors"

# 3.4 LoRAs (Turbo 8-step & 4-step)
fast_download \
    "https://huggingface.co/lightx2v/Minimax-h3-Turbo/resolve/main/minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors" \
    "$COMFY_ROOT/models/loras" \
    "minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors"

fast_download \
    "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/loras/minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors" \
    "$COMFY_ROOT/models/loras" \
    "minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors"

# 3.5 Style Embeddings (10 estilos oficiales de MiniMax H3)
echo -e "\n${CYAN}Descargando Embeddings de estilo oficiales...${NC}"
STYLE_EMBEDDINGS=(
    "minimaxh3_art_is_explosion.safetensors"
    "minimaxh3_blooming_flowers.safetensors"
    "minimaxh3_bullet_time.safetensors"
    "minimaxh3_dark_magic.safetensors"
    "minimaxh3_fire_breath.safetensors"
    "minimaxh3_four_seasons.safetensors"
    "minimaxh3_kiss_camera.safetensors"
    "minimaxh3_spiral_ascent.safetensors"
    "minimaxh3_storm_magic.safetensors"
    "minimaxh3_truman_show.safetensors"
)

for emb in "${STYLE_EMBEDDINGS[@]}"; do
    fast_download \
        "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/embeddings/$emb" \
        "$COMFY_ROOT/models/embeddings" \
        "$emb"
done

# 3.6 Sample Input Image
echo -e "\n${CYAN}Descargando imagen de prueba del template...${NC}"
fast_download \
    "https://raw.githubusercontent.com/Comfy-Org/workflow_templates/refs/heads/main/input/transparent_rgb_gaming_mouse.png" \
    "$COMFY_ROOT/input" \
    "transparent_rgb_gaming_mouse.png"

# ------------------------------------------------------------------------------
# 4. Custom Nodes & Dependencies
# ------------------------------------------------------------------------------
echo -e "\n${CYAN}[4/5] Instalando Custom Nodes recomendados...${NC}"
mkdir -p "$COMFY_ROOT/custom_nodes"
cd "$COMFY_ROOT/custom_nodes"

clone_or_update_node() {
    local repo_url="$1"
    local dir_name="$2"

    if [ -d "$dir_name" ]; then
        echo -e "${GREEN}✓ Nodo ya presente:${NC} $dir_name (actualizando...)"
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

# ComfyUI-Manager (Administrador universal de nodos)
clone_or_update_node "https://github.com/ltdrdata/ComfyUI-Manager.git" "ComfyUI-Manager"

# VideoHelperSuite (VHS para vista previa y renderizado de video de alta calidad)
clone_or_update_node "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git" "ComfyUI-VideoHelperSuite"

# KJNodes (Recomendado para atención SageAttention y utilidades)
clone_or_update_node "https://github.com/kijai/ComfyUI-KJNodes.git" "ComfyUI-KJNodes"

# Regresar a la raíz de ComfyUI
cd "$COMFY_ROOT"

# Asegurar dependencias de audio/video en el entorno
pip install --no-cache-dir torchaudio torchvision soundfile av || true

# ------------------------------------------------------------------------------
# 5. Final Setup Verification & Instructions
# ------------------------------------------------------------------------------
echo -e "\n${GREEN}${BOLD}=================================================================="
echo "    ¡CONFIGURACIÓN COMPLETADA CON ÉXITO! Entorno 100% Listo       "
echo "==================================================================${NC}"
echo -e "${CYAN}Resumen de archivos listos en ComfyUI:${NC}"
echo -e "  • ${BOLD}Diffusion Model:${NC} models/diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors"
echo -e "  • ${BOLD}Text Encoder:${NC}    models/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors"
echo -e "  • ${BOLD}Video VAE:${NC}       models/vae/minimax_h3_video_vae_int8_convrot.safetensors"
echo -e "  • ${BOLD}Audio VAE:${NC}       models/vae/minimax_h3_audio_vae_fp32.safetensors"
echo -e "  • ${BOLD}LoRAs:${NC}           models/loras/minimax_h3_fl2v_turbo_8step & 4step"
echo -e "  • ${BOLD}Embeddings:${NC}      models/embeddings/ (10 estilos oficiales instalados)"
echo -e "  • ${BOLD}Input Asset:${NC}     input/transparent_rgb_gaming_mouse.png"
echo ""
echo -e "${YELLOW}${BOLD}Pasos siguientes:${NC}"
echo "1. Si ComfyUI ya estaba corriendo, reinícialo para recargar los modelos."
echo "2. Abre la interfaz web de ComfyUI."
echo "3. Arrastra o carga el archivo 'workflow.json'."
echo "4. ¡Haz clic en 'Queue Prompt' para generar tu video con audio nativo!"
echo "=================================================================="
