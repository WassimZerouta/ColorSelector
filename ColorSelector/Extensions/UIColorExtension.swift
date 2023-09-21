//
//  UIColorExtension.swift
//  ColorSelector
//
//  Created by Wass on 08/09/2023.
//

import Foundation
import UIKit

extension UIColor {
    
    var stringRepresentation: String {
        let components = self.cgColor.components
        return "R: \(roundedthreeDecimalsComponent(for: components?[0] ?? 0.0)), G: \(roundedthreeDecimalsComponent(for: components?[1] ?? 0.0)), B: \(roundedthreeDecimalsComponent(for: components?[2] ?? 0.0))"
    }
    
    private func roundedthreeDecimalsComponent(for components: CGFloat) -> CGFloat {
        return Double(round(1000 * components) / 1000)
    }
    
    
    var luminance: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        return luminance
    }
    
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
}

