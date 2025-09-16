//
//  ToolsView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct Tool {
    let name: String
    let imageName: String
    let color: Color
}
  
struct ToolsView: View {
    
    var tools: [Tool] = [
        Tool(name: "Magical\nModification", imageName: "modificationIcon",color: Color.appOrange),
        Tool(name: "Change\nColor", imageName: "changeColorIcon",color: Color.appYellow),
        Tool(name: "Remove\nObject", imageName: "removeObjectIcon",color: Color.appRed),
        Tool(name: "Modify\nObject", imageName: "modifyObjectIcon", color: Color.appPurple),
        Tool(name: "Add\nObject", imageName: "addObjectIcon", color: Color.appBlue),
        Tool(name: "Replace\nObject", imageName: "replaceObjectIcon", color: Color.appPink)
    ]
    
    @State var isMagicalnModification: Bool = false
    @State var isChangenColor: Bool = false
    @State var isRemoveObject: Bool = false
    @State var isModifyObject: Bool = false
    @State var isAddObject: Bool = false
    @State var isReplaceObject: Bool = false
    
    @State private var twinkle = false

    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(15)) {
            
            // Create 3 rows with 2 cards each
            ForEach(0..<3, id: \.self) { rowIndex in
                HStack(spacing: ScaleUtility.scaledSpacing(20)) {
                    // Get 2 tools for this row
                    ForEach(0..<2, id: \.self) { columnIndex in
                        let toolIndex = rowIndex * 2 + columnIndex
                        if toolIndex < tools.count {
                            let tool = tools[toolIndex]
                            
                            Button(action: {
                                // Handle tap action based on tool
                                handleToolTap(for: tool.name)
                            }) {
                         
                                    Image(.toolsBg)
                                        .resizable()
                                        .frame(width: isIPad ? ScaleUtility.scaledValue(345) : ScaleUtility.scaledValue(165),
                                               height: isIPad ? ScaleUtility.scaledValue(230) : ScaleUtility.scaledValue(170))
                                        .overlay {
                                            Image(.toolsOverlayBg)
                                                .resizable()
                                                .frame(width: isIPad ? ScaleUtility.scaledValue(345) : ScaleUtility.scaledValue(165),
                                                       height: isIPad ? ScaleUtility.scaledValue(230) : ScaleUtility.scaledValue(170))
                                        }
                                        .overlay(alignment: .topTrailing) {
                                            Image(.starsIcon)
                                                .resizable()
                                                .frame(
                                                    width: isIPad ?  ScaleUtility.scaledValue(176) : ScaleUtility.scaledValue(76),
                                                    height: isIPad ? ScaleUtility.scaledValue(67)  : ScaleUtility.scaledValue(47)
                                                )
                                                // ✨ twinkle
                                                .opacity(twinkle ? 1.0 : 0.35)
                                                .scaleEffect(twinkle ? 1.04 : 1.00)
                                                // optional: stagger each card's twinkle a bit using toolIndex
                                                .animation(
                                                    .easeInOut(duration: 0.9)
                                                        .repeatForever(autoreverses: true)
                                                        .delay(Double(toolIndex) * 0.15),
                                                    value: twinkle
                                                )
                                                .padding(.top, ScaleUtility.scaledSpacing(13))
                                                .padding(.trailing, ScaleUtility.scaledSpacing(8))
                                        }

                                        .overlay(alignment: .leading) {
                                            VStack(alignment: .leading) {
                                                Image(tool.imageName)
                                                    .resizable()
                                                    .frame(width: isIPad ? ScaleUtility.scaledValue(51.2) : ScaleUtility.scaledValue(31.2)
                                                           , height: isIPad ? ScaleUtility.scaledValue(51.2) :  ScaleUtility.scaledValue(31.2))
                                                    .padding(.all, ScaleUtility.scaledSpacing(10.4))
                                                    .background {
                                                        Circle()
                                                            .fill(tool.color)
                                                       
                                                    }
                                                
                                                Spacer()
                                               
                                                Text(tool.name)
                                                    .font(FontManager.ChakraPetchMediumFont(size: .scaledFontSize(18)))
                                                    .foregroundColor(Color.primaryApp)
                                            }
                                            .padding(.leading, ScaleUtility.scaledSpacing(16))
                                            .padding(.vertical, ScaleUtility.scaledSpacing(16))
                                        }
                                
                            }
                            .buttonStyle(PlainButtonStyle()) // Remove default button styling
                        }
                    }
                }
            }
        }
        .onAppear { twinkle = true }
        .navigationDestination(isPresented: $isMagicalnModification) {
            MagicalModificationView(onBack: {
                isMagicalnModification = false
            })
            .background(Color.secondaryApp.ignoresSafeArea(.all))
        }
        .navigationDestination(isPresented: $isChangenColor) {
            ChangeColorView(onBack: {
                isChangenColor = false
            })
            .background(Color.secondaryApp.ignoresSafeArea(.all))
        }
        .navigationDestination(isPresented: $isRemoveObject) {
            RemoveObjectView(onBack: {
                isRemoveObject = false
            })
            .background(Color.secondaryApp.ignoresSafeArea(.all))
        }
        .navigationDestination(isPresented: $isModifyObject) {
            ModifyObjectView(onBack: {
                isModifyObject = false
            })
            .background(Color.secondaryApp.ignoresSafeArea(.all))
        }
        .navigationDestination(isPresented: $isAddObject) {
            AddObjectView(onBack: {
                isAddObject = false
            })
            .background(Color.secondaryApp.ignoresSafeArea(.all))
        }
        .navigationDestination(isPresented: $isReplaceObject) {
            ReplaceObjectView(onBack: {
                isReplaceObject = false
            })
            .background(Color.secondaryApp.ignoresSafeArea(.all))
        }
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
    }
    
    // Handle different tool selections
    private func handleToolTap(for toolName: String) {
        switch toolName {
        case "Magical\nModification":
            isMagicalnModification = true
        case "Change\nColor":
            isChangenColor = true
        case "Remove\nObject":
            isRemoveObject = true
        case "Modify\nObject":
            isModifyObject = true
        case "Add\nObject":
            isAddObject = true
        case "Replace\nObject":
            isReplaceObject = true
        default:
            break
        }
    }
}
