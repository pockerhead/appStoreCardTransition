//
//  ViewController.swift
//  AppStore Card Transition
//
//  Created by Артём Балашов on 04/01/2019.
//  Copyright © 2019 Артём Балашов. All rights reserved.
//

import UIKit
import CollectionKit

class MainViewController: UIViewController {
    //MARK: - Properties
    var collectionView = CollectionView()
    var dataSource = ArrayDataSource<AppstoreBanner?>()
    
    lazy var bannerData: [AppstoreBanner] = {
        return (0...3).map{ AppstoreBanner(UIImage(named: "image\($0)"))  }
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
}

//MARK: - UI Configuration
extension MainViewController {
    private func configureUI() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.delaysContentTouches = false
        let tapHandler: (BasicProvider<AppstoreBanner?, BannerCell>.TapContext)->(Void) = { [weak self] (context) in
            guard let `self` = self, let banner = context.data else { return }
            self.open(banner, with: context.view)
        }
        collectionView.provider = BannersListProvider(dataSource, tapHandler: tapHandler, isBannersList: true)
        dataSource.data = bannerData
    }
}

//MARK: - Navigation
extension MainViewController {
    func open(_ banner: AppstoreBanner, with view: UIView) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardViewController") as! CardViewController
        vc.configure(with: banner)
        let data = CardViewPresentationData(view: view, rect: view.frameToWindow(withoutTransform: false), radius: view.layer.cornerRadius)
        self.presentAsCard(vc, with: data, animated: true, completion: nil)
        
    }
}
