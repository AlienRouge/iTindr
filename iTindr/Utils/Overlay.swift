//
// Created by Vladislav on 30.04.2022.
//

import Foundation
import UIKit

class Overlay {
    static func getOverlay(view: UIView) -> UIView{
        let overlay = UIView(frame: view.frame)
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.8

        return overlay
    }
}
