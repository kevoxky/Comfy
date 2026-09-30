#!/usr/bin/env bash
# ==============================================================================
# ComfyUI Spot Studio: Orquestador Maestro de Bootstrap (RunPod RTX 5090)
# Repositorio: https://github.com/kevoxky/Comfy.git
# ==============================================================================
# Un único comando para reconstruir de forma automatizada e idempotente
# todo el entorno de ComfyUI con los modelos y nodos exactos declarados.
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}================================================================${NC}"
echo -e "${GREEN}${BOLD}   INICIANDO BOOTSTRAP: ComfyUI Spot Studio (RTX 5090)          ${NC}"
echo -e "${CYAN}================================================================${NC}"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASE_DIR"

# Asegurar permisos de ejecución en los scripts modulares
chmod +x scripts/*.sh

# Función para ejecutar con captura y reporte de errores
run_step() {
    local script_name=$1
    local description=$2
    echo -e "\n${BLUE}>>> [Paso ${script_name:0:2}] ${description}...${NC}"
    if bash "scripts/$script_name"; then
        echo -e "${GREEN}✓ Completado con éxito: ${description}${NC}"
    else
        echo -e "\n${RED}================================================================${NC}"
        echo -e "${RED}ERROR durante el paso: ${description}${NC}"
        echo -e "${YELLOW}Revisa el mensaje anterior para verificar la causa.${NC}"
        echo -e "${RED}================================================================${NC}"
        exit 1
    fi
}

# Ejecución secuencial de los 6 pasos modulares
run_step "01_detect_env.sh" "Detección de Hardware y Entorno"
run_step "02_install_core.sh" "Instalación de Dependencias Core y ComfyUI"
run_step "03_install_nodes.sh" "Instalación de Custom Nodes Declarados"
run_step "04_setup_models.sh" "Descarga Acelerada de Modelos Declarados"
run_step "05_verify_health.sh" "Verificación de Salud y Coherencia"
run_step "06_start_comfyui.sh" "Lanzamiento y Verificación de ComfyUI (Puerto 8188)"
