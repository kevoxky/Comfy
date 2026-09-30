#!/usr/bin/env bash
# ==============================================================================
# Bootstrap Específico: Spot Publicitario Universal (commercial_product_video)
# ==============================================================================
# Provee ÚNICAMENTE los modelos y nodos requeridos para este workflow:
# - Qwen Image Edit 2511 (Fusión fotorrealista de Modelo + Producto)
# - MiniMax H3 (Video cinemático + Audio estéreo nativo)
# - Nodos: ComfyUI-Manager, ComfyUI-VideoHelperSuite
# ==============================================================================
set -e

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$THIS_DIR/../.." && pwd)"

# Delegar la ejecución al motor modular con el directorio de este workflow
exec bash "$ROOT_DIR/bootstrap.sh" "$THIS_DIR"
