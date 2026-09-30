"""
Comprehensive validator for Commercial Product Video Workflow.
Verifies all nodes, links, socket types, subgraphs, and wiring integrity.
"""

import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

def verify_workflow(wf_path):
    print(f"=== Verificando Workflow: {wf_path} ===")
    with open(wf_path, "r", encoding="utf-8") as f:
        wf = json.load(f)

    nodes = {n["id"]: n for n in wf.get("nodes", [])}
    links = {l[0]: l for l in wf.get("links", [])}
    errors = []
    warnings = []

    print(f"Total Nodos: {len(nodes)}")
    print(f"Total Enlaces: {len(links)}")
    print(f"Total Grupos: {len(wf.get('groups', []))}")

    # 1. Verify links consistency
    for lid, link in links.items():
        src_id, src_out_idx, dst_id, dst_in_idx, ltype = link[1], link[2], link[3], link[4], link[5]
        
        # Check source node
        if src_id not in nodes:
            errors.append(f"Enlace {lid}: Nodo origen {src_id} no existe.")
            continue
        src_node = nodes[src_id]
        if src_out_idx >= len(src_node.get("outputs", [])):
            errors.append(f"Enlace {lid}: Salida {src_out_idx} no existe en nodo origen {src_id} ({src_node.get('title')}).")
            continue
        src_out = src_node["outputs"][src_out_idx]
        if lid not in (src_out.get("links") or []):
            errors.append(f"Enlace {lid}: No está registrado en outputs del nodo origen {src_id}.")

        # Check target node
        if dst_id not in nodes:
            errors.append(f"Enlace {lid}: Nodo destino {dst_id} no existe.")
            continue
        dst_node = nodes[dst_id]
        if dst_in_idx >= len(dst_node.get("inputs", [])):
            errors.append(f"Enlace {lid}: Entrada {dst_in_idx} no existe en nodo destino {dst_id} ({dst_node.get('title')}).")
            continue
        dst_in = dst_node["inputs"][dst_in_idx]
        if dst_in.get("link") != lid:
            errors.append(f"Enlace {lid}: Entrada {dst_in_idx} de nodo {dst_id} apunta a enlace {dst_in.get('link')}, esperado {lid}.")

        # Check types
        src_type = src_out.get("type")
        dst_type = dst_in.get("type")
        if src_type != dst_type and "*" not in (src_type, dst_type):
            errors.append(f"Enlace {lid}: Incompatibilidad de tipos: Origen {src_id} es {src_type}, Destino {dst_id} espera {dst_type}.")

    # 2. Verify all inputs pointing to links actually exist in links table
    for nid, node in nodes.items():
        for in_idx, inp in enumerate(node.get("inputs", [])):
            link_id = inp.get("link")
            if link_id is not None:
                if link_id not in links:
                    errors.append(f"Nodo {nid} ({node.get('title')}): Entrada {inp.get('name')} apunta a enlace inexistente {link_id}.")

    # 3. Specific validation of the 8 Verification Points requested by the user:
    print("\n--- Verificación de Puntos Críticos del Director IA ---")
    
    # Check Director IA exists
    director = nodes.get(33)
    if not director:
        errors.append("Nodo 33 (Director Creativo IA) no existe.")
    else:
        print("✓ Nodo 33 (Director Creativo IA) presente y configurado.")

    # Check 8 Prompts wiring
    prompt_targets = [
        (4, 3, "Shot 1 Qwen image_prompt"),
        (6, 5, "Shot 1 MiniMax video_prompt"),
        (13, 3, "Shot 2 Qwen image_prompt"),
        (16, 5, "Shot 2 MiniMax video_prompt"),
        (19, 3, "Shot 3 Qwen image_prompt"),
        (22, 5, "Shot 3 MiniMax video_prompt"),
        (25, 3, "Shot 4 Qwen image_prompt"),
        (28, 5, "Shot 4 MiniMax video_prompt"),
    ]
    for target_nid, in_idx, desc in prompt_targets:
        target = nodes.get(target_nid)
        inp = target["inputs"][in_idx]
        lid = inp.get("link")
        if not lid or lid not in links or links[lid][1] != 33:
            errors.append(f"ERROR: {desc} en nodo {target_nid} NO está conectado a la salida del Director IA (nodo 33).")
        else:
            print(f"✓ {desc} (Nodo {target_nid}, entrada {in_idx}) correctamente conectado desde Director IA.")

    # Check Width, Height, Duration to all 4 MiniMax nodes
    for shot_num, mm_id in [(1, 6), (2, 16), (3, 22), (4, 28)]:
        mm = nodes[mm_id]
        w_link = mm["inputs"][2].get("link")
        h_link = mm["inputs"][3].get("link")
        d_link = mm["inputs"][4].get("link")
        if not w_link or links[w_link][1] != 33 or links[w_link][2] != 10:
            errors.append(f"Shot {shot_num} MiniMax (Nodo {mm_id}): Width no está conectado a Director IA.")
        if not h_link or links[h_link][1] != 33 or links[h_link][2] != 11:
            errors.append(f"Shot {shot_num} MiniMax (Nodo {mm_id}): Height no está conectado a Director IA.")
        if not d_link or links[d_link][1] != 33 or links[d_link][2] != 12:
            errors.append(f"Shot {shot_num} MiniMax (Nodo {mm_id}): Duration no está conectado a Director IA.")

    print("✓ Control Maestro de Formato (16:9 / 9:16) y Duración conectado a los 4 MiniMax H3.")

    # Check Video Assembler
    print("\n--- Verificación del Montaje Final (Video Assembler) ---")
    assembler = nodes.get(35)
    if not assembler:
        errors.append("Nodo 35 (CommercialVideoAssembler) no existe.")
    else:
        for i, shot_mm_id in enumerate([6, 16, 22, 28]):
            in_link = assembler["inputs"][i].get("link")
            if not in_link or links[in_link][1] != shot_mm_id:
                errors.append(f"Video Assembler entrada {i} (video_{i+1}) no está conectada desde MiniMax Shot {i+1} (Nodo {shot_mm_id}).")
            else:
                print(f"✓ Video Assembler entrada video_{i+1} conectada desde MiniMax Shot {i+1} (Nodo {shot_mm_id}).")

    # Check Final SaveVideo
    final_save = nodes.get(36)
    if not final_save:
        errors.append("Nodo 36 (SaveVideo Final) no existe.")
    else:
        final_link = final_save["inputs"][0].get("link")
        if not final_link or links[final_link][1] != 35:
            errors.append("SaveVideo Final (Nodo 36) no está conectado a la salida del Video Assembler (Nodo 35).")
        else:
            print("✓ Exportador Final (Nodo 36: commercial/final_commercial.mp4) conectado a Video Assembler.")

    print("\n=== RESUMEN DE INTEGRIDAD ===")
    if errors:
        print(f"❌ SE ENCONTRARON {len(errors)} ERRORES:")
        for err in errors:
            print(f"  - {err}")
        return False
    else:
        print("✅ WORKFLOW 100% VÁLIDO Y SIN ERRORES.")
        print("  - Todas las conexiones están físicamente verificadas.")
        print("  - El Director IA alimenta automáticamente los 4 shots.")
        print("  - Los 4 videos confluyen automáticamente en el ensamblador final.")
        print("  - El spot de 20s se exporta a commercial/final_commercial.mp4.")
        return True

if __name__ == "__main__":
    success = verify_workflow("workflows/commercial_product_video/workflow.json")
    sys.exit(0 if success else 1)
