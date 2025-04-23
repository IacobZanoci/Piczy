//
//  PrimaryButton.swift
//  DesignSystem
//
//  Created by Iacob Zanoci on 23.04.2025.
//

import DesignSystem
import UIKit

public class PrimaryButton: UIButton {
    
    public override var isEnabled: Bool {
        didSet {
            updateTitleColor()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor = .Piczy.primaryButton
        setTitleColor(.Piczy.primaryText, for: .normal)
        titleLabel?.font = .Piczy.bodyBold
        layer.cornerRadius = .small
        invalidateIntrinsicContentSize()
    }
    
    private func updateTitleColor() {
        if isEnabled {
            setTitleColor(UIColor.Piczy.primaryText, for: .normal)
        } else {
            setTitleColor(UIColor.Piczy.disabledText, for: .normal)
        }
    }
}
