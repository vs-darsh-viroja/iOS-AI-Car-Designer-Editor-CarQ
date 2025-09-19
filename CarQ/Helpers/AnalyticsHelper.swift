//
//  AnalyticsHelper.swift
//  CarQ
//
//  Created by Purvi Sancheti on 19/09/25.
//

import Foundation

struct AnalyticsHelper {
    
    static func logSelectionAnalytics(
        designStyle: String? = nil,
        carType: String? = nil,
        accessory: String? = nil,
        color: String? = nil,
        customColorHex: String? = nil,
        finish: String? = nil,
        speicalEffect: String? = nil
    ) {
        // Log design style analytics
        if let designStyle = designStyle {
            logDesignStyleAnalytics(designStyle: designStyle)
        }
        
        // Log car type analytics
        if let carType = carType {
            logCarTypeAnalytics(carType: carType)
        }
        
        // Log accessory analytics
        if let accessory = accessory {
            logAccessoryAnalytics(accessory: accessory)
        }
        
        if let finish = finish {
            logFinishAnalytics(finish: finish)
        }
        
        
        if let speicalEffect = speicalEffect {
            logSpecialEffectAnalytics(specialEffect: speicalEffect)
        }
        
        // Log color analytics
        logColorAnalytics(color: color, customColorHex: customColorHex)
    }
    
    // MARK: - Private Helper Methods
    
    private static func logFinishAnalytics(finish: String) {
        guard !finish.isEmpty else { return }
        switch finish {
        case "Chrome":
            AnalyticsManager.shared.log(.chrome)
        case "Glossy":
            AnalyticsManager.shared.log(.glossy)
        case "Matte":
            AnalyticsManager.shared.log(.matte)
        case "Metallic":
            AnalyticsManager.shared.log(.metallic)
        case "Satin":
            AnalyticsManager.shared.log(.satin)
        default:
            break
        }
     }
    
    private static func logSpecialEffectAnalytics(specialEffect: String) {
        guard !specialEffect.isEmpty else { return }
        switch specialEffect {
        case "Duall-tone":
            AnalyticsManager.shared.log(.chrome)
        case "Gradient":
            AnalyticsManager.shared.log(.glossy)
        case "Neon Glow":
            AnalyticsManager.shared.log(.matte)
        case "Racing Stripes":
            AnalyticsManager.shared.log(.metallic)
        default:
            break
        }
     }
    
    
    private static func logDesignStyleAnalytics(designStyle: String) {
        guard !designStyle.isEmpty else { return }
        
        switch designStyle {
        case "Cyberpunk":
            AnalyticsManager.shared.log(.cyberPunk)
        case "Futuristic":
            AnalyticsManager.shared.log(.futuristic)
        case "Japanese Graphical":
            AnalyticsManager.shared.log(.japaneseGraphical)
        case "Low Rider":
            AnalyticsManager.shared.log(.lowRider)
        case "Modern Luxurious":
            AnalyticsManager.shared.log(.modernLuxurious)
        case "Muscle":
            AnalyticsManager.shared.log(.muscle)
        case "Off Road":
            AnalyticsManager.shared.log(.offRoad)
        case "Retro Classic":
            AnalyticsManager.shared.log(.retroClassic)
        case "Stealth":
            AnalyticsManager.shared.log(.stealth)
        case "Street Racer":
            AnalyticsManager.shared.log(.streetRacer)
        default:
            break
        }
    }
    
    private static func logCarTypeAnalytics(carType: String) {
        guard !carType.isEmpty else { return }
        
        switch carType {
        case "Classic":
            AnalyticsManager.shared.log(.classic)
        case "Coupe":
            AnalyticsManager.shared.log(.coupe)
        case "Luxury":
            AnalyticsManager.shared.log(.luxury)
        case "Minivan":
            AnalyticsManager.shared.log(.minivan)
        case "Motorcycle":
            AnalyticsManager.shared.log(.motorcycle)
        case "Pickup Truck":
            AnalyticsManager.shared.log(.pickupTruck)
        case "Sedan":
            AnalyticsManager.shared.log(.sedan)
        case "Sport":
            AnalyticsManager.shared.log(.sports)
        case "Sports Bike":
            AnalyticsManager.shared.log(.sportsBike)
        case "SUV":
            AnalyticsManager.shared.log(.suv)
        case "Trailer":
            AnalyticsManager.shared.log(.trailer)
        default:
            break
        }
    }
    
    private static func logAccessoryAnalytics(accessory: String) {
        guard !accessory.isEmpty else { return }
        
        switch accessory {
        case "AlloyWheels":
            AnalyticsManager.shared.log(.alloyWheels)
        case "CustomExhaust":
            AnalyticsManager.shared.log(.customExhaust)
        case "Decals":
            AnalyticsManager.shared.log(.decals)
        case "NeonLights":
            AnalyticsManager.shared.log(.neonLights)
        case "RoofRack":
            AnalyticsManager.shared.log(.roofRack)
        case "SideSkirts":
            AnalyticsManager.shared.log(.sideSkirts)
        case "Spoiler":
            AnalyticsManager.shared.log(.spoiler)
        default:
            break
        }
    }
    
    private static func logColorAnalytics(color: String?, customColorHex: String?) {
        // Log custom color if available
        if customColorHex != nil {
            AnalyticsManager.shared.log(.customColor)
            return
        }
        
        // Log predefined color selection
        guard let color = color, !color.isEmpty else { return }
        
        switch color {
        case "blackIColor":
            AnalyticsManager.shared.log(.blackColorSelected)
        case "whiteColor":
            AnalyticsManager.shared.log(.whiteColorSelected)
        case "redColor":
            AnalyticsManager.shared.log(.redColorSelected)
        case "purpleColor":
            AnalyticsManager.shared.log(.purpleColorSelected)
        case "blueColor":
            AnalyticsManager.shared.log(.blueColorSelected)
        case "greenColor":
            AnalyticsManager.shared.log(.greenColorSelected)
        default:
            break
        }
    }
}
