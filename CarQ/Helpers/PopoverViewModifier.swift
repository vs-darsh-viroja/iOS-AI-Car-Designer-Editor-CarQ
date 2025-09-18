//
//  PopoverViewModifier.swift
//  CarQ
//
//  Created by Purvi Sancheti on 18/09/25.
//


import Foundation
import SwiftUI

// Popover Modifier
struct PopoverViewModifier<PopoverContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var popoverSize: CGSize?
    let popoverContent: () -> PopoverContent
    var popoverOffsetX: CGFloat
    var popoverIpadOffsetX: CGFloat
    var popoverOffsetY: CGFloat
    var popoverIpadOffsetY: CGFloat
    init(
        isPresented: Binding<Bool>,
        popoverSize: CGSize? = CGSize(width: 98, height: 294),
        popoverContent: @escaping () -> PopoverContent,
        popoverOffsetX: CGFloat,
        popoverIpadOffsetX: CGFloat,
        popoverOffsetY: CGFloat,
        popoverIpadOffsetY: CGFloat
        
    ) {
        self._isPresented = isPresented
        self.popoverSize = popoverSize
        self.popoverContent = popoverContent
        self.popoverOffsetX = popoverOffsetX
        self.popoverIpadOffsetX = popoverIpadOffsetX
        self.popoverOffsetY = popoverOffsetY
        self.popoverIpadOffsetY = popoverIpadOffsetY
    }

    func body(content: Content) -> some View {
        content
            .background(
                PopoverWrapper(
                    isPresented: $isPresented,
                    popoverSize: popoverSize,
                    popoverContent: popoverContent
                )
                .offset(x: isIPad ? popoverIpadOffsetX : popoverOffsetX, y: isIPad ? popoverIpadOffsetY : popoverOffsetY)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
    }
}



// The Wrapper that will handle the popover logic
struct PopoverWrapper<PopoverContent: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var popoverSize: CGSize?
    let popoverContent: () -> PopoverContent

    func makeUIViewController(context: Context) -> PopoverViewController<PopoverContent> {
        let controller = PopoverViewController(
            popoverSize: popoverSize,
            popoverContent: popoverContent) {
            self.isPresented = false
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: PopoverViewController<PopoverContent>, context: Context) {
        uiViewController.updateSize(popoverSize)
        if isPresented {
            uiViewController.showPopover()
        } else {
            uiViewController.hidePopover()
        }
    }
}

// Add this custom popover background class to remove all rounded corners
import UIKit

class RectangularPopoverBackgroundView: UIPopoverBackgroundView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 0
        clipsToBounds = true
    }
    
    override var arrowOffset: CGFloat {
        get { return 0 }
        set { }
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        get { return .unknown }
        set { }
    }
    
    override class func arrowHeight() -> CGFloat {
        return 0
    }
    
    override class func arrowBase() -> CGFloat {
        return 0
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    // This is the key method - draw a simple rectangle with no rounded corners
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
    }
}

// Updated PopoverViewController with the custom background
class PopoverViewController<PopoverContent: View>: UIViewController, UIPopoverPresentationControllerDelegate {
    var popoverSize: CGSize?
    let popoverContent: () -> PopoverContent
    let onDismiss: () -> Void
    
    var popoverVC: UIViewController?

    init(
        popoverSize: CGSize?,
        popoverContent: @escaping () -> PopoverContent,
        onDismiss: @escaping () -> Void) {
        self.popoverSize = popoverSize
        self.popoverContent = popoverContent
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Keeps popover on iPhone
    }

    func showPopover() {
        guard popoverVC == nil else { return }
        let vc = UIHostingController(rootView: popoverContent())
        if let size = popoverSize { vc.preferredContentSize = size }
        vc.modalPresentationStyle = .popover
        
        // Remove any corner radius from the hosting controller's view
        vc.view.layer.cornerRadius = 0
        vc.view.clipsToBounds = true
        vc.view.backgroundColor = UIColor.clear
        
        if let popover = vc.popoverPresentationController {
            popover.sourceView = view
            popover.delegate = self
            popover.permittedArrowDirections = .any   // allow arrows so custom background is used
            popover.backgroundColor = .clear
            
            // Use our custom rectangular background class
            popover.popoverBackgroundViewClass = RectangularPopoverBackgroundView.self
            
            let rect = CGRect(x: view.bounds.midX - (popoverSize?.width ?? 0) / 2,
                              y: view.bounds.origin.y + 20,
                              width: popoverSize?.width ?? 300,
                              height: popoverSize?.height ?? 200)
            popover.sourceRect = rect
        }
        
        popoverVC = vc
        self.present(vc, animated: true) {
            // 🔑 remove any rounding applied by container superviews
            DispatchQueue.main.async {
                vc.view.superview?.layer.cornerRadius = 0
                vc.view.superview?.superview?.layer.cornerRadius = 0
            }
        }
    }

    func hidePopover() {
        guard let vc = popoverVC, !vc.isBeingDismissed else { return }
        vc.dismiss(animated: true, completion: nil)
        popoverVC = nil
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        popoverVC = nil
        self.onDismiss()
    }

    func updateSize(_ size: CGSize?) {
        self.popoverSize = size
        if let vc = popoverVC, let size = size {
            vc.preferredContentSize = size
        }
    }
}
