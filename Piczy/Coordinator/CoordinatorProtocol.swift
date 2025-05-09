//
//  CoordinatorProtocol.swift
//  Piczy
//
//  Created by Iacob Zanoci on 09.05.2025.
//

import Foundation
import UIKit

@MainActor
public protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    
    func start()
}
