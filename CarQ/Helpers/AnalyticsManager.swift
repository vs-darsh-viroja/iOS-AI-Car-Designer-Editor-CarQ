//
//  AnalyticsManager.swift
//  CarQ
//
//  Created by Purvi Sancheti on 19/09/25.
//

import Foundation
import FirebaseAnalytics

///Manager to handle firebase app anaytics
final class AnalyticsManager {
    private init() {}
    
    static let shared = AnalyticsManager()
    
    public func log(_ event: AnalyticsEvent) {
        switch event {
        case .firstPaywallPayButtonClicked(let plandDetails), .internalPaywallPayButtonClicked(let plandDetails):
            print("\nEvent Logged\n")
            print("--------------------------------------------------\n")
            let eventName = "\(event.eventName)_Plan_Clicked"
            print("Event: \(eventName)")
            Analytics.logEvent(eventName, parameters: ["Plan":plandDetails.planName])
            break
        case .firstPaywallPlanPurchase(let plandDetails), .internalPaywallPlanPurchase(let plandDetails):
            print("\nEvent Logged\n")
            print("--------------------------------------------------\n")
            let eventName = "\(event.eventName)_Plan_Purchased"
            print("Event: \(eventName)")
            Analytics.logEvent(eventName, parameters: ["Plan":plandDetails.planName])
            break
        case .firstPaywallPlanRestore(let plandDetails),  .internalPaywallPlanRestore(let plandDetails):
            let eventName = "\(event.eventName)"
            print("Event: \(eventName)")
            Analytics.logEvent(eventName, parameters: nil)
            break
  
        default:
            print("\nEvent Logged\n")
            print("--------------------------------------------------\n")
            print("Event: \(event.eventName)")
            Analytics.logEvent(event.eventName, parameters: nil)
            break
        }
    }
}

enum AnalyticsEvent {
    //first paywall after on boarding
    case firstPaywallLoaded //
    case firstPaywallXClicked //
    case AdsClicked //
    
    case firstPaywallRestoreClicked //
    case firstPaywallPayButtonClicked(PlanDetails) //
    case firstPaywallPlanPurchase(PlanDetails) //
    case firstPaywallPlanRestore(PlanDetails) //
    
    //Internal paywall from validation and settings
    case internalPaywallLoaded //
    case internalPaywallXLoaded //
    case internalPaywallXClicked //
    case internalPaywallContinueWithAdsClicked //
    
    case internalPaywallRestoreClicked
    case internalPaywallPayButtonClicked(PlanDetails) //
    case internalPaywallPlanPurchase(PlanDetails) //
    case internalPaywallPlanRestore(PlanDetails) //
  
    
    //other events
   
    case giftScreenLoaded
    case giftScreenXClicked
    case giftScreenPlanPurchase
    case giftBottomSheetXClicked
    case giftBannerPlanPurchase
    
    // design style
    case cyberPunk
    case futuristic
    case japaneseGraphical
    case lowRider
    case modernLuxurious
    case muscle
    case offRoad
    case retroClassic
    case stealth
    case streetRacer
    
    //type
    case classic
    case coupe
    case luxury
    case minivan
    case motorcycle
    case pickupTruck
    case sedan
    case sports
    case sportsBike
    case suv
    case trailer

    //Accessories
    case alloyWheels
    case customExhaust
    case decals
    case neonLights
    case roofRack
    case sideSkirts
    case spoiler
    
    //Color
    case customColor
    case blackColorSelected
    case whiteColorSelected
    case redColorSelected
    case purpleColorSelected
    case blueColorSelected
    case greenColorSelected

    //Finish
    case chrome
    case glossy
    case matte
    case metallic
    case satin
    
    //Special Effects
    case dualTone
    case gradient
    case neonGlow
    case racingStripes
    
    //Change Type
    case resize
    case reshape
    case redesign
    
    case recreate
    case copy
    
    case createScreen
    case changeColor
    case RemoveObject
    case modifyObject
    case addObject
    case ReplaceObject
    
    case camera
    case gallery
    case getIdea
    case deleteOne
    case sort
    case saveToGallery
    case share
  
        
    case firstRatingPopupDisplayed
    case secondRatingPopupDisplayed
    case thirdRatingPopupDisplayed
    
    
    case noOfUserUpdatedApp
    
    case getPremiumFromAlert
    case watchanAd
    
    var eventName: String {
        switch self {
        case .firstPaywallLoaded: return "on_boarding_paywall_opened"
        case .firstPaywallXClicked: return "first_paywall_x_clicked"
        case .firstPaywallPayButtonClicked: return "first_paywall"
        case .firstPaywallRestoreClicked: return "first_paywall_restore_clicked"
        case .firstPaywallPlanPurchase: return "on_boarding_paywall"
        case .firstPaywallPlanRestore: return "first_paywall_plan_restore"
        case .internalPaywallLoaded: return "internal_paywall_opened"
        case .internalPaywallXLoaded: return "internal_paywall_x_loaded"
        case .internalPaywallXClicked: return "internal_paywall_x_clicked"
        case .internalPaywallPayButtonClicked: return "internal_paywall"
        case .internalPaywallRestoreClicked: return "internal_paywall_restore_clicked"
        case .internalPaywallPlanPurchase: return "internal_paywall"
        case .internalPaywallPlanRestore: return "internal_paywall_plan_restore"
      
            
            
        case .firstRatingPopupDisplayed: return "first_rating_popup_displayed"
        case .secondRatingPopupDisplayed: return "second_rating_popup_displayed"
        case .thirdRatingPopupDisplayed: return "third_rating_popup_displayed"
            
            
        case .giftScreenLoaded: return "giftscreenLoaded"
        case .giftScreenXClicked: return "giftscreen_closed"
        case .giftScreenPlanPurchase: return "giftscreen_planpurchase"
        case .giftBottomSheetXClicked: return "giftscreenbottomsheet_closed"
        case .giftBannerPlanPurchase: return "giftbanner_planpurchase"
        
            
       // Design Style
        case .cyberPunk: return "Cyber_Punk_Selected"
        case .futuristic: return "Futuristic_Selected"
        case .japaneseGraphical: return "Japanese_Graphical_Selected"
        case .lowRider: return "Low_Rider_Selected"
        case .modernLuxurious: return "Modern_Luxurious_Selected"
        case .muscle: return "Muscle_Selected"
        case .offRoad: return "Off_Road_Selected"
        case .retroClassic: return "Retro_Classic_Selected"
        case .stealth: return "Stealth_Selected"
        case .streetRacer: return "Street_Racer_Selected"
            
        // Car Type
        case .classic: return "Classic_Selected"
        case .coupe: return "Coupe_Selected"
        case .luxury: return "Luxury_Selected"
        case .minivan: return "Minivan_Selected"
        case .motorcycle: return "Motorcycle_Selected"
        case .pickupTruck: return "Pickup_Truck_Selected"
        case .sedan: return "Sedan_Selected"
        case .sports: return "Sports_Car_Selected"
        case .sportsBike: return "Sports_Bike_Selected"
        case .suv: return "SUV_Selected"
        case .trailer: return "Trailer_Selected"

        // Accessories
        case .alloyWheels: return "Alloy_Wheels_Selected"
        case .customExhaust: return "Custom_Exhaust_Selected"
        case .decals: return "Decals_Selected"
        case .neonLights: return "Neon_Lights_Selected"
        case .roofRack: return "Roof_Rack_Selected"
        case .sideSkirts: return "Side_Skirts_Selected"
        case .spoiler: return "Spoiler_Selected"
            
        // Color
        case .customColor: return "Custom_Color_Selected"
        case .blackColorSelected: return "Black_Color_Selected"
        case .whiteColorSelected: return "White_Color_Selected"
        case .redColorSelected: return "Red_Color_Selected"
        case .purpleColorSelected: return "Purple_Color_Selected"
        case .blueColorSelected: return "Blue_Color_Selected"
        case .greenColorSelected: return "Green_Color_Selected"

        // Finish
        case .chrome: return "Chrome_Selected"
        case .glossy: return "Glossy_Selected"
        case .matte: return "Matte_Selected"
        case .metallic: return "Metallic_Selected"
        case .satin: return "Satin_Selected"
            
        // Special Effects
        case .dualTone: return "Dual_Tone_Selected"
        case .gradient: return "Gradient_Selected"
        case .neonGlow: return "Neon_Glow_Selected"
        case .racingStripes: return "Racing_Stripes_Selected"
            
        // Change Type
        case .resize: return "Resize_Selected"
        case .reshape: return "Reshape_Selected"
        case .redesign: return "Redesign_Selected"
            
        case .recreate: return "Recreate_Selected"
        case .copy: return "Copy_Selected"
          
        case .createScreen: return "Created_Car"
        case .changeColor: return "Car_Color_Changed"
        case .RemoveObject: return "Car_Object_Removed"
        case .modifyObject: return "Car_Object_Modified"
        case .addObject: return "Added_Object_In_Car"
        case .ReplaceObject: return "Car_Object_Replaced"
            
            
        case .AdsClicked: return "ads_clicked"
            
            
        case .internalPaywallContinueWithAdsClicked: return "i_paywall_continue_with_ads_clicked"
           
        case .noOfUserUpdatedApp: return "appupdated"
   
        case .camera: return "camera_Button_pressed"
        case .gallery: return "gallery_Button_pressed"

        case .getIdea: return "inspire_pressed"
        case .deleteOne: return "delete_one_pressedd"
        case .sort: return "sort_pressed"
        case .saveToGallery: return "save_to_gallery_pressed"
        case .share: return "share_pressed"
        case .getPremiumFromAlert: return "get_premium_pressed_from_alert"
        case .watchanAd: return "watch_an_ad_pressed"
        }
    }
    
}


