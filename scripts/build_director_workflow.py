"""
Script to build and wire the complete advanced Commercial Video Workflow with:
1. Director IA (Prompt Generator)
2. Master Controls (Idea, Format 16:9/9:16, Duration, Style)
3. 4-Shot Physical Generation Pipeline (Qwen + MiniMax)
4. Automated Video Assembler (Concatenates Shot 1-4 with synchronized audio)
5. Master Commercial MP4 Export
"""

import json

with open("workflows/commercial_product_video/workflow.json", "r", encoding="utf-8") as f:
    wf = json.load(f)

# Keep track of existing nodes and links
existing_nodes = {n["id"]: n for n in wf.get("nodes", [])}
existing_links = list(wf.get("links", []))
groups = list(wf.get("groups", []))

print(f"Loaded existing workflow with {len(existing_nodes)} nodes and {len(existing_links)} links.")

# Node 30: IDEA GENERAL DEL ANUNCIO (PrimitiveStringMultiline)
node_30 = {
    "id": 30,
    "type": "PrimitiveStringMultiline",
    "pos": [120, -580],
    "size": [400, 260],
    "flags": {},
    "order": 0,
    "mode": 0,
    "inputs": [],
    "outputs": [
        {
            "name": "STRING",
            "type": "STRING",
            "links": [33],
            "localized_name": "STRING"
        }
    ],
    "title": "💡 1. IDEA GENERAL DEL ANUNCIO (Escribe aquí tu visión)",
    "properties": {
        "Node name for S&R": "PrimitiveStringMultiline"
    },
    "widgets_values": [
        "Quiero un anuncio de lujo para este perfume. La modelo está en un ambiente nocturno elegante, transmite sensualidad y sofisticación. El producto debe sentirse exclusivo y premium."
    ],
    "color": "#1b4965",
    "bgcolor": "#132d42"
}

# Node 32: LLM Provider / Entrada Externa (PrimitiveStringMultiline)
node_32 = {
    "id": 32,
    "type": "PrimitiveStringMultiline",
    "pos": [120, -280],
    "size": [400, 240],
    "flags": {},
    "order": 1,
    "mode": 0,
    "inputs": [],
    "outputs": [
        {
            "name": "STRING",
            "type": "STRING",
            "links": [34],
            "localized_name": "STRING"
        }
    ],
    "title": "🧠 2. Entrada LLM / JSON Externo (Opcional)",
    "properties": {
        "Node name for S&R": "PrimitiveStringMultiline"
    },
    "widgets_values": [
        ""
    ],
    "color": "#3d2645",
    "bgcolor": "#27172e"
}

# Node 33: CommercialCreativeDirector
node_33 = {
    "id": 33,
    "type": "CommercialCreativeDirector",
    "pos": [560, -580],
    "size": [460, 540],
    "flags": {},
    "order": 2,
    "mode": 0,
    "inputs": [
        {
            "name": "idea",
            "type": "STRING",
            "link": 33,
            "localized_name": "idea",
            "widget": {"name": "idea"}
        },
        {
            "name": "style",
            "type": "STRING",
            "link": None,
            "localized_name": "style",
            "widget": {"name": "style"}
        },
        {
            "name": "aspect_ratio",
            "type": "STRING",
            "link": None,
            "localized_name": "aspect_ratio",
            "widget": {"name": "aspect_ratio"}
        },
        {
            "name": "duration_seconds",
            "type": "FLOAT",
            "link": None,
            "localized_name": "duration_seconds",
            "widget": {"name": "duration_seconds"}
        },
        {
            "name": "optional_llm_json",
            "type": "STRING",
            "link": 34,
            "localized_name": "optional_llm_json",
            "widget": {"name": "optional_llm_json"}
        }
    ],
    "outputs": [
        {"name": "shot_01_image_prompt", "type": "STRING", "links": [35], "localized_name": "shot_01_image_prompt"},
        {"name": "shot_01_video_prompt", "type": "STRING", "links": [36], "localized_name": "shot_01_video_prompt"},
        {"name": "shot_02_image_prompt", "type": "STRING", "links": [37], "localized_name": "shot_02_image_prompt"},
        {"name": "shot_02_video_prompt", "type": "STRING", "links": [38], "localized_name": "shot_02_video_prompt"},
        {"name": "shot_03_image_prompt", "type": "STRING", "links": [39], "localized_name": "shot_03_image_prompt"},
        {"name": "shot_03_video_prompt", "type": "STRING", "links": [40], "localized_name": "shot_03_video_prompt"},
        {"name": "shot_04_image_prompt", "type": "STRING", "links": [41], "localized_name": "shot_04_image_prompt"},
        {"name": "shot_04_video_prompt", "type": "STRING", "links": [42], "localized_name": "shot_04_video_prompt"},
        {"name": "campaign_plan_json", "type": "STRING", "links": [], "localized_name": "campaign_plan_json"},
        {"name": "width", "type": "INT", "links": [43, 44, 45, 46], "localized_name": "width"},
        {"name": "height", "type": "INT", "links": [47, 48, 49, 50], "localized_name": "height"},
        {"name": "duration", "type": "FLOAT", "links": [51, 52, 53, 54], "localized_name": "duration"}
    ],
    "title": "🎬 3. DIRECTOR CREATIVO IA (Generador de Prompts y Plan de Rodaje)",
    "properties": {
        "Node name for S&R": "CommercialCreativeDirector"
    },
    "widgets_values": [
        "Quiero un anuncio de lujo para este perfume. La modelo está en un ambiente nocturno elegante, transmite sensualidad y sofisticación. El producto debe sentirse exclusivo y premium.",
        "Luxury & Exclusive",
        "16:9 (Horizontal - 1280x720)",
        5.0,
        ""
    ],
    "color": "#8c5000",
    "bgcolor": "#5c3300"
}

# Node 34: MarkdownNote Guía de Director IA
node_34 = {
    "id": 34,
    "type": "MarkdownNote",
    "pos": [1060, -580],
    "size": [660, 540],
    "flags": {},
    "order": 3,
    "mode": 0,
    "inputs": [],
    "outputs": [],
    "title": "📋 Control Maestro: Reglas del Director IA & Formato Dinámico",
    "properties": {},
    "widgets_values": [
        "### 🌟 Guía del Director Creativo IA\n\n"
        "1. **💡 Idea General del Anuncio:** Escribe tu visión en el Nodo 30. No necesitas pensar en prompts técnicos; el Director IA traduce tu idea en una narrativa coherente de 4 escenas publicitarias.\n"
        "2. **🎭 Estilos Disponibles:** `Luxury & Exclusive`, `Beauty & Cosmetics`, `Cinematic & Moody`, `High-Tech Minimalist`, `Fresh & Vibrant`.\n"
        "3. **📐 Selector de Formato (16:9 vs 9:16):**\n"
        "   - **16:9 (1280x720):** Master horizontal para YouTube, TV y Web.\n"
        "   - **9:16 (720x1280):** Master vertical para TikTok, Instagram Reels y YouTube Shorts.\n"
        "   *Al cambiar este selector, las dimensiones de los cuatro MiniMax H3 se actualizan automáticamente en tiempo real.*\n"
        "4. **⏱️ Duración Global:** 5.0 segundos por shot (20 segundos totales para el spot final).\n"
        "5. **🧠 Modularidad LLM:** Si dejas la entrada externa vacía, el motor publicitario nativo sintetiza los 8 prompts cinematográficos al instante sin gastar VRAM ni APIs. Si conectas un LLM externo, parseará el JSON generado de forma transparente."
    ],
    "color": "#2a363b",
    "bgcolor": "#1c2427"
}

# Node 35: CommercialVideoAssembler
node_35 = {
    "id": 35,
    "type": "CommercialVideoAssembler",
    "pos": [500, 4580],
    "size": [440, 360],
    "flags": {},
    "order": 100,
    "mode": 0,
    "inputs": [
        {"name": "video_1", "type": "VIDEO", "link": 55, "localized_name": "video_1"},
        {"name": "video_2", "type": "VIDEO", "link": 56, "localized_name": "video_2"},
        {"name": "video_3", "type": "VIDEO", "link": 57, "localized_name": "video_3"},
        {"name": "video_4", "type": "VIDEO", "link": 58, "localized_name": "video_4"},
        {"name": "filename_prefix", "type": "STRING", "link": None, "localized_name": "filename_prefix", "widget": {"name": "filename_prefix"}},
        {"name": "audio_mode", "type": "STRING", "link": None, "localized_name": "audio_mode", "widget": {"name": "audio_mode"}},
        {"name": "optional_master_soundtrack", "type": "AUDIO", "link": None, "localized_name": "optional_master_soundtrack"}
    ],
    "outputs": [
        {"name": "final_video", "type": "VIDEO", "links": [59], "localized_name": "final_video"}
    ],
    "title": "🎞️ Montaje Automático: Ensamblador de 4 Shots (FFmpeg / PyAV)",
    "properties": {
        "Node name for S&R": "CommercialVideoAssembler"
    },
    "widgets_values": [
        "commercial/final_commercial",
        "Concatenate Shot Audios (Native MiniMax)"
    ],
    "color": "#1b4965",
    "bgcolor": "#132d42"
}

# Node 36: SaveVideo Final Commercial
node_36 = {
    "id": 36,
    "type": "SaveVideo",
    "pos": [980, 4580],
    "size": [360, 260],
    "flags": {},
    "order": 101,
    "mode": 0,
    "inputs": [
        {"name": "video", "type": "VIDEO", "link": 59, "localized_name": "video"}
    ],
    "outputs": [],
    "title": "🏆 SPOT PUBLICITARIO FINAL: 20s (commercial/final_commercial.mp4)",
    "properties": {
        "Node name for S&R": "SaveVideo"
    },
    "widgets_values": [
        "commercial/final_commercial",
        "auto",
        "auto"
    ],
    "color": "#27ae60",
    "bgcolor": "#1e8449"
}

# Node 37: MarkdownNote Video Assembler
node_37 = {
    "id": 37,
    "type": "MarkdownNote",
    "pos": [1380, 4580],
    "size": [540, 360],
    "flags": {},
    "order": 102,
    "mode": 0,
    "inputs": [],
    "outputs": [],
    "title": "🎵 Arquitectura de Audio y Montaje Final",
    "properties": {},
    "widgets_values": [
        "### 🎞️ Montaje Secuencial Automatizado\n\n"
        "- **Orden de Edición:** `SHOT 1 (Hero)` ➔ `SHOT 2 (Macro)` ➔ `SHOT 3 (Beauty)` ➔ `SHOT 4 (Packshot)`.\n"
        "- **Preservación Total:** Ejecutado mediante FFmpeg con `-c copy` para garantizar cero pérdida de calidad, manteniendo resolución idéntica (16:9 ó 9:16) y 24 FPS constantes.\n"
        "- **Audio Sincronizado:** Cada clip de MiniMax H3 aporta su diseño sonoro estéreo nativo. El ensamblador concatena las pistas de audio en perfecta sincronización milimétrica.\n"
        "- **Pista Musical Maestra:** El nodo 35 cuenta con una entrada opcional `optional_master_soundtrack` para conectar posteriormente un tema musical completo para el comercial."
    ],
    "color": "#2a363b",
    "bgcolor": "#1c2427"
}

# Rewire existing Shot nodes:
# Node 4 (Qwen Shot 1): input 3 prompt -> link 35 (from Node 33 out 0)
existing_nodes[4]["inputs"][3]["link"] = 35

# Node 6 (MiniMax Shot 1):
# input 2 (width) -> link 43
# input 3 (height) -> link 47
# input 4 (value_1 / duration) -> link 51
# input 5 (prompt) -> link 36 (from Node 33 out 1)
existing_nodes[6]["inputs"][2]["link"] = 43
existing_nodes[6]["inputs"][3]["link"] = 47
existing_nodes[6]["inputs"][4]["link"] = 51
existing_nodes[6]["inputs"][5]["link"] = 36
# Update Node 6 output links list to include link 55 (to Node 35 in 0)
existing_nodes[6]["outputs"][0]["links"].append(55)

# Node 13 (Qwen Shot 2): input 3 prompt -> link 37 (from Node 33 out 2)
existing_nodes[13]["inputs"][3]["link"] = 37

# Node 16 (MiniMax Shot 2):
# input 2 (width) -> link 44
# input 3 (height) -> link 48
# input 4 (value_1 / duration) -> link 52
# input 5 (prompt) -> link 38 (from Node 33 out 3)
existing_nodes[16]["inputs"][2]["link"] = 44
existing_nodes[16]["inputs"][3]["link"] = 48
existing_nodes[16]["inputs"][4]["link"] = 52
existing_nodes[16]["inputs"][5]["link"] = 38
existing_nodes[16]["outputs"][0]["links"].append(56)

# Node 19 (Qwen Shot 3): input 3 prompt -> link 39 (from Node 33 out 4)
existing_nodes[19]["inputs"][3]["link"] = 39

# Node 22 (MiniMax Shot 3):
# input 2 (width) -> link 45
# input 3 (height) -> link 49
# input 4 (value_1 / duration) -> link 53
# input 5 (prompt) -> link 40 (from Node 33 out 5)
existing_nodes[22]["inputs"][2]["link"] = 45
existing_nodes[22]["inputs"][3]["link"] = 49
existing_nodes[22]["inputs"][4]["link"] = 53
existing_nodes[22]["inputs"][5]["link"] = 40
existing_nodes[22]["outputs"][0]["links"].append(57)

# Node 25 (Qwen Shot 4): input 3 prompt -> link 41 (from Node 33 out 6)
existing_nodes[25]["inputs"][3]["link"] = 41

# Node 28 (MiniMax Shot 4):
# input 2 (width) -> link 46
# input 3 (height) -> link 50
# input 4 (value_1 / duration) -> link 54
# input 5 (prompt) -> link 42 (from Node 33 out 7)
existing_nodes[28]["inputs"][2]["link"] = 46
existing_nodes[28]["inputs"][3]["link"] = 50
existing_nodes[28]["inputs"][4]["link"] = 54
existing_nodes[28]["inputs"][5]["link"] = 42
existing_nodes[28]["outputs"][0]["links"].append(58)

# The manual prompt nodes (3, 5, 12, 15, 18, 21, 24, 27) links are now disconnected from active Qwen/MiniMax
for pid in [3, 5, 12, 15, 18, 21, 24, 27]:
    if pid in existing_nodes:
        existing_nodes[pid]["outputs"][0]["links"] = []

# Filter existing links to remove the old manual prompt links:
# Link 3 (Node 3 -> Node 4)
# Link 5 (Node 5 -> Node 6)
# Link 11 (Node 12 -> Node 13)
# Link 15 (Node 15 -> Node 16)
# Link 19 (Node 18 -> Node 19)
# Link 23 (Node 21 -> Node 22)
# Link 27 (Node 24 -> Node 25)
# Link 31 (Node 27 -> Node 28)
old_manual_links = {3, 5, 11, 15, 19, 23, 27, 31}
clean_links = [l for l in existing_links if l[0] not in old_manual_links]

# Define all new links:
new_links = [
    # Link 33: Node 30[out 0] -> Node 33[in 0] (STRING idea)
    [33, 30, 0, 33, 0, "STRING"],
    # Link 34: Node 32[out 0] -> Node 33[in 4] (STRING optional_llm_json)
    [34, 32, 0, 33, 4, "STRING"],

    # Prompts to Shots 1 to 4:
    [35, 33, 0, 4, 3, "STRING"],    # shot_01_image_prompt -> Qwen Shot 1
    [36, 33, 1, 6, 5, "STRING"],    # shot_01_video_prompt -> MiniMax Shot 1
    [37, 33, 2, 13, 3, "STRING"],   # shot_02_image_prompt -> Qwen Shot 2
    [38, 33, 3, 16, 5, "STRING"],   # shot_02_video_prompt -> MiniMax Shot 2
    [39, 33, 4, 19, 3, "STRING"],   # shot_03_image_prompt -> Qwen Shot 3
    [40, 33, 5, 22, 5, "STRING"],   # shot_03_video_prompt -> MiniMax Shot 3
    [41, 33, 6, 25, 3, "STRING"],   # shot_04_image_prompt -> Qwen Shot 4
    [42, 33, 7, 28, 5, "STRING"],   # shot_04_video_prompt -> MiniMax Shot 4

    # Width connections to all 4 MiniMax nodes:
    [43, 33, 9, 6, 2, "INT"],
    [44, 33, 9, 16, 2, "INT"],
    [45, 33, 9, 22, 2, "INT"],
    [46, 33, 9, 28, 2, "INT"],

    # Height connections to all 4 MiniMax nodes:
    [47, 33, 10, 6, 3, "INT"],
    [48, 33, 10, 16, 3, "INT"],
    [49, 33, 10, 22, 3, "INT"],
    [50, 33, 10, 28, 3, "INT"],

    # Duration connections to all 4 MiniMax nodes:
    [51, 33, 11, 6, 4, "FLOAT"],
    [52, 33, 11, 16, 4, "FLOAT"],
    [53, 33, 11, 22, 4, "FLOAT"],
    [54, 33, 11, 28, 4, "FLOAT"],

    # Video Assembler connections:
    [55, 6, 0, 35, 0, "VIDEO"],     # Shot 1 video -> Video Assembler video_1
    [56, 16, 0, 35, 1, "VIDEO"],    # Shot 2 video -> Video Assembler video_2
    [57, 22, 0, 35, 2, "VIDEO"],    # Shot 3 video -> Video Assembler video_3
    [58, 28, 0, 35, 3, "VIDEO"],    # Shot 4 video -> Video Assembler video_4

    # Final Video Export:
    [59, 35, 0, 36, 0, "VIDEO"]     # Assembler final_video -> SaveVideo
]

all_links = clean_links + new_links

# Add new nodes
all_nodes = list(existing_nodes.values()) + [node_30, node_32, node_33, node_34, node_35, node_36, node_37]

# Add Groups for Master Control and Video Assembler
group_master = {
    "title": "🌟 PANEL DE CONTROL MAESTRO: DIRECTOR CREATIVO IA & FORMATO",
    "bounding": [80, -680, 2260, 680],
    "color": "#1c2833",
    "font_size": 28
}

group_assembler = {
    "title": "🎞️ MONTAJE AUTOMÁTICO & SPOT PUBLICITARIO FINAL (20 SEGUNDOS)",
    "bounding": [460, 4520, 1880, 500],
    "color": "#27ae60",
    "font_size": 28
}

updated_groups = [group_master] + groups + [group_assembler]

# Update workflow dictionary
wf["nodes"] = all_nodes
wf["links"] = all_links
wf["groups"] = updated_groups

with open("workflows/commercial_product_video/workflow.json", "w", encoding="utf-8") as f:
    json.dump(wf, f, indent=2, ensure_ascii=False)

print(f"Successfully updated workflow.json!")
print(f"Total nodes: {len(all_nodes)}")
print(f"Total links: {len(all_links)}")
print(f"Total groups: {len(updated_groups)}")
