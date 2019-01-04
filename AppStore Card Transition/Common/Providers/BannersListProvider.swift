//
//  MainProvider.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import Foundation
import CollectionKit

class BannersListProvider: BasicProvider<AppstoreBanner?, BannerCell> {
    init(_ dataSource: ArrayDataSource<AppstoreBanner?>, tapHandler: ((BasicProvider<AppstoreBanner?, BannerCell>.TapContext)->(Void))?, viewHandler: ((UIView) -> Void)? = nil, isBannersList: Bool) {
        let sourceSize = {(index: Int, data: AppstoreBanner?, maxSize: CGSize) -> CGSize in
            return CGSize(width: maxSize.width, height: CGFloat(300))
        }
        let sourceView = ClosureViewSource(viewUpdater: {(view: BannerCell, promotion: AppstoreBanner?, index: Int) in
            view.configure(with: promotion?.image ?? UIImage(), needTransformOnTouch: isBannersList)
            view.layer.cornerRadius = isBannersList ? 16 : 0
            view.clipsToBounds = false
            if isBannersList {
                view.applyStandardShadow()
            }
            viewHandler?(view)
        })
        let layout: Layout!
        if isBannersList {
            layout = FlowLayout(spacing: 16).inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        } else {
            layout = FlowLayout()
        }
        super.init(
            dataSource: dataSource,
            viewSource: sourceView,
            sizeSource: sourceSize,
            layout: layout,
            tapHandler: tapHandler
        )
    }
}
