//
//  Extension.swift
//  TigerLink Gateway
//
//  Created by jin fu on 2024/12/19.
//

import UIKit

// MARK: - Helper Extension for Rotation
extension CGAffineTransform {
    var rotationAngle: CGFloat {
        return atan2(b, a)
    }
}
