//
//  Cosmetics.swift
//  MentalLog
//
//  Created by Cameron Bardell on 2019-12-21.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//


import Foundation
import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
    
    // Palette 1
    static let primaryColor = Color(UIColor(red: 0.65, green: 1.00, blue: 0.97, alpha: 1.00))
    static let tertiaryColor = Color(UIColor(red: 0.59, green: 0.85, blue: 0.76, alpha: 1.00))
    static let secondaryColor = Color(UIColor(red: 0.30, green: 0.49, blue: 0.66, alpha: 1.00))
    static let fourthColor = Color(UIColor(red: 0.15, green: 0.16, blue: 0.20, alpha: 1.00))
    
}

// Dismiss keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

