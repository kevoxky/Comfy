#!/usr/bin/env bash
# ==============================================================================
# ComfyUI AI Factory: Orquestador Maestro de Workflows
# ==============================================================================
# Ejecuta el bootstrap modular y aprovisiona ÚNICAMENTE los modelos y nodos
# específicos del workflow seleccionado, sin descargar datos innecesarios.
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASE_DIR"

# 1. Determinar el workflow objetivo
TARGET_INPUT="${1:-$WORKFLOW_DIR}"

if [ -z "$TARGET_INPUT" ]; then
    # Listar workflows disponibles en workflows/
    AVAILABLE_WORKFLOWS=($(ls -d workflows/*/ 2>/dev/null | xargs -n 1 basename || true))
    COUNT=${#AVAILABLE_WORKFLOWS[@]}

    if [ "$COUNT" -eq 1 ]; then
        TARGET_INPUT="workflows/${AVAILABLE_WORKFLOWS[0]}"
        echo -e "${YELLOW}ℹ Un único workflow disponible. Auto-seleccionando:${NC} ${BOLD}${AVAILABLE_WORKFLOWS[0]}${NC}"
    elif [ "$COUNT" -gt 1 ]; then
        echo -e "${CYAN}================================================================${NC}"
        echo -e "${GREEN}${BOLD}   SELECCIONA EL WORKFLOW A DESPLEGAR:                          ${NC}"
        echo -e "${CYAN}================================================================${NC}"
        for i in "${!AVAILABLE_WORKFLOWS[@]}"; do
            echo -e "  [$((i+1))] ${BOLD}${AVAILABLE_WORKFLOWS[$i]}${NC}"
        done
        echo -e "${CYAN}================================================================${NC}"
        read -p "Ingresa el número o nombre del workflow [1]: " CHOICE
        CHOICE="${CHOICE:-1}"
        if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -le "$COUNT" ] && [ "$CHOICE" -ge 1 ]; then
            TARGET_INPUT="workflows/${AVAILABLE_WORKFLOWS[$((CHOICE-1))]}"
        else
            TARGET_INPUT="workflows/$CHOICE"
        fi
    else
        echo -e "${RED}ERROR: No se encontraron workflows en la carpeta 'workflows/'.${NC}"
        exit 1
    fi
fi

# Resolver ruta absoluta del workflow
if [ ! -d "$TARGET_INPUT" ] && [ -d "workflows/$TARGET_INPUT" ]; then
    TARGET_INPUT="workflows/$TARGET_INPUT"
fi

if [ ! -d "$TARGET_INPUT" ]; then
    echo -e "${RED}ERROR: El workflow '$TARGET_INPUT' no existe.${NC}"
    exit 1
fi

WORKFLOW_ABS="$(cd "$TARGET_INPUT" && pwd)"
WORKFLOW_NAME="$(basename "$WORKFLOW_ABS")"

echo -e "\n${CYAN}================================================================${NC}"
echo -e "${GREEN}${BOLD}   DESPLIEGUE ESPECÍFICO: ${WORKFLOW_NAME}                     ${NC}"
echo -e "${CYAN}================================================================${NC}"
echo -e "Ruta del flujo: ${BOLD}$WORKFLOW_ABS${NC}\n"

# Asegurar permisos de ejecución en scripts
chmod +x scripts/*.sh

# Función para ejecutar con captura de errores
run_step() {
    local script_name=$1
    local description=$2
    echo -e "\n${BLUE}>>> [Paso ${script_name:0:2}] ${description}...${NC}"
    if bash "scripts/$script_name" "$WORKFLOW_ABS"; then
        echo -e "${GREEN}✓ Completado con éxito: ${description}${NC}"
    else
        echo -e "\n${RED}================================================================${NC}"
        echo -e "${RED}ERROR CRÍTICO durante: ${description}${NC}"
        echo -e "${YELLOW}Revisa el mensaje anterior para solucionar el error.${NC}"
        echo -e "${RED}================================================================${NC}"
        exit 1
    fi
}

# Ejecución secuencial de los 6 pasos modulares
run_step "01_detect_env.sh" "Detección de Hardware y Entorno"
run_step "02_install_core.sh" "Instalación de Dependencias Core y ComfyUI"
run_step "03_install_nodes.sh" "Instalación de Nodos Específicos del Workflow"
run_step "04_setup_models.sh" "Descarga Acelerada de Modelos de este Workflow"
run_step "05_verify_health.sh" "Verificación de Salud y Coherencia"
run_step "06_start_comfyui.sh" "Lanzamiento y Verificación de ComfyUI (Puerto 8188)"
