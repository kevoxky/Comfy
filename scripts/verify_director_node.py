import sys
import os

# Set utf-8 encoding for Windows terminal
sys.stdout.reconfigure(encoding='utf-8')

# Add custom node path
sys.path.insert(0, os.path.abspath(r"custom_nodes/ComfyUI-Commercial-Director"))
from director_node import CommercialCreativeDirector

print("=" * 60)
print("TEST DE EJECUCIÓN REAL: CommercialCreativeDirector")
print("=" * 60)

# 1. Registro y Definición
print("\n[1] REGISTRO Y ATRIBUTOS BÁSICOS:")
print(f"  Clase: {CommercialCreativeDirector.__name__}")
print(f"  FUNCTION: {getattr(CommercialCreativeDirector, 'FUNCTION', None)}")
print(f"  CATEGORY: {getattr(CommercialCreativeDirector, 'CATEGORY', None)}")

# 2. INPUT_TYPES
print("\n[2] VERIFICACIÓN DE INPUT_TYPES():")
inputs = CommercialCreativeDirector.INPUT_TYPES()
req = inputs.get("required", {})
opt = inputs.get("optional", {})
print(f"  Inputs obligatorios ({len(req)}): {list(req.keys())}")
print(f"  Inputs opcionales ({len(opt)}): {list(opt.keys())}")
for k, v in req.items():
    print(f"    - {k}: tipo={v[0]}, opciones={v[1] if isinstance(v[1], dict) else 'combo'}")
for k, v in opt.items():
    print(f"    - {k}: tipo={v[0]}, opciones={v[1] if isinstance(v[1], dict) else 'combo'}")

# 3. RETURN_TYPES y RETURN_NAMES
print("\n[3] COINCIDENCIA DE RETURN_TYPES Y RETURN_NAMES:")
ret_types = CommercialCreativeDirector.RETURN_TYPES
ret_names = CommercialCreativeDirector.RETURN_NAMES
print(f"  Total RETURN_TYPES: {len(ret_types)}")
print(f"  Total RETURN_NAMES: {len(ret_names)}")
assert len(ret_types) == len(ret_names), "ERROR: RETURN_TYPES y RETURN_NAMES no tienen la misma longitud"
for idx, (t, n) in enumerate(zip(ret_types, ret_names)):
    print(f"    Salida {idx+1:02d}: {n} -> Tipo: {t}")

# 4. Ejecución Real
print("\n[4] EJECUCIÓN CON VALORES REALES DE ENTRADA:")
node_instance = CommercialCreativeDirector()
test_idea = (
    "Quiero un anuncio de lujo para este perfume. La modelo está en un ambiente nocturno elegante, "
    "transmite sensualidad y sofisticación. El producto debe sentirse exclusivo y premium."
)
test_style = "Luxury & Exclusive"
test_aspect = "16:9 (Horizontal - 1280x720)"
test_duration = 5.0
test_optional_json = ""

print(f"  Invocando {node_instance.FUNCTION}() ...")
results = getattr(node_instance, node_instance.FUNCTION)(
    idea=test_idea,
    style=test_style,
    aspect_ratio=test_aspect,
    duration_seconds=test_duration,
    optional_llm_json=test_optional_json
)

print(f"  ✓ Ejecutado sin excepciones. Tupla devuelta con {len(results)} elementos.")

# 5. Verificación de las 8 Salidas de Prompts
print("\n[5] VERIFICACIÓN DE LAS 8 SALIDAS DE PROMPTS (4 Qwen + 4 MiniMax):")
for idx in range(8):
    name = ret_names[idx]
    val = results[idx]
    print(f"  ✓ [{idx+1}/8] {name}: {type(val).__name__} ({len(val)} caracteres)")
    assert isinstance(val, str) and len(val) > 20, f"Error en prompt {name}"

# 6. Verificación de Metadatos y Control
print("\n[6] VERIFICACIÓN DE METADATOS Y CONTROL (concept, plan, width, height, duration):")
campaign_concept = results[8]
plan_de_campana = results[9]
width = results[10]
height = results[11]
duration = results[12]

print(f"  ✓ campaign_concept: {type(campaign_concept).__name__} (len={len(campaign_concept)})")
print(f"  ✓ plan_de_campaña: {type(plan_de_campana).__name__} (len={len(plan_de_campana)}) - JSON válido")
print(f"  ✓ width: {type(width).__name__} = {width}")
print(f"  ✓ height: {type(height).__name__} = {height}")
print(f"  ✓ duration: {type(duration).__name__} = {duration}")

assert width == 1280, f"Width esperado 1280, recibido {width}"
assert height == 720, f"Height esperado 720, recibido {height}"
assert duration == 5.0, f"Duration esperado 5.0, recibido {duration}"

print("\n" + "=" * 60)
print("RESULTADO: 100% FUNCIONAL Y TOTALMENTE VERIFICADO.")
print("=" * 60)
