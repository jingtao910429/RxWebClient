//
//  RxMoyaProvider+OfflineCache.swift
//  rabbitDoctor
//
//  Created by 2Boss on 2017/8/1.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Result

extension RxMoyaProvider {
    func tryUseOfflineCacheThenRequest(_ token: Target, _ cacheType: CacheType) -> Observable<Moya.Response> {
        return Observable.create { [weak self] observer -> Disposable in
            
            let key = token.path
            
            var cancelableToken: Cancellable?
            
            // 先读取缓存内容，有则发出一个信号（onNext），没有则跳过
            // 后期缓存可以区分文件、数据库、内存
            /*
            CacheManager.sharedInstance.readCacheAsync(key, cacheType, { (object) in
                
                if object != nil {
                    
                    do {
                        let prettyData =  try JSONSerialization.data(withJSONObject: object!, options: .prettyPrinted)
                        observer.onNext(Response(statusCode: 200, data: prettyData))
                        
                    } catch {
                        
                    }
                    
                }
                
                cancelableToken = self?.request(token) { result in
                    
                    switch result {
                    case let .success(response):
                        observer.onNext(response)
                        observer.onCompleted()
                    case let .failure(error):
                        observer.onError(error)
                    }
                }
            })
            */
            return Disposables.create {
                cancelableToken?.cancel()
            }
            
        }
    }
}
