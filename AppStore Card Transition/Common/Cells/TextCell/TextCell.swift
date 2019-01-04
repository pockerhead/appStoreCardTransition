//
//  TextCell.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit

class TextCell: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    func configure(with text: String) {
        textView.text = text
        textView.contentInsetAdjustmentBehavior = .never
    }
}
