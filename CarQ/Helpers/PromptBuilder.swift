//
//  PromptBuilder.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation

public enum PromptBuilder {
    
    // MARK: - Updated Finish Prompts
    private static let finishPrompts: [String: String] = [
        "Chrome":    "chrome-like reflective finish with mirror-like reflections",
        "Glossy":    "high-gloss clearcoat finish with crisp reflections",
        "Matte":     "matte paint finish with soft, diffuse reflections",
        "Metallic":  "metallic flake finish that subtly sparkles",
        "Satin":     "satin paint finish with gentle sheen"
    ]

    // MARK: - Updated Effect Prompts
    private static let effectPrompts: [String: String] = [
        "Dual-tone":      "dual-tone paint layout with tasteful color separation lines",
        "Gradient":       "smooth tonal gradient across the body within the chosen color family",
        "NeonGlow":       "neon glow effect with subtle luminescent accent lighting",
        "RacingStripes":  "racing stripe accent (clean, proportional, aligned with car body lines)"
    ]

    // MARK: - Updated UI → Canonical Aliases
    private static let finishAliases: [String: String] = [
        "Chrome":    "Chrome",
        "Glossy":    "Glossy",
        "Matte":     "Matte",
        "Metallic":  "Metallic",
        "Satin":     "Satin"
    ]

    private static let effectAliases: [String: String] = [
        "Dual-tone":      "Dual-tone",
        "Gradient":       "Gradient",
        "NeonGlow":       "NeonGlow",
        "RacingStripes":  "RacingStripes"
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


    
    // MARK: - Updated Accessory Prompts
    private static let accessoryPrompts: [String: String] = [
        "Alloy Wheels":   "add premium alloy wheels with custom design",
        "Custom Exhaust": "add a custom performance exhaust system",
        "Decals":         "add stylish automotive decals and graphics",
        "Neon Lights":    "add neon underglow lighting effects",
        "Roof Rack":      "add a practical roof rack system",
        "Side Skirts":    "add aerodynamic side skirts",
        "Spoiler":        "add a sporty rear spoiler"
    ]

    // MARK: - Updated Car Type Prompts
    private static let carTypePrompts: [String: String] = [
        "Classic":        "a timeless classic car body style",
        "Coupe":          "a sleek coupe body style",
        "Luxury":         "a premium luxury vehicle design",
        "Minivan":        "a practical family minivan body",
        "Motorcycle":     "a sleek motorcycle design",
        "Pickup Truck":   "a rugged pickup truck body",
        "Sedan":          "a traditional sedan body style",
        "Sports Bike":    "a high-performance sports bike design",
        "Sport":          "a low-profile sports car design",
        "SUV":            "a spacious SUV body style",
        "Trailer":        "a functional trailer design"
    ]

    // MARK: - Updated Design Style Prompts
    private static let designStylePrompts: [String: String] = [
        "CyberPunk":         "styled with cyberpunk aesthetic and futuristic neon elements",
        "Futuristic":        "styled with futuristic concept car elements and sleek lines",
        "Japanese Graphical": "inspired by Japanese tuner styling with bold graphics",
        "Low Rider":         "styled as a low rider with custom suspension and stance",
        "Modern Luxurious":  "styled with premium luxury detailing and modern elegance",
        "Muscle":            "inspired by classic American muscle car styling",
        "Off Road":          "built for off-road ruggedness with aggressive stance",
        "Retro Classic":     "styled with nostalgic retro classic automotive design",
        "Stealth":           "styled with stealth design elements and minimal visibility features",
        "Street Racer":      "styled for street racing with aggressive aerodynamics"
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
