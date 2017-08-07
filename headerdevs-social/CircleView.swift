//
//  CircleView.swift
//  headerdevs-social
//
//  Created by kritawit bunket on 8/2/2560 BE.
//  Copyright © 2560 Headerdevs. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
//        clipsToBounds = true
    }
}
