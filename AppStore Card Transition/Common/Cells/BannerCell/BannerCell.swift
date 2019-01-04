//
//  BannerCell.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit

class BannerCell: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var image: UIImageView!
    
    //MARK: - Properties
    var needTransformOnTouch: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    func configure(with image: UIImage, needTransformOnTouch: Bool = true) {
        self.image.image = image
        self.needTransformOnTouch = needTransformOnTouch
        if needTransformOnTouch {
            self.subviews.first?.clipsToBounds = true
            self.subviews.first?.layer.cornerRadius = 16
        }
    }
}

extension BannerCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard needTransformOnTouch else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.transform = .init(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard needTransformOnTouch else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard needTransformOnTouch else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
}
