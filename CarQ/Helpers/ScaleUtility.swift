//
//  ScaleUtility.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//



import Foundation
import UIKit
import SwiftUI

struct ScaleUtility {
  static let width = UIScreen.main.bounds.width
  static let height = UIScreen.main.bounds.height
  static let designWidth: CGFloat = 375
  static let designHeight: CGFloat = 825
  static func isPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
  }
  static func scaledValue(_ value: CGFloat) -> CGFloat {
    if isPad() {
      return (width / (designWidth * 2)) * value
    } else {
      return (width / designWidth) * value
    }
  }
    
    static func scaledSpacing(_ baseValue: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = screenWidth / (isIPad ? designWidth * 2 : designWidth)
        if isPad() {
            return baseValue * scaleFactor
        } else {
            return baseValue * scaleFactor
        }
    }
}
