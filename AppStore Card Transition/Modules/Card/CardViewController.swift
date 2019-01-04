//
//  CardViewController.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import UIKit
import CollectionKit

class CardViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var dismissButton: UIButton!
    //MARK: - Properties
    var collectionView = CollectionView()
    var banner: AppstoreBanner!
    var destView: UIView?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    public func configure(with banner: AppstoreBanner) {
        self.banner = banner
    }

}

//MARK: - Actions
extension CardViewController {
    @IBAction func dismissButtonDidSelect(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - CardViewContainable
extension CardViewController {
    override var cardDestinationView: UIView! {
        return destView ?? UIView()
    }
}

//MARK: - UI Configuration
extension CardViewController {
    private func configureUI() {
        view.insertSubview(collectionView, belowSubview: dismissButton)
        collectionView.fillSuperview()
        collectionView.contentInsetAdjustmentBehavior = .never
        let viewHandler: ((UIView) -> Void)? = {[weak self] view in
            guard let `self` = self else { return }
            self.destView = view
        }
        let bannerProvider = BannersListProvider(ArrayDataSource<AppstoreBanner?>(data: [self.banner]), tapHandler: nil, viewHandler: viewHandler, isBannersList: false)
        let textProvider = TextViewProvider(ArrayDataSource<String>(data: [self.banner.text!]))
        collectionView.provider = ComposedProvider(identifier: "1", layout: FlowLayout(), sections: [bannerProvider, textProvider])
        collectionView.delegate = self
        destView = bannerProvider.view(at: 0)
    }
}

extension CardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(destView?.frameToWindow())
    }
}
