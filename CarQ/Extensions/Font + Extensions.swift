//
//  Font + Extensions.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import Foundation
import SwiftUI

extension CGFloat {
    
  static func scaledFontSize(_ baseSize: CGFloat) -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    let scaleFactor = screenWidth / 375
    if isIPad {
      return baseSize * scaleFactor * 0.7
    } else {
      return baseSize * scaleFactor
    }
  }
}
