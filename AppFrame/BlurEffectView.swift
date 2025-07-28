//
//  BlurEffectView.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/15/24.
//

import Foundation
import UIKit

class BlurEffectView: UIView {
    
    private let blurEffectView: UIVisualEffectView
    
    override init(frame: CGRect) {
        // Create a blur effect with light style (you can change the style as needed)
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(frame: frame)
        
        setupBlurEffect()
    }
    
    required init?(coder: NSCoder) {
        // Create a blur effect with light style
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(coder: coder)
        
        setupBlurEffect()
    }
    
    private func setupBlurEffect() {
        // Add the blur effect view to the current view
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
    }
    
    // This method allows you to adjust the blur intensity dynamically
    func setBlurIntensity(_ intensity: CGFloat) {
        guard let blurEffect = blurEffectView.effect as? UIBlurEffect else { return }
        
        // Modify the blur radius if needed
        let blurRadius = intensity * 10 // Scale the intensity as needed
        let newBlurEffect = UIBlurEffect(style: .regular)
        blurEffectView.effect = newBlurEffect
    }
}
