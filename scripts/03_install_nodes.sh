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

clone_env = os.environ.copy()
clone_env["GIT_TERMINAL_PROMPT"] = "0"

for node in nodes:
    name = node.get("name")
    git_url = node.get("git_url")
    if not git_url or git_url == "local":
        continue
    target_path = os.path.join(custom_nodes_dir, name)

    print(f"\n📦 Procesando Nodo: \033[1m{name}\033[0m")
    if not os.path.exists(target_path):
        print(f"   ⬇ Clonando desde {git_url}...")
        res = subprocess.run(["git", "clone", git_url, target_path], env=clone_env, check=False)
        if res.returncode != 0:
            print(f"   ⚠ Advertencia: No se pudo clonar {name}. Se continuará con los siguientes.")
            continue
    else:
        print(f"   ✓ Ya existe. Actualizando rama...")
        subprocess.run(["git", "-C", target_path, "pull"], env=clone_env, check=False)

    req_file = os.path.join(target_path, "requirements.txt")
    if os.path.exists(req_file):
        print(f"   📦 Instalando dependencias de {name}...")
        subprocess.run(["pip", "install", "--no-cache-dir", "-r", req_file, "-q"], check=False)

    print(f"   ✓ {name} listo.")

# 2. Desplegar nodos personalizados locales incluidos en este repositorio
import shutil
base_dir = os.environ.get("BASE_DIR", ".")
local_nodes_dir = os.path.join(base_dir, "custom_nodes")
candidate_comfy_roots = {comfy_root, "/workspace/ComfyUI", "/workspace/runpod-slim/ComfyUI"}

if os.path.isdir(local_nodes_dir):
    for c_root in candidate_comfy_roots:
        c_nodes_dir = os.path.join(c_root, "custom_nodes")
        if os.path.isdir(c_nodes_dir):
            for item in os.listdir(local_nodes_dir):
                src_item = os.path.join(local_nodes_dir, item)
                dst_item = os.path.join(c_nodes_dir, item)
                if os.path.isdir(src_item):
                    print(f"\n📦 Desplegando nodo personalizado local en {c_nodes_dir}: \033[1m{item}\033[0m")
                    if os.path.exists(dst_item):
                        shutil.rmtree(dst_item)
                    shutil.copytree(src_item, dst_item)
                    print(f"   ✓ {item} sincronizado con éxito.")

# 3. Desplegar imágenes de referencia en el directorio input de ComfyUI
repo_input_dir = os.path.join(base_dir, "input")
for c_root in candidate_comfy_roots:
    c_input_dir = os.path.join(c_root, "input")
    if os.path.isdir(c_root):
        os.makedirs(c_input_dir, exist_ok=True)
        if os.path.isdir(repo_input_dir):
            for img_name in os.listdir(repo_input_dir):
                src_img = os.path.join(repo_input_dir, img_name)
                dst_img = os.path.join(c_input_dir, img_name)
                if os.path.isfile(src_img):
                    shutil.copyfile(src_img, dst_img)
                    print(f"   ✓ Imagen demo copiada a {c_input_dir}: {img_name}")

# 4. Desplegar workflow.json en la biblioteca de ComfyUI (user/default/workflows/)
for c_root in candidate_comfy_roots:
    if os.path.isdir(c_root):
        c_wf_dir = os.path.join(c_root, "user", "default", "workflows")
        os.makedirs(c_wf_dir, exist_ok=True)
        repo_wf_path = os.path.join(workflow_dir, "workflow.json") if workflow_dir else os.path.join(base_dir, "workflows/commercial_product_video/workflow.json")
        if os.path.isfile(repo_wf_path):
            dst_wf_path = os.path.join(c_wf_dir, "commercial_product_video.json")
            shutil.copyfile(repo_wf_path, dst_wf_path)
    print(f"   ✓ Workflow registrado en biblioteca de ComfyUI: {dst_wf_path}")
PYEOF

echo -e "\n${GREEN}✓ Nodos específicos instalados correctamente.${NC}"
