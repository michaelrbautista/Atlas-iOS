//
//  Design.swift
//  stayhard
//
//  Created by Michael Bautista on 3/16/24.
//

import UIKit
import SwiftUI

extension Color {
    struct ColorSystem {
        static var primaryText: Color { return Color(red: 1.00, green: 1.00, blue: 1.00) }
        static var systemGray: Color { return Color(red: 0.56, green: 0.56, blue: 0.58) }
        static var systemGray2: Color { return Color(red: 0.38, green: 0.38, blue: 0.4) }
        static var systemGray3: Color { return Color(red: 0.28, green: 0.28, blue: 0.29) }
        static var systemGray4: Color { return Color(red: 0.23, green: 0.23, blue: 0.26) }
        static var systemGray5: Color { return Color(red: 0.17, green: 0.17, blue: 0.18) }
        static var systemGray6: Color { return Color(red: 0.11, green: 0.11, blue: 0.12) }
        static var systemBackground: Color { return Color(red: 0, green: 0, blue: 0) }
        static var systemBlue: Color { return Color(red: 0.04, green: 0.52, blue: 1.00) }
        static var systemRed: Color { return Color(red: 1.00, green: 0.27, blue: 0.23) }
        static var systemGreen: Color { return Color(red: 0.20, green: 0.78, blue: 0.35) }
    }
}

extension Font {
    struct FontStyles {
        static var largeTitle: Font { return Font.system(size: 34, weight: .bold, design: .default) }
        static var title1: Font { return Font.system(size: 28, weight: .bold, design: .default) }
        static var title2: Font { return Font.system(size: 22, weight: .bold, design: .default) }
        static var title3: Font { return Font.system(size: 20, weight: .bold, design: .default) }
        static var headline: Font { return Font.system(size: 17, weight: .semibold, design: .default) }
        static var body: Font { return Font.system(size: 17, weight: .regular, design: .default) }
        static var callout: Font { return Font.system(size: 16, weight: .regular, design: .default) }
        static var subhead: Font { return Font.system(size: 15, weight: .bold, design: .default) }
        static var footnote: Font { return Font.system(size: 13, weight: .bold, design: .default) }
        static var caption1: Font { return Font.system(size: 12, weight: .bold, design: .default) }
        static var caption2: Font { return Font.system(size: 11, weight: .bold, design: .default) }
    }
}
