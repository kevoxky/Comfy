#!/usr/bin/env bash
# ==============================================================================
# Paso 04: Descarga Acelerada de Modelos Declarados en configs/models.json
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

if [ -f ".env.runtime" ]; then
    source .env.runtime
fi

if [ -z "$COMFY_ROOT" ]; then
    COMFY_ROOT="/workspace/runpod-slim/ComfyUI"
fi

echo -e "${BLUE}=== [4/6] Descargando Modelos y Pesajes Declarados (aria2c 16-Hilos)... ===${NC}"

python3 - << 'PYEOF'
import json, os, subprocess

config_path = "configs/models.json"
if not os.path.exists(config_path):
    print("⚠ No se encontró configs/models.json")
    exit(1)

with open(config_path, "r", encoding="utf-8") as f:
    models = json.load(f)

comfy_root = os.environ.get("COMFY_ROOT", "/workspace/runpod-slim/ComfyUI")

total = len(models)
for idx, m in enumerate(models, 1):
    name = m.get("name")
    filename = m.get("filename")
    dest_dir = os.path.join(comfy_root, m.get("dest_dir"))
    url = m.get("url")
    min_size = m.get("min_size_bytes", 1048576)

    os.makedirs(dest_dir, exist_ok=True)
    target_file = os.path.join(dest_dir, filename)

    print(f"\n[{idx}/{total}] \033[1;36m{name}\033[0m")
    print(f"   Destino: {target_file}")

    if os.path.exists(target_file) and os.path.getsize(target_file) >= min_size:
        size_mb = os.path.getsize(target_file) / (1024 * 1024)
        print(f"   \033[0;32m✓ Ya descargado ({size_mb:.1f} MB). Omitiendo.\033[0m")
        continue

    print(f"   \033[1;33m⬇ Descargando con aria2c (16 hilos a máxima velocidad)...\033[0m")
    cmd = [
        "aria2c",
        "--console-log-level=warn",
        "--summary-interval=10",
        "-x", "16",
        "-s", "16",
        "-k", "1M",
        "-c",
        "-d", dest_dir,
        "-o", filename,
        url
    ]
    subprocess.run(cmd, check=True)
    print(f"   \033[0;32m✓ Descarga completada: {filename}\033[0m")
PYEOF

# Copiar el workflow oficial a la carpeta de workflows de ComfyUI
WORKFLOW_SRC="workflows/commercial_product_video/workflow.json"
if [ -f "$WORKFLOW_SRC" ]; then
    mkdir -p "$COMFY_ROOT/user/default/workflows"
    cp "$WORKFLOW_SRC" "$COMFY_ROOT/user/default/workflows/commercial_product_video.json" || true
    echo -e "\n${GREEN}✓ Workflow integrado en: $COMFY_ROOT/user/default/workflows/commercial_product_video.json${NC}"
fi

echo -e "\n${GREEN}✓ Todos los modelos han sido aprovisionados con éxito.${NC}"
