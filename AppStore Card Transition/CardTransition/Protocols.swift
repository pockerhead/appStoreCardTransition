//
//  Protocols.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import Foundation
import UIKit

protocol StatusBarHiddenViewController {}

@objc protocol CardViewContainable: class {
    @objc var cardDestinationView: UIView! { get }
}


