//
//  PromptBuilder.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation

public enum PromptBuilder {
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

    // MARK: - NEW: Magical Modification Prompt Builder
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
}
