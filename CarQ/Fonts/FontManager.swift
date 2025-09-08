//
//  FontManager.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//


import Foundation
import SwiftUI

struct FontManager {
    
    static var ChakraPetchRegularFont = "ChakraPetch-Regular"
    static var ChakraPetchMediumFont = "ChakraPetch-Medium"
    static var ChakraPetchSemiBoldFont = "ChakraPetch-SemiBold"
    static var ChakraPetchBoldFont = "ChakraPetch-Bold"
    

    
    // MARK: - ChakraPetch
    
    static func ChakraPetchRegularFont(size: CGFloat) -> Font {
        .custom(ChakraPetchRegularFont, size: size)
    }
    
    static func ChakraPetchMediumFont(size: CGFloat) -> Font {
        .custom(ChakraPetchMediumFont, size: size)
    }
    
    static func ChakraPetchSemiBoldFont(size: CGFloat) -> Font {
        .custom(ChakraPetchSemiBoldFont, size: size)
    }
    
    static func ChakraPetchBoldFont(size: CGFloat) -> Font {
        .custom(ChakraPetchBoldFont, size: size)
    }
  

}
