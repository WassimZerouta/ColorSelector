//
//  CrossView.swift
//  ColorSelector
//
//  Created by Wassim on 01/03/2024.
//

import Foundation
import UIKit

class CrossView: UIView {
    
    let crossSize: CGFloat = 20
    let lineWidth: CGFloat = 2
    
    private let crossLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCrossView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCrossView()
    }
    
    private func setupCrossView() {
        let crossPath = UIBezierPath()
        crossPath.lineWidth = lineWidth
        crossPath.move(to: CGPoint(x: crossSize / 2, y: 0))
        crossPath.addLine(to: CGPoint(x: crossSize / 2, y: crossSize))
        crossPath.move(to: CGPoint(x: 0, y: crossSize / 2))
        crossPath.addLine(to: CGPoint(x: crossSize, y: crossSize / 2))
        
        crossLayer.path = crossPath.cgPath
        crossLayer.strokeColor = UIColor.white.cgColor
        crossLayer.lineWidth = lineWidth
        
        layer.addSublayer(crossLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

