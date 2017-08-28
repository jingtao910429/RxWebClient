
//
//  Observable+ShowLoading.swift
//  rabbitDoctor
//
//  Created by 2Boss on 2017/8/2.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension Observable {
    
    //加载视图
    func showLoading(activity: UIView, disposeBag: DisposeBag) -> Observable {
        
        let indicator = ActivityIndicator()
        indicator.asObservable()
            .bindTo(activity.rx_imageView_animating)
            .addDisposableTo(disposeBag)
        
        return self.trackActivity(indicator)
    }
    
}

extension UIView {
    
    public var rx_imageView_animating: AnyObserver<Bool> {
        return AnyObserver { event in
            
            MainScheduler.ensureExecutingOnScheduler()
            
            switch (event) {
            case .next(let value):
                
                guard value else {
                    self.removeLoadingView()
                    return
                }
                
                if  let _ = UIViewController.currentViewController()?.view {
                    let showLoadingView = LoadViewManager.sharedInstance.loadingView
                    LoadViewManager.sharedInstance.addTo(view: self)
                    self.bringSubview(toFront: showLoadingView)
                }
                
            case .error(let error):
                print("Binding error to UI: \(error)")
                self.removeLoadingView()
            case .completed:
                self.removeLoadingView()
            }
        }
    }
    
}

