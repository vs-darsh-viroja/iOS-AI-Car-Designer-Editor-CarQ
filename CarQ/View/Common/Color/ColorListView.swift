//
//  ColorListView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import SwiftUI

// 2) Your view
struct ColorListView: View {
    @Binding var selectedColor: String
    @Binding var customColorHex: String? // ADD THIS BINDING

    // store custom color in both Color & UIColor to bridge the picker
    @State private var pickerColor: Color = .blue
    @State private var uiPickerColor: UIColor = .blue

    @State private var showSystemPicker = false

    struct Colour { let colorname: String; let colorimage: String }

    private let Colors: [Colour] = [
        .init(colorname: "",               colorimage: "colorPlateIcon"), // first = system picker
        .init(colorname: "blackIColor",    colorimage: "blackIColorIcon"),
        .init(colorname: "whiteColor",     colorimage: "whiteColorIcon"),
        .init(colorname: "redColor",       colorimage: "redColorIcon"),
        .init(colorname: "purpleColor",    colorimage: "purpleColorIcon"),
        .init(colorname: "blueColor",      colorimage: "blueColorIcon"),
        .init(colorname: "greenColor",     colorimage: "greenColorIcon"),
    ]

    private func color(from name: String) -> Color {
        switch name {
        case "blackIColor": return Color.selectedBlack
        case "whiteColor":  return Color.selectedWhite
        case "redColor":    return Color.selectedRed
        case "purpleColor": return Color.selectedPurple
        case "blueColor":   return Color.selectedBlue
        case "greenColor":  return Color.selectedGreen
        case "custom":      return pickerColor
        default:            return .clear
        }
    }
    let selectionFeedback = UISelectionFeedbackGenerator()
    private var previewColor: Color { color(from: selectedColor) }

    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(13)) {
            HStack(spacing: ScaleUtility.scaledSpacing(8)) {
                Text("Color")
                    .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(18)))
                    .foregroundColor(Color.primaryApp)

                Rectangle()
                    .frame(width: ScaleUtility.scaledValue(16), height: ScaleUtility.scaledValue(16))
                    .foregroundColor(previewColor)
            
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, ScaleUtility.scaledSpacing(15))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ScaleUtility.scaledSpacing(12)) {
                    ForEach(Colors.indices, id: \.self) { idx in
                        let item = Colors[idx]
                        let isPickerPlate = item.colorname.isEmpty
                        // Fixed: Now correctly checks if custom color is selected for the colorPlateIcon
                        let isSelected = isPickerPlate ? (selectedColor == "custom")
                                                       : (selectedColor == item.colorname)

                        Button {
                            if isPickerPlate {
                                selectionFeedback.selectionChanged()
                                // Toggle custom color selection
                                if selectedColor == "custom" {
                                    // Deselect custom color
                                    selectedColor = ""
                                    customColorHex = nil
                                } else {
                                    // Open color picker to select new custom color
                                    uiPickerColor = UIColor(pickerColor)
                                    showSystemPicker = true
                                }
                            } else {
                                selectionFeedback.selectionChanged()
                                if selectedColor == item.colorname {
                                    selectedColor = ""
                                } else {
                                    selectedColor = item.colorname
                                    customColorHex = nil
                                }
             
                            }
                        } label: {
                            ZStack {
                                Image(isSelected ? .colorOverlay2 : .colorOverlay1)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(60),
                                           height: ScaleUtility.scaledValue(60))
                                Image(item.colorimage)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(48),
                                           height: ScaleUtility.scaledValue(48))
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            }
        }
        // Present the custom color picker sheet with instant apply button
        .sheet(isPresented: $showSystemPicker) {
            ColorPickerSheet(
                uiColor: $uiPickerColor,
                isPresented: $showSystemPicker
            ) { selectedUIColor in
                // This closure is called when "Apply Color" button is pressed
                pickerColor = Color(selectedUIColor)
                selectedColor = "custom"
                
                // CONVERT UIColor TO HEX STRING
                customColorHex = selectedUIColor.toHexString()
            }
            .presentationDetents(  isIPad
                                     ? [.large, .fraction(0.95)]
                                     :  [.fraction(0.9)])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - UIColor Extension to convert to hex
extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    func toRGBString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        return "RGB(\(r), \(g), \(b))"
    }
}
