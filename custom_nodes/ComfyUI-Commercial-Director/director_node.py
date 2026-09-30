"""
Commercial Creative Director Node for ComfyUI
Generates a structured 4-shot advertising plan and 8 dedicated prompts (4 for Qwen Image Edit, 4 for MiniMax H3)
based on a single commercial concept/idea and art direction style.
Supports both autonomous built-in director engine and modular external LLM JSON parsing.
"""

import json
import re

class CommercialCreativeDirector:
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "idea": ("STRING", {
                    "multiline": True,
                    "default": "Quiero un anuncio de lujo para este perfume. La modelo está en un ambiente nocturno elegante, transmite sensualidad y sofisticación. El producto debe sentirse exclusivo y premium.",
                    "tooltip": "Describe la idea general del anuncio publicitario."
                }),
                "style": ([
                    "Luxury & Exclusive",
                    "Beauty & Cosmetics",
                    "Cinematic & Moody",
                    "High-Tech Minimalist",
                    "Fresh & Vibrant",
                    "Custom"
                ], {
                    "default": "Luxury & Exclusive",
                    "tooltip": "Dirección artística y paleta estética general de la campaña."
                }),
                "aspect_ratio": ([
                    "16:9 (Horizontal - 1280x720)",
                    "9:16 (Vertical - 720x1280)"
                ], {
                    "default": "16:9 (Horizontal - 1280x720)",
                    "tooltip": "Relación de aspecto para los 4 shots de video."
                }),
                "duration_seconds": ("FLOAT", {
                    "default": 5.0,
                    "min": 1.0,
                    "max": 10.0,
                    "step": 0.5,
                    "tooltip": "Duración de cada clip individual (MiniMax H3)."
                }),
            },
            "optional": {
                "optional_llm_json": ("STRING", {
                    "multiline": True,
                    "default": "",
                    "tooltip": "Entrada opcional desde un nodo LLM (TextGenerate / API). Si se conecta, parsea el JSON automáticamente."
                })
            }
        }

    RETURN_TYPES = (
        "STRING", "STRING",
        "STRING", "STRING",
        "STRING", "STRING",
        "STRING", "STRING",
        "STRING",
        "INT", "INT", "FLOAT"
    )

    RETURN_NAMES = (
        "shot_01_image_prompt", "shot_01_video_prompt",
        "shot_02_image_prompt", "shot_02_video_prompt",
        "shot_03_image_prompt", "shot_03_video_prompt",
        "shot_04_image_prompt", "shot_04_video_prompt",
        "campaign_plan_json",
        "width", "height", "duration"
    )

    FUNCTION = "generate_campaign"
    CATEGORY = "Commercial AI/Director"

    def _clean_json_str(self, text):
        text = text.strip()
        # Remove markdown code fences if present
        if text.startswith("```"):
            text = re.sub(r"^```[a-zA-Z]*\n", "", text)
            text = re.sub(r"\n```$", "", text)
            text = text.strip()
        return text

    def generate_campaign(self, idea, style, aspect_ratio, duration_seconds, optional_llm_json=""):
        # Resolve dimensions
        if "9:16" in aspect_ratio or "Vertical" in aspect_ratio:
            width = 720
            height = 1280
        else:
            width = 1280
            height = 720

        duration = float(duration_seconds)

        # Case 1: External LLM provided valid JSON
        parsed_llm = None
        if optional_llm_json and optional_llm_json.strip():
            try:
                cleaned = self._clean_json_str(optional_llm_json)
                parsed_llm = json.loads(cleaned)
            except Exception as e:
                print(f"[CommercialDirector] Warning: Could not parse optional_llm_json as JSON: {e}")

        if parsed_llm and isinstance(parsed_llm, dict):
            s1_img = parsed_llm.get("shot_01_image_prompt", "")
            s1_vid = parsed_llm.get("shot_01_video_prompt", "")
            s2_img = parsed_llm.get("shot_02_image_prompt", "")
            s2_vid = parsed_llm.get("shot_02_video_prompt", "")
            s3_img = parsed_llm.get("shot_03_image_prompt", "")
            s3_vid = parsed_llm.get("shot_03_video_prompt", "")
            s4_img = parsed_llm.get("shot_04_image_prompt", "")
            s4_vid = parsed_llm.get("shot_04_video_prompt", "")
            plan_json = json.dumps(parsed_llm, indent=2, ensure_ascii=False)
            return (s1_img, s1_vid, s2_img, s2_vid, s3_img, s3_vid, s4_img, s4_vid, plan_json, width, height, duration)

        # Case 2: Autonomous High-End Creative Director Engine
        # Synthesize campaign based on Idea and Style
        idea_clean = idea.strip()
        
        # Style presets visual dictionary
        style_keywords = {
            "Luxury & Exclusive": {
                "lighting": "dramatic chiaroscuro duotone rim lighting, rich deep blacks, warm gold reflections",
                "ambiance": "exclusive haute couture night atmosphere, architectural marble and velvet interior",
                "audio": "deep resonant sub-bass chord, crystalline chime sparkle, ultra-pure silky room acoustics"
            },
            "Beauty & Cosmetics": {
                "lighting": "soft wrapped beauty dish glow, luminous porcelain highlights, creamy bokeh",
                "ambiance": "high-end cosmetic studio with pearlescent gradients and delicate silk drapery",
                "audio": "sensual airy shimmer, delicate glass friction harmonics, gentle rhythmic heartbeat pulse"
            },
            "Cinematic & Moody": {
                "lighting": "anamorphic film lighting, subtle volumetric atmospheric mist, warm tungsten key and cool cyan shadows",
                "ambiance": "nocturnal penthouse overlooking modern skyline, high-contrast reflective glass surfaces",
                "audio": "cinematic analog synth drone, low-frequency suspense swell, sophisticated metallic resonance"
            },
            "High-Tech Minimalist": {
                "lighting": "clean precision laser rim lighting, pristine cold white highlights, sterile dark studio",
                "ambiance": "monolithic matte black pedestal, floating micro-droplets, razor-sharp architectural clarity",
                "audio": "crisp digital transient click, pristine glass ping, resonant sub-harmonic bass drop"
            },
            "Fresh & Vibrant": {
                "lighting": "brilliant golden hour sunlight, prism flares, radiant soft reflections",
                "ambiance": "luxurious sunlit terrace with water caustics, fresh botanicals and pure liquid drops",
                "audio": "bright acoustic shimmer sweep, uplifting warm resonance, clean atmospheric wind tone"
            },
            "Custom": {
                "lighting": "flawless commercial advertising studio lighting with controlled reflections and deep contrast",
                "ambiance": "premium commercial advertising environment, elegant composition and textures",
                "audio": "sophisticated modern commercial audio, pristine high-end frequency balance"
            }
        }.get(style, {
            "lighting": "high-end luxury advertising studio lighting",
            "ambiance": "exclusive commercial environment",
            "audio": "pristine luxury sound design"
        })

        # Shot 1: Hero Fusion
        s1_img = (
            f"Commercial hero advertising still for a prestigious luxury campaign based on: '{idea_clean}'. "
            f"Seamless, fotorrealistic composite of the elegant model from image 1 holding the luxury product from image 2. "
            f"Atmosphere: {style_keywords['ambiance']}. "
            f"Lighting: {style_keywords['lighting']}. "
            f"Strict 100% preservation of the model's exact facial features, skin texture, and bone structure from image 1. "
            f"Absolute fidelity to the product geometry, cap, glass facets, typography and logo from image 2. "
            f"Editorial Vogue cover quality, Hasselblad 80mm lens, natural pose, premium cosmetic advertisement."
        )

        s1_vid = (
            f"SHOT 1 HERO: Slow cinematic push-in and delicate pan reveal. The camera glides forward towards the elegant model "
            f"who gazes with sophisticated confidence while showcasing the perfume bottle. Natural micro-expressions, subtle slow eye blink, "
            f"subtle hair movement in gentle breeze. The product remains 100% rigid, tack-sharp, and physically grounded in her hand. "
            f"Continuous single take, 24fps cinematic filmic cadence, no morphing, no artifacts.\n"
            f"Audio: {style_keywords['audio']}, subtle silky fabric glide sweep, immersive spatial luxury ambience."
        )

        # Shot 2: Product Close-Up / Macro
        s2_img = (
            f"Extreme macro commercial photography of the premium product from image 2. "
            f"The camera frames an intimate close-up highlighting the pristine crystalline glass, metallic pump finish, and tack-sharp typography of the logo. "
            f"Surrounded by {style_keywords['ambiance']}. "
            f"Lighting: {style_keywords['lighting']}, with shimmering caustics reflecting through the perfume liquid. "
            f"100mm macro lens, ultra-shallow depth of field, glistening condensation micro-droplets on glass, 100% original bottle shape and label preservation, award-winning still."
        )

        s2_vid = (
            f"SHOT 2 MACRO: Slow orbital arc camera move around the perfume bottle. The camera executes a smooth micro-controlled slide, "
            f"revealing the faceted bottle silhouette as warm specular highlights slide across the embossed logo and metallic cap. "
            f"The product remains completely locked, solid, and distortion-free throughout the entire shot. "
            f"Smooth rack focus from the gold nozzle down to the brand typography, steady 24fps motion.\n"
            f"Audio: crystalline high-frequency glass chime, delicate liquid droplet resonance, low-end spatial sub-bass, elegant tactile click."
        )

        # Shot 3: Model Beauty Shot
        s3_img = (
            f"High-fashion beauty editorial portrait of the model from image 1. "
            f"Tight medium close-up, gently bringing the luxury product from image 2 towards her neck and collarbone. "
            f"Serene, magnetic, and confident expression. "
            f"Preserve the exact identity, facial bone structure, natural skin pores, and eye color from image 1. "
            f"Lighting: {style_keywords['lighting']}, wrapping around her cheekbones and the bottle contours. "
            f"The perfume bottle is held delicately with natural hand ergonomics, keeping label and cap fully recognizable. Masterpiece cosmetic beauty visual."
        )

        s3_vid = (
            f"SHOT 3 BEAUTY: Intimate slow-motion beauty camera glide. The camera drifts in a gentle upward diagonal towards the model's eyes "
            f"as she softly tilts her head, presenting the perfume bottle with effortless elegance. "
            f"Natural breathing, gentle eyelash flutter, soft focus fall-off, light glints on the bottle in her fingers. "
            f"Flawless temporal stability, zero face flickering, continuous take, 24fps cinematic movement.\n"
            f"Audio: warm sensual ambient drone, soft airy vocal shimmer, delicate breathing texture, sophisticated cinematic pulse."
        )

        # Shot 4: Final Packshot / CTA
        s4_img = (
            f"Prestige commercial final packshot. The luxury perfume bottle from image 2 stands proudly centered on a dark obsidian polished marble pedestal "
            f"with mirror-like reflections. "
            f"Lighting: {style_keywords['lighting']}, with a dramatic overhead spotlight casting amber flares through the glass container. "
            f"Clean, generous negative space at the upper third intentionally designed for brand logo, typography, and commercial slogan. "
            f"100% faithful representation of bottle silhouette, cap texture, and label clarity. Iconic campaign finale."
        )

        s4_vid = (
            f"SHOT 4 PACKSHOT: Grand finale camera tilt-up and slow pedestal crane rise. The camera smoothly ascends from the base of the pedestal, "
            f"framing the luxury perfume bottle in full splendor. Light beams slowly shift across the gold cap, producing a subtle premium starburst glint. "
            f"Bottle remains rock-solid, tack-sharp, and locked in space. Expansive clean space for final CTA slogan, continuous single take.\n"
            f"Audio: grand resolving cinematic sub-bass chord, elegant crystal chime crescendo, warm ethereal synth pad decay, authoritative brand finale tone."
        )

        campaign_data = {
            "campaign_concept": idea_clean,
            "visual_style": style,
            "format": "16:9 (1280x720)" if width == 1280 else "9:16 (720x1280)",
            "duration_per_shot_seconds": duration,
            "shot_01_image_prompt": s1_img,
            "shot_01_video_prompt": s1_vid,
            "shot_02_image_prompt": s2_img,
            "shot_02_video_prompt": s2_vid,
            "shot_03_image_prompt": s3_img,
            "shot_03_video_prompt": s3_vid,
            "shot_04_image_prompt": s4_img,
            "shot_04_video_prompt": s4_vid,
            "music_direction": f"Modern luxury advertising soundtrack with {style_keywords['audio']}.",
            "sound_design_direction": "Individual high-fidelity stereo audio per shot, seamlessly cross-fading into the master commercial.",
            "final_cta": "Exclusive Luxury Fragrance. Discover the Essence."
        }

        plan_json = json.dumps(campaign_data, indent=2, ensure_ascii=False)

        return (
            s1_img, s1_vid,
            s2_img, s2_vid,
            s3_img, s3_vid,
            s4_img, s4_vid,
            plan_json,
            width, height, duration
        )
