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
        return "red: \(roundedthreeDecimalsComponent(for: components?[0] ?? 0.0)), green: \(roundedthreeDecimalsComponent(for: components?[1] ?? 0.0)), blue: \(roundedthreeDecimalsComponent(for: components?[2] ?? 0.0)), alpha: \(components?[3] ?? 0.0)"
    }
    
    private func roundedthreeDecimalsComponent(for components: CGFloat) -> CGFloat {
       return Double(round(1000 * components) / 1000)
    }
}

