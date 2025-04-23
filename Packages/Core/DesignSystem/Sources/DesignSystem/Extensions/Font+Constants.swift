//
//  Font+Constants.swift
//  DesignSystem
//
//  Created by Iacob Zanoci on 23.04.2025.
//

import UIKit

public extension UIFont {
    
    /// The font styles used in the Piczy app.
    enum Piczy {
        
        /// Font used for title elements.
        ///
        /// Equivalent to the system font with a `32.0` size.
        public static let title = UIFont.systemFont(ofSize: 32.0)
        
        /// Bold font used for title elements.
        ///
        /// Equivalent to the system font with a `32.0` size, with a `bold` weight.
        public static let titleBold = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        
        /// Font used for body elements.
        ///
        /// Equivalent to the system font with a `16.0` size.
        public static let body = UIFont.systemFont(ofSize: 16.0)
        
        /// Bold font used for body elements.
        ///
        /// Equivalent to the system font with a `16.0` size, with a `bold` weight.
        public static let bodyBold = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        
        /// Font used for caption elements.
        ///
        /// Equivalent to the system font with a `12.0` size.
        public static let caption = UIFont.systemFont(ofSize: 12.0)
        
        /// Bold font used for caption elements.
        ///
        /// Equivalent to the system font with a `12.0` size, with a `bold` weight.
        public static let captionBold = UIFont.systemFont(ofSize: 12.0, weight: .bold)
    }
}
