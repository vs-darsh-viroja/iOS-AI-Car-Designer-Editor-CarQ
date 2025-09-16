//
//  PromptBuilder.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation

public enum PromptBuilder {
    
    // Optional vocab (use the strings your Finish/Effect pickers emit)

    private static let finishPrompts: [String: String] = [
        "High-Gloss":        "high-gloss clearcoat finish with crisp reflections",
        "Semi-Gloss":   "semi-gloss finish with moderate reflections",
        "Satin":        "satin paint finish with gentle sheen",
        "Matte":        "matte paint finish with soft, diffuse reflections",
        "Flat":         "flat paint finish with minimal reflectivity",
        "Textured":     "subtle textured finish (fine microtexture), keep realistic for automotive paint",
        "Brushed":      "brushed metal look with fine linear grain (keep subtle and realistic for automotive panels)",
        "Hammered":     "subtle hammered-metal texture (tasteful, realistic intensity)",
        "Crackle":      "fine crackle effect (very subtle, vintage-style; avoid heavy patterns)",
        "Distressed":   "lightly weathered patina effect (tasteful, realistic for automotive finish)",
        "Metallic":     "metallic flake finish that subtly sparkles" // keep as a finish variant too
    ]

    // Canonical Effect prompts (keys must match canonical names below)
    private static let effectPrompts: [String: String] = [
        "Pearlescent": "pearlescent effect with color shift under light",
        "Chrome":      "chrome-like reflective effect (keep within realistic paint behavior)",
        "Two-Tone":    "two-tone paint layout with tasteful separation lines",
        "Candy":       "candy coat depth with rich, translucent layers",
        "Metallic":    "metallic flake effect that adds subtle sparkle",
        "Sparkle":     "fine sparkle effect in the paint (subtle, tasteful)",
        "Gradient":    "smooth tonal gradient across the body within the chosen color family",
        "Stripes":     "racing stripe accent (clean, proportional, aligned with car body lines)",
        // new additions to reach 10:
        "Iridescent":  "iridescent paint effect with rainbow-like color shifts under light",
        "Holographic": "holographic effect with prismatic shimmer across the surface"
    ]

    // UI → Canonical aliases (case-sensitive to your UI strings)
    private static let finishAliases: [String: String] = [
        "High-Gloss":  "Gloss",
        "Semi-Gloss":  "Semi-Gloss",
        "Satin":       "Satin",
        "Matte":       "Matte",
        "Flat":        "Flat",
        "Textured":    "Textured",
        "Brushed":     "Brushed",
        "Hammered":    "Hammered",
        "Crackle":     "Crackle",
        "Distressed":  "Distressed",
        "Metallic":    "Metallic"
    ]

    private static let effectAliases: [String: String] = [
        "Pearl":    "Pearlescent",
        "Pearlescent": "Pearlescent",
        "Chrome":   "Chrome",
        "Two-Tone": "Two-Tone",
        "Candy":    "Candy",
        "Metallic": "Metallic",
        "Sparkle":  "Sparkle",
        "Gradient": "Gradient",
        "Stripes":  "Stripes",
        "Iridescent": "Iridescent",
        "Holographic": "Holographic",

    ]

    // Helpers to normalize selections to canonical keys
    private static func canonicalFinish(from uiValue: String?) -> String? {
        guard let v = uiValue, !v.isEmpty else { return nil }
        // if UI already passes canonical name, keep it
        if finishPrompts[v] != nil { return v }
        // else map alias
        return finishAliases[v]
    }

    private static func canonicalEffect(from uiValue: String?) -> String? {
        guard let v = uiValue, !v.isEmpty else { return nil }
        if effectPrompts[v] != nil { return v }
        return effectAliases[v]
    }


    
    // Accessory prompts
    private static let accessoryPrompts: [String: String] = [
        "Spoiler":      "add a sporty rear spoiler",
        "Hood Scoop":   "add a functional hood scoop",
        "Side Skirts":  "add aerodynamic side skirts",
        "Roof Rack":    "add a practical roof rack",
        "Bull Bar":     "add a rugged bull bar to the front",
        "Mudflaps":     "add durable mudflaps behind the wheels",
        "Sunroof":      "include a glass sunroof",
        "LED Strips":   "add modern LED accent strips",
        "Chrome Trim":  "enhance with chrome trim details",
        "Diffuser":     "add a performance rear diffuser"
    ]

    // Car type prompts
    private static let carTypePrompts: [String: String] = [
        "Standard":     "a standard passenger car body style",
        "Minivan":      "a practical family minivan body",
        "Bike":         "a sleek motorcycle design",
        "Hatchback":    "a compact hatchback design",
        "Sports Car":   "a low-profile sports car design",
        "Convertible":  "a convertible body style with open roof",
        "Pickup":       "a rugged pickup truck body",
        "Coupe":        "a compact coupe body style",
        "Wagon":        "a spacious station wagon design",
        "Crossover":    "a modern crossover SUV body"
    ]

    // Design style prompts
    private static let designStylePrompts: [String: String] = [
        "Muscle":       "inspired by classic American muscle car styling",
        "Japanese":     "inspired by sleek Japanese tuner styling",
        "Modern":       "with clean, modern automotive design cues",
        "Luxurious":    "styled with premium luxury detailing",
        "Classic":      "styled with timeless classic automotive design",
        "Sports":       "with aggressive sports styling",
        "Retro":        "styled with a nostalgic retro aesthetic",
        "Futuristic":   "styled with futuristic concept car elements",
        "Off-Road":     "built for off-road ruggedness",
        "Racing":       "styled for motorsport racing performance",
        "Minimalist":   "with a clean, minimalist automotive design",
        "Aggressive":   "with sharp, aggressive body styling"
    ]

    
    // NOTE: Keys here must match the `selectedColor` string values from ColorListView.
    // e.g. "blackIColor", "whiteColor", "custom", etc.
    private static let colorPrompts: [String: String] = [
        "blackIColor": "primary body color: gloss black paint",
        "whiteColor":  "primary body color: pearl white paint",
        "redColor":    "primary body color: vivid candy red paint",
        "purpleColor": "primary body color: deep purple metallic paint",
        "blueColor":   "primary body color: metallic blue paint",
        "greenColor":  "primary body color: rich emerald green paint"
        // Note: "custom" is handled separately with the actual hex/RGB values
    ]

    // MARK: - Magical Modification Change Type Prompts
    private static let changeTypePrompts: [String: String] = [
        "Resize": "resize the marked areas proportionally while maintaining realistic automotive design",
        "Reshape": "reshape the marked areas with smooth transitions and realistic automotive curves",
        "Redesign": "completely redesign the marked areas with modern automotive styling"
    ]

    // MARK: - Public API for Text-to-Image
    /// Primary overload with custom color support
    public static func buildTextPrompt(
        description: String,
        color: String?,
        customColorHex: String?,
        carType: String?,
        designStyle: String?,
        accessories: [String]
    ) -> String {
        var parts: [String] = []

        // 1) Required free-form description from user
        let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { parts.append(trimmed) }

        // 2) Optional: Color handling
        if let colorKey = color {
            if colorKey == "custom", let hexColor = customColorHex {
                // For custom colors, use the actual hex value
                parts.append("primary body color: custom paint in exact color \(hexColor), metallic finish with realistic reflections")
            } else if let presetColor = colorPrompts[colorKey] {
                // For preset colors, use the predefined description
                parts.append(presetColor)
            }
        }

        // 3) Optional: Car Type
        if let type = carType, let t = carTypePrompts[type], !t.isEmpty {
            parts.append(t)
        }

        // 4) Optional: Design Style
        if let style = designStyle, let s = designStylePrompts[style], !s.isEmpty {
            parts.append(s)
        }

        // 5) Optional: Accessories (support multi-select; de-duplicate)
        let accBits = Array(Set(accessories)).compactMap { accessoryPrompts[$0] }
        if !accBits.isEmpty { parts.append(accBits.joined(separator: ", ")) }

        // 6) Universal constraints/guardrails to keep outputs consistent
        parts.append("High quality automotive render, 3/4 front view. Realistic lighting and shadows. Balanced composition. No people, no text, no logos.")
        parts.append("Paint finish should look realistic with subtle reflections and proper color saturation. Preserve body proportions; avoid distortions.")

        return parts.joined(separator: " ")
    }

    /// Convenience overload for single accessory with custom color support
    public static func buildTextPrompt(
        description: String,
        color: String?,
        customColorHex: String?,
        carType: String?,
        designStyle: String?,
        accessory: String?
    ) -> String {
        let list: [String] = accessory.flatMap { $0.isEmpty ? nil : [$0] } ?? []
        return buildTextPrompt(
            description: description,
            color: color,
            customColorHex: customColorHex,
            carType: carType,
            designStyle: designStyle,
            accessories: list
        )
    }

    // MARK: - Backward-compatible overload (the one you were actually using)
    
    public static func buildTextPrompt(
        description: String,
        color: String?,
        carType: String?,
        designStyle: String?,
        accessory: String?
    ) -> String {
        return buildTextPrompt(
            description: description,
            color: color,
            customColorHex: nil,
            carType: carType,
            designStyle: designStyle,
            accessory: accessory
        )
    }
    
    //MARK: - Magical Modification

    public static func buildMagicalModificationPrompt(
        userPrompt: String,
        changeType: String
    ) -> String {
        var parts: [String] = []

        // 1) Add the change type instruction
        if let changeInstruction = changeTypePrompts[changeType] {
            parts.append(changeInstruction)
        }

        // 2) Add user's specific modification request
        let trimmed = userPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            parts.append("Specific modification request: \(trimmed)")
        }

        // 3) Add magical modification constraints
        parts.append("Apply changes only to the highlighted/masked areas. Maintain realistic automotive proportions and design language.")
        parts.append("Blend modifications seamlessly with existing car design. Keep original lighting, shadows, and perspective.")
        parts.append("High quality result with professional automotive finish. No distortions or unrealistic elements.")
        parts.append("Preserve the overall vehicle structure and only modify the specifically marked regions.")

        return parts.joined(separator: " ")
    }
    
    //MARK: - Change Color
    
     public static func buildChangeColorPrompt(
         colorKey: String?,          // e.g. "blackIColor" or "custom"
         customColorHex: String?,    // if colorKey == "custom"
         finish: String?,            // optional (e.g. "Matte", "Gloss")
         effect: String?             // optional (e.g. "Pearlescent")
     ) -> String {
         var parts: [String] = []

         // Color (required)
         if let key = colorKey {
             if key == "custom", let hex = customColorHex, !hex.isEmpty {
                 parts.append("Change the car body to exact paint color \(hex)")
             } else if let preset = colorPrompts[key] {
                 parts.append(preset.replacingOccurrences(of: "primary body color:", with: "Change the car body to"))
             }
         }

         // Finish (optional)
         if let f = finish, let fText = finishPrompts[f] ?? (f.isEmpty ? nil : "\(f.lowercased()) paint finish") {
             parts.append(fText)
         }

         // Special Effect (optional)
         if let e = effect, let eText = effectPrompts[e] ?? (e.isEmpty ? nil : "\(e.lowercased()) effect") {
             parts.append(eText)
         }

         // Guardrails (keep result realistic)
         parts.append("Apply recolor realistically to painted body panels only; do not change glass, lights, tires, or wheels.")
         parts.append("Maintain original shading, reflections, highlights and body lines; no warping or extra parts.")
         parts.append("High quality automotive render, consistent perspective, no text or logos.")

         return parts.joined(separator: " ")
     }
    
    //MARK: - Remove Object
    
    
    public static func buildRemoveObjectPrompt(objectHints: [String]? = nil) -> String {
        var parts: [String] = []
        if let hints = objectHints, !hints.isEmpty {
            parts.append("Remove the highlighted parts: \(hints.joined(separator: ", ")).")
        } else {
            parts.append("Remove the highlighted parts from the car (e.g., lights, sunroof, badges).")
        }
        parts.append("Use inpainting to realistically fill the removed regions with surrounding car surfaces.")
        parts.append("Preserve original lighting, reflections, body lines, perspective, and environment.")
        parts.append("Only modify masked areas; do not alter glass, tires, wheels, or unmasked panels.")
        parts.append("High-quality, artifact-free result with seamless blending.")
        return parts.joined(separator: " ")
    }
    
    //MARK: - Modify Object
    
    public static func buildModifyObjectPrompt(
        userPrompt: String,
        hasReference: Bool
    ) -> String {
        var parts: [String] = []

        // 1. User’s request (always required)
        let trimmed = userPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            parts.append("Modify the highlighted areas: \(trimmed)")
        }

        // 2. Reference image hint
        if hasReference {
            parts.append("Use the provided reference image to guide the modification style or details.")
        }

        // 3. Guardrails
        parts.append("Apply changes only to the highlighted/masked regions.")
        parts.append("Maintain correct car proportions, perspective, and realism.")
        parts.append("Blend seamlessly with the existing vehicle design.")
        parts.append("High quality professional automotive result. No distortions, no artifacts.")

        return parts.joined(separator: " ")
    }

    //MARK: - Add Object
    
    public static func buildAddObjectPrompt(
        userPrompt: String,
        hasReference: Bool
    ) -> String {
        var parts: [String] = []

        // 1. User’s request
        let trimmed = userPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            parts.append("Add new object(s) in the highlighted areas: \(trimmed)")
        }

        // 2. Reference image hint
        if hasReference {
            parts.append("Use the provided reference image to guide the appearance, style, or details of the new object.")
        }

        // 3. Guardrails
        parts.append("Apply additions only to the highlighted/masked regions.")
        parts.append("Maintain correct car proportions, perspective, and realism.")
        parts.append("Blend seamlessly with the existing vehicle design and environment.")
        parts.append("High quality professional automotive result. No distortions, no artifacts.")

        return parts.joined(separator: " ")
    }
    
    
    //MARK: - Replace Object
    
    public static func buildReplaceObjectPrompt(
        userPrompt: String,
        hasReference: Bool
    ) -> String {
        var parts: [String] = []

        // 1. User’s request
        let trimmed = userPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            parts.append("Replace the highlighted object(s) with: \(trimmed)")
        }

        // 2. Reference image hint
        if hasReference {
            parts.append("Use the provided reference image to guide the replacement style, details, or appearance.")
        }

        // 3. Guardrails
        parts.append("Apply changes only to the highlighted/masked regions.")
        parts.append("Remove the original object completely and insert the new one naturally.")
        parts.append("Maintain correct car proportions, perspective, and realism.")
        parts.append("Blend seamlessly with the surrounding vehicle design and environment.")
        parts.append("High quality professional automotive result. No distortions, no artifacts.")

        return parts.joined(separator: " ")
    }


    
}
