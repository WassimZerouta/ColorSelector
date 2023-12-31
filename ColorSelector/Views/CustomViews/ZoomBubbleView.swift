//
//  ZoomBubbleView.swift
//  ColorSelector
//
//  Created by Wass on 13/09/2023.
//

import Foundation
import UIKit


class ZoomBubbleView: UIView {
    
    private let imageView = UIImageView()
    private let crossView = UIView()
    private let gridLayer = CAShapeLayer()
    
    init(frame: CGRect, image: UIImage?) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
        
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        let crossSize: CGFloat = 20
        crossView.frame = CGRect(x: (frame.width - crossSize) / 2, y: (frame.height - crossSize) / 2, width: crossSize, height: crossSize)
        crossView.backgroundColor = .clear
        addSubview(crossView)
        
        let lineWidth: CGFloat = 2
        let crossPath = UIBezierPath()
        crossPath.lineWidth = lineWidth
        crossPath.move(to: CGPoint(x: crossSize / 2, y: 0))
        crossPath.addLine(to: CGPoint(x: crossSize / 2, y: crossSize))
        crossPath.move(to: CGPoint(x: 0, y: crossSize / 2))
        crossPath.addLine(to: CGPoint(x: crossSize, y: crossSize / 2))
        
        let crossLayer = CAShapeLayer()
        crossLayer.path = crossPath.cgPath
        crossLayer.strokeColor = UIColor.white.cgColor
        crossLayer.lineWidth = lineWidth
        crossView.layer.addSublayer(crossLayer)
        
        let gridSize: CGFloat = 25
        let gridPath = UIBezierPath()
        gridPath.lineWidth = 1
        for x in stride(from: 0, to: frame.width, by: gridSize) {
            gridPath.move(to: CGPoint(x: x, y: 0))
            gridPath.addLine(to: CGPoint(x: x, y: frame.height))
        }
        for y in stride(from: 0, to: frame.height, by: gridSize) {
            gridPath.move(to: CGPoint(x: 0, y: y))
            gridPath.addLine(to: CGPoint(x: frame.width, y: y))
        }
        
        gridLayer.path = gridPath.cgPath
        gridLayer.strokeColor = UIColor.lightGray.cgColor
        gridLayer.lineWidth = 1
        layer.addSublayer(gridLayer)
        
        updateImage(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func colorPicker(image: UIImage, label: UILabel, colorDisplayer: UIView, hexColor: String?, saveButton: UIImageView) -> String {
        imageView.image = image
        let centerInSuperview = convert(crossView.center, to: imageView)
        
        let color = image.getPixelColorAtPoint(point: centerInSuperview, sourceView: imageView)
        let hexColor = image.getHexaValue(point: centerInSuperview, sourceView: imageView)

        let luminance = color.luminance
        label.textColor = luminance < 0.5 ? .white : .black
        saveButton.tintColor = luminance < 0.5 ? .white : .black
        
        colorDisplayer.backgroundColor = color
        
        return hexColor
    }
    
    func updateImage(image: UIImage?) {
        imageView.image = image
    }
}
