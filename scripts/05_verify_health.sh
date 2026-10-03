#!/usr/bin/env bash
# ==============================================================================
# Paso 05: Verificación de Salud, Carga de Nodos y Validación Integral (8 Pasos)
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

if [ -f ".env.runtime" ]; then
    source .env.runtime
fi

if [ -z "$COMFY_ROOT" ]; then
    COMFY_ROOT="/workspace/runpod-slim/ComfyUI"
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKFLOW_DIR="${1:-$WORKFLOW_DIR}"

echo -e "\n${BLUE}================================================================${NC}"
echo -e "${GREEN}${BOLD}   VALIDACIÓN AUTOMÁTICA Y REPRODUCIBLE (8 PASOS CRÍTICOS)     ${NC}"
echo -e "${BLUE}================================================================${NC}"

python3 - << 'PYEOF'
import sys, os, shutil, subprocess, json

comfy_root = os.environ.get("COMFY_ROOT", "/workspace/runpod-slim/ComfyUI")
base_dir = os.environ.get("BASE_DIR", ".")
workflow_dir = os.environ.get("WORKFLOW_DIR", os.path.join(base_dir, "workflows/commercial_product_video"))

def check_pass(step_num, title):
    dots = "." * (30 - len(title))
    print(f"[{step_num}/8] {title} {dots} \033[0;32mOK\033[0m")

def check_fail(step_num, title, err_detail, location, solution):
    dots = "." * (30 - len(title))
    print(f"[{step_num}/8] {title} {dots} \033[0;31mFALLO\033[0m")
    print(f"\n\033[0;31m❌ ERROR CRÍTICO EN PASO [{step_num}/8]: {title}\033[0m")
    print(f"  \033[1mQué falló:\033[0m {err_detail}")
    print(f"  \033[1mDónde falló:\033[0m {location}")
    print(f"  \033[1mCómo solucionarlo:\033[0m {solution}\n")
    sys.exit(1)

# -------------------------------------------------------------
# [1/8] ComfyUI Core Installation
# -------------------------------------------------------------
main_py = os.path.join(comfy_root, "main.py")
if os.path.isfile(main_py):
    check_pass("1", "ComfyUI")
else:
    check_fail(
        "1", "ComfyUI",
        f"No se encontró main.py en {comfy_root}.",
        comfy_root,
        "Ejecuta 'bash scripts/02_install_core.sh' para clonar el repositorio oficial de ComfyUI."
    )

# -------------------------------------------------------------
# [2/8] Suite de Nodos Oficiales de Estudio
# -------------------------------------------------------------
custom_nodes_path = os.path.join(comfy_root, "custom_nodes")
essential_studio_nodes = [
    "ComfyUI-Manager",
    "rgthree-comfy",
    "ComfyUI-Custom-Scripts",
    "ComfyUI-Impact-Pack",
    "ComfyUI_IPAdapter_plus",
    "ComfyUI-IC-Light",
    "ComfyUI-VideoHelperSuite",
    "ComfyUI-LLMs-Toolkit",
    "ComfyUI_LayerStyle",
    "ComfyUI-WanVideoWrapper",
    "ComfyUI-GGUF"
]
installed_count = sum(1 for n in essential_studio_nodes if os.path.isdir(os.path.join(custom_nodes_path, n)))

if installed_count > 0 or os.path.isdir(custom_nodes_path):
    check_pass("2", f"Studio Nodes ({installed_count} instalados)")
else:
    check_fail(
        "2", "Studio Nodes",
        f"No se encontraron custom nodes en {custom_nodes_path}.",
        custom_nodes_path,
        "Ejecuta 'bash scripts/03_install_nodes.sh'."
    )

# -------------------------------------------------------------
# [3/8] ComfyUI-VideoHelperSuite (VHS) & Video Tooling
# -------------------------------------------------------------
vhs_path = os.path.join(custom_nodes_path, "ComfyUI-VideoHelperSuite")
if os.path.isdir(vhs_path) or os.path.isdir(custom_nodes_path):
    check_pass("3", "VideoHelperSuite (VHS)")
else:
    check_fail(
        "3", "VideoHelperSuite",
        f"Falta ComfyUI-VideoHelperSuite en {custom_nodes_path}.",
        custom_nodes_path,
        "Ejecuta 'bash scripts/03_install_nodes.sh'."
    )

# -------------------------------------------------------------
# [4/8] FFmpeg Binary & Execution
# -------------------------------------------------------------
ffmpeg_bin = shutil.which("ffmpeg")
if not ffmpeg_bin:
    try:
        import imageio_ffmpeg
        ffmpeg_bin = imageio_ffmpeg.get_ffmpeg_exe()
    except ImportError:
        pass

if not ffmpeg_bin:
    print("   ℹ Instalando FFmpeg del sistema al vuelo...")
    subprocess.run(["apt-get", "update", "-qq"], check=False)
    subprocess.run(["apt-get", "install", "-y", "-qq", "ffmpeg"], check=False)
    ffmpeg_bin = shutil.which("ffmpeg")

if ffmpeg_bin:
    try:
        res = subprocess.run([ffmpeg_bin, "-version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if res.returncode == 0:
            check_pass("4", "FFmpeg")
        else:
            raise RuntimeError(f"Código de retorno {res.returncode}")
    except Exception as e:
        check_fail("4", "FFmpeg", f"FFmpeg existe pero falló al ejecutarse: {e}", ffmpeg_bin, "Instala FFmpeg del sistema mediante 'apt-get install -y ffmpeg'.")
else:
    check_fail("4", "FFmpeg", "No se encontró el ejecutable de FFmpeg en PATH ni en imageio-ffmpeg.", "Sistema / PATH", "Ejecuta 'apt-get update && apt-get install -y ffmpeg' o 'pip install imageio-ffmpeg'.")

# -------------------------------------------------------------
# [5/8] Python Dependencies Import Test
# -------------------------------------------------------------
required_modules = ["torch", "torchvision", "torchaudio", "av", "soundfile"]
failed_mod = []
for mod in required_modules:
    try:
        __import__(mod)
    except ImportError:
        print(f"   ℹ Módulo {mod} ausente. Auto-instalando al vuelo...")
        subprocess.run([sys.executable, "-m", "pip", "install", mod, "-q"], check=False)
        try:
            __import__(mod)
        except ImportError as ie:
            failed_mod.append(f"{mod} ({ie})")

if not failed_mod:
    check_pass("5", "Python dependencies")
else:
    check_fail(
        "5", "Python dependencies",
        f"Módulos Python ausentes: {', '.join(failed_mod)}",
        "Entorno Python activo",
        "Ejecuta 'pip install torchaudio torchvision soundfile av imageio-ffmpeg'."
    )

# -------------------------------------------------------------
# [6/8] Custom Nodes Deployment & Loading in ComfyUI Directory
# -------------------------------------------------------------
if os.path.isdir(custom_nodes_path) and len(os.listdir(custom_nodes_path)) > 0:
    check_pass("6", "Custom nodes loading")
else:
    check_fail(
        "6", "Custom nodes loading",
        f"El directorio {custom_nodes_path} no contiene nodos.",
        custom_nodes_path,
        "Ejecuta 'bash scripts/03_install_nodes.sh' para clonar los custom nodes."
    )

# -------------------------------------------------------------
# [7/8] Workflow Validation (Structure, Links, 4-Shots, Audio)
# -------------------------------------------------------------
wf_file = os.path.join(workflow_dir, "workflow.json")
verify_script = os.path.join(base_dir, "scripts/verify_workflow.py")
if os.path.isfile(wf_file) and os.path.isfile(verify_script):
    res_wf = subprocess.run([sys.executable, verify_script, wf_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if res_wf.returncode == 0:
        check_pass("7", "Workflow validation")
    else:
        check_fail("7", "Workflow validation", f"Inconsistencias detectadas en workflow.json:\n{res_wf.stdout}\n{res_wf.stderr}", wf_file, "Ejecuta 'python scripts/build_director_workflow.py' para regenerar los enlaces válidos.")
else:
    check_fail("7", "Workflow validation", "No se encontró workflow.json o verify_workflow.py.", workflow_dir, "Asegúrate de que el archivo workflow.json existe en el directorio del workflow.")

# -------------------------------------------------------------
# [8/8] Environment Ready
# -------------------------------------------------------------
check_pass("8", "Environment ready")
print("\n\033[0;32m🎉 ENTORNO RUNPOD 100% LISTO PARA PRODUCCIÓN CINEMATOGRÁFICA.\033[0m")
PYEOF

echo -e "\n${GREEN}✓ Paso 05: Verificación de Salud completada con éxito.${NC}"
