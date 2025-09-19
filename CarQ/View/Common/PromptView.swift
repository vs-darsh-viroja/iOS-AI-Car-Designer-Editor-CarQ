//
//  PromptView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI

struct PromptView: View {
    
    var screen: String
    @Binding var prompt: String
    @FocusState.Binding var isInputFocused: Bool
    
        // MARK: - State for shuffled run
    @State private var createPrompts: [String] = CreatePrompts.all.shuffled()
    @State private var magicalModificationPrompts: [String] = MagicalModificationPrompts.all.shuffled()
    @State private var modifyObjectPrompts: [String] = ModifyObjectPrompts.all.shuffled()
    @State private var addObjectPrompts: [String] = AddObjectPrompts.all.shuffled()
    @State private var replaceObjectPrompts: [String] = ReplaceObjectPrompts.all.shuffled()
    @State private var currentIndex: Int = 0
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
       
            Image(.promptField)
                .resizable()
                .frame(width:  isIPad ?  ScaleUtility.scaledValue(715) : ScaleUtility.scaledValue(345),
                       height:  isIPad ?  ScaleUtility.scaledValue(210) : ScaleUtility.scaledValue(160))
                .overlay {
                    VStack {
                        
                        ZStack(alignment: .topLeading) {
                            if prompt.isEmpty {
                                Text("Enter your prompt...")
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                    .foregroundColor(Color.primaryApp.opacity(0.25))
                             
                            }
                            
                            CustomTextEditor(text: $prompt)
                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                .focused($isInputFocused)
                                .scrollContentBackground(.hidden)
                                .background(.clear)
                                .foregroundColor(Color.primaryApp)
                                .offset(x: ScaleUtility.scaledSpacing(-3), y: ScaleUtility.scaledSpacing(-7))
                      
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                            Button {
                                impactFeedback.impactOccurred()
                                prompt = ""
                            } label: {
                                Text("Clear")
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.primaryApp.opacity(0.5))
                            }

                            Spacer()
                            
                            Button {
                            AnalyticsManager.shared.log(.getIdea)
                            impactFeedback.impactOccurred()
                            switch screen {
                                case "Create":
                                    return  showNextCreatePrompt()
                                case "MagicalModification":
                                    return showNextMagicalModificationPrompt()
                                case "ModifyObject":
                                    return showNextModifyObjectPrompt()
                                case "AddObject":
                                    return showNextAddObjectPrompt()
                                case "ReplaceObject":
                                    return showNextReplaceObjectPrompt()
                                default:
                                    return showNextCreatePrompt()
                                
                                }
                                
                             
                                
                                showNextCreatePrompt()
                            } label: {
                                HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                    
                                    Image(.lampIcon)
                                        .resizable()
                                        .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                                    
                                    Text("Get Idea")
                                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(14)))
                                        .foregroundColor(Color.primaryApp.opacity(0.5))
                                    
                                }
                        
                                
                            }

                        }
                       
                        
                    }
                    .padding(.horizontal, isIPad ?  ScaleUtility.scaledSpacing(25) : ScaleUtility.scaledSpacing(15))
                    .padding(.vertical, isIPad ? ScaleUtility.scaledSpacing(25) : ScaleUtility.scaledSpacing(15))
                }
        
    }
    
    private func showNextCreatePrompt() {
        guard !createPrompts.isEmpty else { return }
        prompt = createPrompts[currentIndex]
        currentIndex += 1

        if currentIndex >= createPrompts.count {
            // Reshuffle for a fresh random run after showing all 30
            createPrompts.shuffle()
            currentIndex = 0
        }
    }
    
    private func showNextMagicalModificationPrompt() {
        guard !magicalModificationPrompts.isEmpty else { return }
        prompt = magicalModificationPrompts[currentIndex]
        currentIndex += 1

        if currentIndex >= magicalModificationPrompts.count {
            // Reshuffle for a fresh random run after showing all 30
            magicalModificationPrompts.shuffle()
            currentIndex = 0
        }
    }
    
    private func showNextModifyObjectPrompt() {
        guard !modifyObjectPrompts.isEmpty else { return }
        prompt = modifyObjectPrompts[currentIndex]
        currentIndex += 1

        if currentIndex >= modifyObjectPrompts.count {
            // Reshuffle for a fresh random run after showing all 30
            modifyObjectPrompts.shuffle()
            currentIndex = 0
        }
    }
    
    private func showNextAddObjectPrompt() {
        guard !addObjectPrompts.isEmpty else { return }
        prompt = addObjectPrompts[currentIndex]
        currentIndex += 1

        if currentIndex >= addObjectPrompts.count {
            // Reshuffle for a fresh random run after showing all 30
            addObjectPrompts.shuffle()
            currentIndex = 0
        }
    }
    
    private func showNextReplaceObjectPrompt() {
        guard !replaceObjectPrompts.isEmpty else { return }
        prompt = replaceObjectPrompts[currentIndex]
        currentIndex += 1

        if currentIndex >= replaceObjectPrompts.count {
            // Reshuffle for a fresh random run after showing all 30
            replaceObjectPrompts.shuffle()
            currentIndex = 0
        }
    }
    
}
