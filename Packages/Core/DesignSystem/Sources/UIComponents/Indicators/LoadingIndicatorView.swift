//
//  LoadingIndicatorView.swift
//  DesignSystem
//
//  Created by Iacob Zanoci on 28.06.2025.
//

import DesignSystem
import UIKit

public final class LoadingIndicatorView: UIActivityIndicatorView {

    public init(
        style: UIActivityIndicatorView.Style = .medium,
        color: UIColor = .Piczy.secondaryText ?? .gray
    ) {
        super.init(style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.hidesWhenStopped = true
        self.color = color
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
