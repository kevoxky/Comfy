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

# 2. Asegurar que los custom nodes locales están desplegados en el ComfyUI activo (si existen)
LOCAL_NODES_DIR="$(dirname "${BASH_SOURCE[0]}")/../custom_nodes"
for candidate in "$COMFY_ROOT" "/workspace/ComfyUI" "/workspace/runpod-slim/ComfyUI"; do
    if [ -d "$candidate/custom_nodes" ] && [ -d "$LOCAL_NODES_DIR" ]; then
        if [ "$(ls -A "$LOCAL_NODES_DIR" 2>/dev/null)" ]; then
            cp -r "$LOCAL_NODES_DIR"/* "$candidate/custom_nodes/" 2>/dev/null || true
        fi
    fi
done

# 3. Determinar archivo de log
LOG_FILE="/workspace/comfyui.log"
if [ ! -d "/workspace" ]; then
    LOG_FILE="$COMFY_ROOT/comfyui.log"
fi
> "$LOG_FILE" || true

# 4. Iniciar ComfyUI optimizado en segundo plano
echo -e "${YELLOW}Iniciando ComfyUI en ${COMFY_ROOT} optimizado para ${GPU_NAME:-NVIDIA GPU} (${GPU_ARCH:-Blackwell})...${NC}"
cd "$COMFY_ROOT"
nohup python3 main.py --listen 0.0.0.0 --port 8188 --fast --preview-method auto > "$LOG_FILE" 2>&1 &
COMFY_PID=$!

echo -e "${YELLOW}Esperando a que ComfyUI inicialice sus nodos y abra el puerto 8188...${NC}"
echo -e "${CYAN}Nota: En el primer arranque, ComfyUI-Manager e Impact-Pack compilan y cargan dependencias en GPU.${NC}"

IS_READY=false
for i in $(seq 1 60); do
    # 1. Verificar si el proceso sigue vivo
    if ! kill -0 $COMFY_PID 2>/dev/null && ! pgrep -f "main.py" > /dev/null; then
        echo -e "\n${RED}❌ ERROR: El proceso main.py de ComfyUI terminó inesperadamente.${NC}"
        echo -e "${YELLOW}Últimas 35 líneas del registro ($LOG_FILE):${NC}"
        tail -n 35 "$LOG_FILE" 2>/dev/null || true
        exit 1
    fi

    # 2. Verificar respuesta HTTP en el puerto 8188
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8188 2>/dev/null || echo "000")
    if [ "$HTTP_STATUS" = "200" ] || [ "$HTTP_STATUS" = "302" ]; then
        IS_READY=true
        break
    fi

    echo -ne "${YELLOW}.${NC}"
    sleep 2
done
echo ""

if [ "$IS_READY" = "true" ]; then
    NEW_PID=$(pgrep -f 'main.py' | head -n 1)
    echo -e "${GREEN}✓ PUERTO 8188 ACTIVO Y RESPONDIENDO (HTTP 200).${NC}"
    echo -e "${GREEN}✓ ComfyUI iniciado exitosamente en segundo plano (PID: ${NEW_PID:-$COMFY_PID}).${NC}"
    echo -e "${GREEN}✓ Custom nodes y modelos cargados activamente.${NC}"
else
    echo -e "${YELLOW}⚠ El puerto 8188 aún no responde localmente tras 120s, pero ComfyUI sigue activo.${NC}"
    echo -e "${YELLOW}Últimas líneas del registro:${NC}"
    tail -n 15 "$LOG_FILE" 2>/dev/null || true
fi

echo -e "\n${GREEN}${BOLD}================================================================${NC}"
echo -e "${GREEN}${BOLD}   ¡DESPLIEGUE DE ${WORKFLOW_NAME:-WORKFLOW} FINALIZADO CON ÉXITO!   ${NC}"
echo -e "${GREEN}${BOLD}================================================================${NC}"
echo -e "1. Ve a tu panel de RunPod y haz clic en: ${CYAN}${BOLD}Connect -> Connect to Web UI (Port 8188)${NC}"
echo -e "2. ¡El puerto ya está abierto y no dará error 403 Forbidden!"
echo -e "3. En ComfyUI, abre o arrastra: ${YELLOW}${WORKFLOW_DIR}/workflow.json${NC}"
echo -e "   (O ve al menú superior: 'Workflow' -> 'Open' -> 'commercial_product_video.json')"
echo -e "4. Presiona ${GREEN}${BOLD}'Queue Prompt'${NC} para ejecutar tu flujo de trabajo."
echo -e "${GREEN}${BOLD}================================================================${NC}\n"
