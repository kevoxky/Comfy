#!/usr/bin/env bash
# ==============================================================================
# Paso 03: Instalación de Custom Nodes Declarados en configs/custom_nodes.json
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

echo -e "${BLUE}=== [3/6] Instalando Nodos Personalizados Declarados... ===${NC}"

python3 - << 'PYEOF'
import json, os, subprocess

config_path = "configs/custom_nodes.json"
if not os.path.exists(config_path):
    print("⚠ No se encontró configs/custom_nodes.json")
    exit(0)

with open(config_path, "r", encoding="utf-8") as f:
    nodes = json.load(f)

comfy_root = os.environ.get("COMFY_ROOT", "/workspace/runpod-slim/ComfyUI")
custom_nodes_dir = os.path.join(comfy_root, "custom_nodes")

for node in nodes:
    name = node.get("name")
    git_url = node.get("git_url")
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
PYEOF

echo -e "\n${GREEN}✓ Todos los Custom Nodes declarados han sido instalados.${NC}"
