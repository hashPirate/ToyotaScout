//
//  WaveformView.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/31/24.
//

import UIKit

class AudioVisualizerView: UIView {
    
    enum ComponentValue {
        static let numOfColumns = 20
    }
    
    var columnWidth: CGFloat?
    var columns: [CAShapeLayer] = []
    var amplitudesHistory: [CGFloat] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        drawVisualizerCircles() // Ensure circles are drawn when the view awakens
    }
    
    func drawVisualizerCircles() {
        self.amplitudesHistory = Array(repeating: 0, count: ComponentValue.numOfColumns)
        
        let diameter = self.bounds.width / CGFloat(2 * ComponentValue.numOfColumns + 1)
        self.columnWidth = diameter
        
        let startingPointY = self.bounds.midY - diameter / 2
        var startingPointX = self.bounds.minX + diameter
        
        // Clear any existing columns before redrawing
        removeVisualizerCircles()

        for i in 0..<ComponentValue.numOfColumns {
            let circleLayer = createCircleLayer(startingPointX: startingPointX, startingPointY: startingPointY, diameter: diameter)
            
            // Add subtle shadow for aesthetics
            circleLayer.shadowColor = UIColor.black.cgColor
            circleLayer.shadowOffset = CGSize(width: 1, height: 2)
            circleLayer.shadowOpacity = 0.1
            circleLayer.shadowRadius = 3
            
            self.layer.addSublayer(circleLayer)
            self.columns.append(circleLayer)
            
            // Circle Diameter + Padding
            startingPointX += 2 * diameter
        }
    }
    
    private func createCircleLayer(startingPointX: CGFloat, startingPointY: CGFloat, diameter: CGFloat) -> CAShapeLayer {
        let circleOrigin = CGPoint(x: startingPointX, y: startingPointY)
        let circleSize = CGSize(width: diameter, height: diameter)
        
        let circle = UIBezierPath(roundedRect: CGRect(origin: circleOrigin, size: circleSize), cornerRadius: diameter / 2)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circle.cgPath
        circleLayer.fillColor = UIColor.white.cgColor // Initial color
        return circleLayer
    }
    
    func removeVisualizerCircles() {
        // Remove all existing circle layers
        for column in self.columns {
            column.removeFromSuperlayer()
        }
        self.columns.removeAll()
    }
    
    private func computeNewPath(for layer: CAShapeLayer, with amplitude: CGFloat) -> CGPath {
        let width = self.columnWidth ?? 8.0
        let maxHeightGain = self.bounds.height - 3 * width
        let heightGain = maxHeightGain * amplitude
        var newHeight = width + heightGain * 10.0
        newHeight = min(self.frame.height, newHeight)
        let newOrigin = CGPoint(x: layer.path?.boundingBox.origin.x ?? 0,
                                y: (layer.superlayer?.bounds.midY ?? 0) - (newHeight / 2))
        let newSize = CGSize(width: width, height: newHeight)
        return UIBezierPath(roundedRect: CGRect(origin: newOrigin, size: newSize), cornerRadius: width / 2).cgPath
    }
    func resetVisualizerBars() {
        guard self.columns.count == ComponentValue.numOfColumns else { return }
        
        // Animate the reset of each bar
        for (i, layer) in self.columns.enumerated() {
            let resetPath = computeNewPath(for: layer, with: 0) // Reset height to 0
            
            // Create a staggered animation effect
            let delay = 0.02 * CGFloat(i) // Stagger each bar's reset
            let duration = 0.2 // Increase duration for smoother animation
            
            // Animate the path change with a spring effect
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
            
            // Apply the delay
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                layer.path = resetPath
                
                // Optionally reset color for visual feedback
                layer.fillColor = UIColor.white.cgColor // Set to original color or any color you prefer
            }
            
            CATransaction.commit()
        }
    }
    fileprivate func updateVisualizerView(with amplitude: CGFloat) {
        guard self.columns.count == ComponentValue.numOfColumns else { return }
        
        // Add a new value, remove the oldest, and apply damping
        self.amplitudesHistory.append(amplitude * 0.8 + (self.amplitudesHistory.last ?? 0) * 0.2)
        self.amplitudesHistory.removeFirst()
        
        for (i, layer) in self.columns.enumerated() {
            let newPath = computeNewPath(for: layer, with: self.amplitudesHistory[i])
            
            // Animate the path change
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.2)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
            layer.path = newPath
            CATransaction.commit()
            
            // Update color for dynamic effect (e.g., pulsing)
            let colorValue = CGFloat(0.5 + amplitudesHistory[i] * 0.5) // Varies between 0.5 and 1.0
            //layer.fillColor = UIColor(hue: 0.6, saturation: 0.8, brightness: colorValue, alpha: 1.0).cgColor
        }
    }
}

// MARK: AudioMeteringDelegate
extension AudioVisualizerView: AudioMeteringDelegate {
    func audioMeter(didUpdateAmplitude amplitude: Float) {
        self.updateVisualizerView(with: CGFloat(amplitude))
    }
}
