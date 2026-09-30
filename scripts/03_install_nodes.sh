#!/usr/bin/env bash
# ==============================================================================
# Paso 03: Instalación de Custom Nodes Específicos del Workflow
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -f ".env.runtime" ]; then
    source .env.runtime
fi

if [ -z "$COMFY_ROOT" ]; then
    COMFY_ROOT="/workspace/runpod-slim/ComfyUI"
fi

CUSTOM_NODES_DIR="$COMFY_ROOT/custom_nodes"
mkdir -p "$CUSTOM_NODES_DIR"

echo -e "${BLUE}=== [3/6] Instalando Nodos Declarados para: ${WORKFLOW_NAME:-Workflow}... ===${NC}"

python3 - << 'PYEOF'
import json, os, subprocess

workflow_dir = os.environ.get("WORKFLOW_DIR", "")
config_path = os.path.join(workflow_dir, "custom_nodes.json") if workflow_dir else ""

if not config_path or not os.path.exists(config_path):
    config_path = "configs/custom_nodes.json"

if not os.path.exists(config_path):
    print(f"ℹ No se encontró archivo de nodos en {config_path}. Se omite.")
    exit(0)

print(f"Leyendo nodos desde: \033[1m{config_path}\033[0m")
with open(config_path, "r", encoding="utf-8") as f:
    nodes = json.load(f)

comfy_root = os.environ.get("COMFY_ROOT", "/workspace/runpod-slim/ComfyUI")
custom_nodes_dir = os.path.join(comfy_root, "custom_nodes")

for node in nodes:
    name = node.get("name")
    git_url = node.get("git_url")
    if not git_url or git_url == "local":
        continue
    target_path = os.path.join(custom_nodes_dir, name)

    print(f"\n📦 Procesando Nodo: \033[1m{name}\033[0m")
    if not os.path.exists(target_path):
        print(f"   ⬇ Clonando desde {git_url}...")
        subprocess.run(["git", "clone", git_url, target_path], check=True)
    else:
        print(f"   ✓ Ya existe. Actualizando rama...")
        subprocess.run(["git", "-C", target_path, "pull"], check=False)

    req_file = os.path.join(target_path, "requirements.txt")
    if os.path.exists(req_file):
        print(f"   📦 Instalando dependencias de {name}...")
        subprocess.run(["pip", "install", "--no-cache-dir", "-r", req_file, "-q"], check=False)

    print(f"   ✓ {name} listo.")

# 2. Desplegar nodos personalizados locales incluidos en este repositorio
import shutil
base_dir = os.environ.get("BASE_DIR", ".")
local_nodes_dir = os.path.join(base_dir, "custom_nodes")
if os.path.isdir(local_nodes_dir):
    for item in os.listdir(local_nodes_dir):
        src_item = os.path.join(local_nodes_dir, item)
        dst_item = os.path.join(custom_nodes_dir, item)
        if os.path.isdir(src_item):
            print(f"\n📦 Desplegando nodo personalizado local: \033[1m{item}\033[0m")
            if os.path.exists(dst_item):
                shutil.rmtree(dst_item)
            shutil.copytree(src_item, dst_item)
            print(f"   ✓ {item} sincronizado con éxito.")
PYEOF

echo -e "\n${GREEN}✓ Nodos específicos instalados correctamente.${NC}"
