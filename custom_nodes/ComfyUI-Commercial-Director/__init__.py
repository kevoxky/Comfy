"""
ComfyUI Commercial Director & Video Assembler Extension
Provides:
1. CommercialCreativeDirector: AI Director generating 8 structured prompts & shooting plan from a single campaign idea.
2. CommercialVideoAssembler: Automated video concatenator joining Shot 1 to 4 with synchronized audio into final_commercial.mp4.
"""

from .director_node import CommercialCreativeDirector
from .assembler_node import CommercialVideoAssembler

NODE_CLASS_MAPPINGS = {
    "CommercialCreativeDirector": CommercialCreativeDirector,
    "CommercialVideoAssembler": CommercialVideoAssembler,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "CommercialCreativeDirector": "🎬 DIRECTOR CREATIVO IA (Plan de Rodaje 4 Shots)",
    "CommercialVideoAssembler": "🎞️ ENSAMBLADOR DE VIDEO PUBLICITARIO (Final Commercial)",
}

__all__ = ["NODE_CLASS_MAPPINGS", "NODE_DISPLAY_NAME_MAPPINGS"]
