//
//  FooterView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation
import SwiftUI

struct FooterView: View {

    var onSave: () -> Void
    var onDelete: () -> Void
    var onShare: () -> Void
    @Binding var generatedImage: UIImage?
    @Binding var buttonDisabled: Bool
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    let selectionFeedback = UISelectionFeedbackGenerator()
    let notificationFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        VStack(spacing: ScaleUtility.scaledSpacing(10)) {
            
            Button(action: {
                AnalyticsManager.shared.log(.saveToGallery)
                notificationFeedback.notificationOccurred(.success)
                onSave()
            }) {
                HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                    Image(.downloadIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                    
                    Text("Save to Gallery")
                        .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp)
                }
                .frame(maxWidth: .infinity)
                .frame(height: ScaleUtility.scaledValue(60))
                .background {
                    Image(.buttonBg2)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: ScaleUtility.scaledValue(60))
                        .overlay {
                            Image(.buttonOverlay2)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: ScaleUtility.scaledValue(60))
                        }
                }
            }
    
            
            HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                
                Button {
                    
                    notificationFeedback.notificationOccurred(.warning)
                    onDelete()
                } label: {
                    HStack {
                        
                        Image(.deleteIcon2)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                        
                        Text("Delete")
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.primaryApp)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(60))
                    .background {
                        Image(.buttonBg1)
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .frame(height: ScaleUtility.scaledValue(60))
                            .overlay {
                                Image(.buttonOverlay1)
                                    .resizable()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: ScaleUtility.scaledValue(60))
                            }
                    }
                }
    
                
                if let img = generatedImage {
                    
                    ShareLink(
                        item: ShareablePhoto(uiImage: img),
                        preview: SharePreview( "CarQ Image", image: Image(uiImage: img))
                    ) {
                        HStack {
                            
                            Image(.shareIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                            
                            Text("Share")
                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.primaryApp)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: ScaleUtility.scaledValue(60))
                        .background {
                            Image(.buttonBg1)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: ScaleUtility.scaledValue(60))
                                .overlay {
                                    Image(.buttonOverlay1)
                                        .resizable()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: ScaleUtility.scaledValue(60))
                                }
                        }
                    }
                }
                else {
                    
                    Button {
                        AnalyticsManager.shared.log(.share)
                        notificationFeedback.notificationOccurred(.success)
                        onShare()
                    } label: {
                        
                        HStack {
                            
                            Image(.shareIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                            
                            Text("Share")
                                .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(18)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.primaryApp)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: ScaleUtility.scaledValue(60))
                        .background {
                            Image(.buttonBg1)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: ScaleUtility.scaledValue(60))
                                .overlay {
                                    Image(.buttonOverlay1)
                                        .resizable()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: ScaleUtility.scaledValue(60))
                                }
                        }
                    }
                }
            
                
            }
            
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
