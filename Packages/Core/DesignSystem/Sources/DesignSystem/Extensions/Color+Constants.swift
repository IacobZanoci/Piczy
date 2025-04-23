//
//  Color+Constants.swift
//  DesignSystem
//
//  Created by Iacob Zanoci on 23.04.2025.
//

import UIKit

public extension UIColor {
    
    /// The color scheme used in the Piczy app.
    enum Piczy {
        
        /// The main background color of the application.
        public static let background = UIColor(
            named: "backgroundColor",
            in: .module,
            compatibleWith: .none
        )
        
        /// The color used to contrast the background color.
        public static let contrast = UIColor(
            named: "contrastColor",
            in: .module,
            compatibleWith: .none
        )
        
        /// The color used for primary text elements.
        public static let primaryText = UIColor(
            named: "primaryTextColor",
            in: .module,
            compatibleWith: .none
        )
        
        /// The color used for secondary text elements.
        public static let secondaryText = UIColor(
            named: "secondaryTextColor",
            in: .module,
            compatibleWith: .none
        )
        
        /// The color used for disabled/placeholder elements.
        public static let disabledText = UIColor(
            named: "disabledTextColor",
            in: .module,
            compatibleWith: .none
        )
        
        /// The primary button background color.
        public static let primaryButton = UIColor(
            named: "primaryButtonColor",
            in: .module,
            compatibleWith: .none
        )
        
        /// The color used for error state representation.
        public static let error = UIColor(
            named: "errorColor",
            in: .module,
            compatibleWith: .none
        )
    }
}
