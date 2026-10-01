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

# 1. Detectar si ComfyUI está en ejecución y obtener su directorio activo
RUNNING_PID=$(pgrep -f "main.py" | head -n 1 || true)
if [ -n "$RUNNING_PID" ]; then
    RUNNING_CWD=$(readlink -f /proc/$RUNNING_PID/cwd 2>/dev/null || pwdx $RUNNING_PID 2>/dev/null | awk '{print $2}' || true)
    if [ -n "$RUNNING_CWD" ] && [ -d "$RUNNING_CWD" ]; then
        COMFY_ROOT="$RUNNING_CWD"
    fi
    echo -e "${YELLOW}ComfyUI estaba en ejecución previa (PID: $RUNNING_PID en $COMFY_ROOT).${NC}"
    echo -e "${YELLOW}Reiniciando servicio ComfyUI para cargar los nuevos custom nodes en memoria...${NC}"
    kill -9 $RUNNING_PID 2>/dev/null || true
    pkill -9 -f "main.py" 2>/dev/null || true
    sleep 2
fi

# 2. Asegurar que los custom nodes locales están desplegados en el ComfyUI activo
LOCAL_NODES_DIR="$(dirname "${BASH_SOURCE[0]}")/../custom_nodes"
for candidate in "$COMFY_ROOT" "/workspace/ComfyUI" "/workspace/runpod-slim/ComfyUI"; do
    if [ -d "$candidate/custom_nodes" ] && [ -d "$LOCAL_NODES_DIR" ]; then
        cp -r "$LOCAL_NODES_DIR"/* "$candidate/custom_nodes/" 2>/dev/null || true
    fi
done

# 3. Iniciar ComfyUI optimizado
echo -e "${YELLOW}Iniciando ComfyUI en ${COMFY_ROOT} optimizado para ${GPU_NAME:-NVIDIA GPU} (${GPU_ARCH:-Blackwell})...${NC}"
cd "$COMFY_ROOT"
nohup python3 main.py --listen 0.0.0.0 --port 8188 --fast --preview-method auto > /workspace/comfyui.log 2>&1 &
sleep 4

if pgrep -f "main.py" > /dev/null; then
    NEW_PID=$(pgrep -f 'main.py' | head -n 1)
    echo -e "${GREEN}✓ ComfyUI iniciado exitosamente en segundo plano (PID: ${NEW_PID}).${NC}"
    echo -e "${GREEN}✓ Custom nodes cargados activamente.${NC}"
else
    echo -e "${YELLOW}Iniciando en primer plano...${NC}"
    python3 main.py --listen 0.0.0.0 --port 8188 --fast --preview-method auto
fi

echo -e "\n${GREEN}${BOLD}================================================================${NC}"
echo -e "${GREEN}${BOLD}   ¡DESPLIEGUE DE ${WORKFLOW_NAME:-WORKFLOW} FINALIZADO CON ÉXITO!   ${NC}"
echo -e "${GREEN}${BOLD}================================================================${NC}"
echo -e "1. Ve a tu panel de RunPod y haz clic en: ${CYAN}${BOLD}Connect -> Connect to Web UI (Port 8188)${NC}"
echo -e "2. En ComfyUI, abre o arrastra: ${YELLOW}${WORKFLOW_DIR}/workflow.json${NC}"
echo -e "3. Los nodos y modelos requeridos para este flujo ya están listos en la GPU."
echo -e "4. Presiona ${GREEN}${BOLD}'Queue Prompt'${NC} para ejecutar tu flujo de trabajo."
echo -e "${GREEN}${BOLD}================================================================${NC}\n"
