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
         "Gloss": "high-gloss clearcoat finish with crisp reflections",
         "Matte": "matte paint finish with soft, diffuse reflections",
         "Satin": "satin paint finish with gentle sheen",
         "Metallic": "metallic flake finish that subtly sparkles"
     ]

     private static let effectPrompts: [String: String] = [
         "Pearlescent": "pearlescent effect with color shift under light",
         "Chrome": "chrome-like reflective effect (keep within realistic paint behavior)",
         "Two-Tone": "two-tone paint layout with tasteful separation lines",
         "Candy": "candy coat depth with rich, translucent layers"
     ]

    
    // MARK: - Vocab Maps (keys must match UI values exactly)
    private static let carTypePrompts: [String: String] = [
        "Sedan": "sleek sedan silhouette, four-door configuration, balanced proportions",
        "SUV": "modern SUV body, muscular stance, elevated ride height",
        "Hatchback": "compact hatchback form, short rear overhang, urban-friendly size",
        "Coupe": "two-door coupe, sporty proportions, low roofline",
        "Convertible": "convertible body style with open-top appearance",
        "Wagon": "long-roof wagon, extended cargo area, practical yet stylish",
        "Pickup": "pickup truck bed, rugged styling, practical stance",
        "Minivan": "spacious minivan body, sliding doors, family-oriented layout",
        "Sports Car": "low, wide sports car stance, performance-forward proportions",
        "Crossover": "crossover silhouette, car-like ride with SUV cues"
    ]

    private static let designStylePrompts: [String: String] = [
        "Muscle": "muscle car style, wide stance, aggressive hood bulge, bold presence",
        "Japanese": "Japanese tuner style, clean lines, tasteful aero, aftermarket vibe",
        "Modern": "contemporary design language, crisp surfaces, LED signature",
        "Luxurious": "premium luxury trim, chrome accents, fine materials, refined aesthetic",
        "Classic": "classic-inspired cues, timeless lines, subtle chrome details",
        "Sports": "sport package, aero kit, aggressive front fascia, performance look",
        "Retro": "retro-inspired details, nostalgic shapes blended with modern execution",
        "Futuristic": "futuristic elements, parametric surfacing, seamless lighting",
        "Off-Road": "off-road package, higher ground clearance, protective cladding",
        "Racing": "track-focused aero, low ride height, functional vents and splitter",
        "Minimalist": "minimal design, clean surfaces, restrained details, understated look",
        "Aggressive": "aggressive styling, sharp angles, dominant stance"
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

    private static let accessoryPrompts: [String: String] = [
        "Spoiler": "subtle rear spoiler",
        "Hood Scoop": "functional hood scoop",
        "Side Skirts": "side skirts for a lower visual stance",
        "Roof Rack": "sleek roof rack",
        "Bull Bar": "front bull bar for protection",
        "Mudflaps": "practical mudflaps",
        "Sunroof": "panoramic glass sunroof",
        "Tinted Windows": "tastefully tinted windows",
        "LED Strips": "accent LED light strips",
        "Racing Stripes": "dual racing stripes",
        "Chrome Trim": "additional chrome trim accents",
        "Custom Grille": "custom front grille",
        "Diffuser": "rear diffuser",
        "Fender Flares": "bolt-on fender flares"
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
