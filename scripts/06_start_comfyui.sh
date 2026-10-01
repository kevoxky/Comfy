#!/usr/bin/env bash
# ==============================================================================
# Paso 06: Lanzamiento y Verificación de ComfyUI (Puerto 8188)
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

if [ -f ".env.runtime" ]; then
    source .env.runtime
fi

if [ -z "$COMFY_ROOT" ]; then
    COMFY_ROOT="/workspace/runpod-slim/ComfyUI"
fi

echo -e "${BLUE}=== [6/6] Verificando servicio ComfyUI en Puerto 8188... ===${NC}"

# 1. Comprobar si ComfyUI ya está en ejecución
if pgrep -f "main.py" > /dev/null; then
    echo -e "${GREEN}✓ ComfyUI ya se encuentra en ejecución activa.${NC}"
else
    echo -e "${YELLOW}Iniciando ComfyUI optimizado para ${GPU_NAME:-NVIDIA GPU} (${GPU_ARCH:-Blackwell})...${NC}"
    cd "$COMFY_ROOT"
    nohup python3 main.py --listen 0.0.0.0 --port 8188 --fast --preview-method auto > /workspace/comfyui.log 2>&1 &
    sleep 3
    if pgrep -f "main.py" > /dev/null; then
        echo -e "${GREEN}✓ ComfyUI iniciado exitosamente en segundo plano (PID: $(pgrep -f 'main.py' | head -n 1)).${NC}"
    else
        echo -e "${YELLOW}Iniciando en primer plano...${NC}"
        python3 main.py --listen 0.0.0.0 --port 8188 --fast --preview-method auto
    fi
fi

echo -e "\n${GREEN}${BOLD}================================================================${NC}"
echo -e "${GREEN}${BOLD}   ¡DESPLIEGUE DE ${WORKFLOW_NAME:-WORKFLOW} FINALIZADO CON ÉXITO!   ${NC}"
echo -e "${GREEN}${BOLD}================================================================${NC}"
echo -e "1. Ve a tu panel de RunPod y haz clic en: ${CYAN}${BOLD}Connect -> Connect to Web UI (Port 8188)${NC}"
echo -e "2. En ComfyUI, abre o arrastra: ${YELLOW}${WORKFLOW_DIR}/workflow.json${NC}"
echo -e "3. Los nodos y modelos requeridos para este flujo ya están listos en la GPU."
echo -e "4. Presiona ${GREEN}${BOLD}'Queue Prompt'${NC} para ejecutar tu flujo de trabajo."
echo -e "${GREEN}${BOLD}================================================================${NC}\n"
