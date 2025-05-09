//
//  CoordinatorProtocol.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import UIKit

@MainActor
public protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    
    func start()
}
