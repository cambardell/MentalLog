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
    static let primaryColor = Color(UIColor(red: 0.10, green: 0.84, blue: 0.83, alpha: 1.00))
    static let secondaryColor = Color(UIColor(red: 0.53, green: 0.13, blue: 1.00, alpha: 1.00))
    
}

// Dismiss keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
