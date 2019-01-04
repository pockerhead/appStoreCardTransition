//
//  TextViewProvider.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import Foundation
import CollectionKit

class TextViewProvider: BasicProvider<String, TextCell> {
    init(_ dataSource: ArrayDataSource<String>, tapHandler: ((BasicProvider<String, TextCell>.TapContext)->(Void))? = nil) {
        let sourceSize = {(index: Int, data: String, maxSize: CGSize) -> CGSize in
            return CGSize(width: maxSize.width, height: maxSize.height)
        }
        let sourceView = ClosureViewSource(viewUpdater: {(view: TextCell, text: String, index: Int) in
            view.configure(with: text)
        })
        super.init(
            dataSource: dataSource,
            viewSource: sourceView,
            sizeSource: sourceSize,
            layout: FlowLayout(),
            tapHandler: tapHandler
        )
    }
}
