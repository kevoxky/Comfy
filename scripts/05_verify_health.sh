#!/usr/bin/env bash
# ==============================================================================
# Paso 05: Verificación de Salud y Validación Específica del Workflow
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ -f ".env.runtime" ]; then
    source .env.runtime
fi

if [ -z "$COMFY_ROOT" ]; then
    COMFY_ROOT="/workspace/runpod-slim/ComfyUI"
fi

echo -e "${BLUE}=== [5/6] Verificando Salud y Coherencia para: ${WORKFLOW_NAME:-Workflow}... ===${NC}"

python3 - << 'PYEOF'
import json, os

comfy_root = os.environ.get("COMFY_ROOT", "/workspace/runpod-slim/ComfyUI")
workflow_dir = os.environ.get("WORKFLOW_DIR", "")
print(f"Directorio ComfyUI: \033[1m{comfy_root}\033[0m")
print(f"Directorio Workflow: \033[1m{workflow_dir}\033[0m\n")

all_ok = True

# 1. Verificar Nodos del Workflow
nodes_file = os.path.join(workflow_dir, "custom_nodes.json") if workflow_dir else ""
if not nodes_file or not os.path.exists(nodes_file):
    nodes_file = "configs/custom_nodes.json"

if os.path.exists(nodes_file):
    with open(nodes_file, "r") as f:
        nodes = json.load(f)
    print("--- [1/2] Verificando Nodos Requeridos por este Workflow ---")
    for n in nodes:
        name = n.get("name")
        p = os.path.join(comfy_root, "custom_nodes", name)
        if os.path.isdir(p):
            print(f"  \033[0;32m[OK]\033[0m Nodo: {name}")
        else:
            print(f"  \033[0;31m[FALLO]\033[0m Nodo ausente: {name}")
            all_ok = False

# 2. Verificar Modelos del Workflow
models_file = os.path.join(workflow_dir, "models.json") if workflow_dir else ""
if not models_file or not os.path.exists(models_file):
    models_file = "configs/models.json"

if os.path.exists(models_file):
    with open(models_file, "r") as f:
        models = json.load(f)
    print("\n--- [2/2] Verificando Modelos Requeridos por este Workflow ---")
    for m in models:
        fname = m.get("filename")
        rel_dir = m.get("dest_dir")
        target = os.path.join(comfy_root, rel_dir, fname)
        min_sz = m.get("min_size_bytes", 1048576)

        if os.path.isfile(target):
            sz = os.path.getsize(target)
            if sz >= min_sz:
                sz_mb = sz / (1024 * 1024)
                print(f"  \033[0;32m[OK]\033[0m {fname} ({sz_mb:.1f} MB)")
            else:
                print(f"  \033[0;31m[CORRUPTO]\033[0m {fname} (tamaño insuficiente: {sz} bytes)")
                all_ok = False
        else:
            print(f"  \033[0;31m[FALTA]\033[0m {fname} en {rel_dir}")
            all_ok = False

if not all_ok:
    print("\n\033[0;31m⚠ Atención: Se detectaron inconsistencias en la verificación de este workflow.\033[0m")
    exit(1)
else:
    print("\n\033[0;32m✓ Health Check SUPERADO al 100%. Workflow listo para generar.\033[0m")
PYEOF
