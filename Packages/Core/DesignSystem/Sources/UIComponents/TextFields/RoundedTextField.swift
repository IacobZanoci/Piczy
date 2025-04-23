//
//  RoundedTextField.swift
//  DesignSystem
//
//  Created by Iacob Zanoci on 23.04.2025.
//

import UIKit

public class RoundedTextField: UITextField {
    
    public var error: String? {
        didSet {
            updateErrorLabel()
        }
    }
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Piczy.error
        label.font = .Piczy.caption
        return label
    }()
    
    private var bottomBorder: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.Piczy.primaryText?.cgColor
        return layer
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        addBottomLine()
        addErrorLabel()
        setPlaceholderFont()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.bounds
        frame.origin.y = frame.size.height
        frame.size.height = 1
        bottomBorder.frame = frame
        errorLabel.frame = CGRect(x: 0, y: .extraLarge, width: frame.width, height: .medium)
    }
    
    private func addBottomLine() {
        layer.addSublayer(bottomBorder)
    }
    
    private func addErrorLabel() {
        self.addSubview(errorLabel)
    }
    
    private func setPlaceholderFont() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.Piczy.body
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
    }
    
    private func updateErrorLabel() {
        if error != nil {
            errorLabel.text = error
            errorLabel.isHidden = false
            textColor = UIColor.Piczy.error
        } else {
            errorLabel.text = nil
            errorLabel.isHidden = true
            textColor = UIColor.Piczy.primaryText
        }
    }
}
