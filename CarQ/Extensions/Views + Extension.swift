//
//  Views + Extension.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation

import Foundation
import SwiftUI

let isIPad = UIDevice.current.userInterfaceIdiom == .pad

extension View
{
    var screenSize: CGSize {
        UIScreen.main.bounds.size
    }
    
    var heightRatio: CGFloat
    {
        screenSize.height / 812
    }
    var widthRatio: CGFloat {
        screenSize.width / 375
    }
    
    var ipadWidthRatio: CGFloat {
        screenSize.width / 820
    }
    
    var ipadHeightRatio: CGFloat {
        screenSize.height / 1366
        
    }
    
    var isBigIpadDevice: Bool {
        screenSize.height > 1300
    }
    
  
    var isSmalliphone: Bool {
        screenSize.height < 810
    }
    
    var isBigiphone: Bool {
        screenSize.height > 810
    }
    var isSmallDevice: Bool {
        screenSize.height < 812
    }
    

 
}
