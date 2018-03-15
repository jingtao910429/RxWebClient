//
//  Observable+ObjectMapper.swift
//  RxSwift_Alamofire_ObjectMapper
//
//  Created by Mac on 2017/6/20.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Result
import SwiftyJSON

let KResultCode = "code"
let KErrorMsg = "message"

struct networkErrorType {
    static let requestFail = (1004, "请检查网络")
    static let praseError  = (1005, "数据解析异常")
}

extension Response {
    
    public func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }

    public func mapArray<T: BaseMappable>(_ type: T.Type) throws -> [T] {
        let json = try JSONSerialization.jsonObject(with: self.data, options: [])
        guard let array = json as? [[String: Any]], let objects = Mapper<T>().mapArray(JSONArray: array) else {
            throw MoyaError.jsonMapping(self)
        }
        return objects
    }
    
    public func mapExceptionObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
}

extension ObservableType where E == Response {

    public func mapObject<T: BaseMappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            
            do {
                
                let object = try response.mapObject(T.self)

                // check http status
                guard ((200...299) ~= response.statusCode) else {
                     return Observable.error(ErrorFactory.createError(code: networkErrorType.requestFail.0, errorMessage: networkErrorType.requestFail.1))
                }
                
                let json = JSON.init(data: response.data)
                if let code = json[KResultCode].int {
                    let errorMsg = json[KErrorMsg].string
                    if code == 200 {
                        return Observable.just(object)
                    }
                    return Observable.error(ErrorFactory.createError(code: code, errorMessage: errorMsg ?? networkErrorType.praseError.1))
                } else {
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.praseError.0, errorMessage: networkErrorType.praseError.1))
                }
            } catch {
                
                switch error {
                case MoyaError.jsonMapping(_):
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.praseError.0, errorMessage: networkErrorType.praseError.1))
                default:
                    break
                }
                return Observable.error(MoyaError.jsonMapping(response))
            }
        }
    }

    public func mapArray<T: BaseMappable>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            do {
                let object = try response.mapArray(T.self)

                // check http status
                guard ((200...299) ~= response.statusCode) else {
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.requestFail.0, errorMessage: networkErrorType.requestFail.1))
                }

                let json = JSON.init(data: response.data)
                if let code = json[KResultCode].int {
                    let errorMsg = json[KErrorMsg].string
                    if code == 0 {
                        return Observable.just(object)
                    }
                    return Observable.error(ErrorFactory.createError(code: code, errorMessage: errorMsg ?? networkErrorType.praseError.1))
                } else {
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.praseError.0, errorMessage: networkErrorType.praseError.1))
                }
            } catch {
                
                switch error {
                case MoyaError.jsonMapping(_):
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.praseError.0, errorMessage: networkErrorType.praseError.1))
                default:
                    break
                }
                return Observable.error(MoyaError.jsonMapping(response))
            }
        }
    }
    
    public func mapNoVerifyObject<T: BaseMappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            
            do {
                
                let object = try response.mapObject(T.self)
                
                return Observable.just(object)
                
            } catch {
                
                switch error {
                case MoyaError.jsonMapping(_):
                    return Observable.error(ErrorFactory.createError(code: networkErrorType.praseError.0, errorMessage: networkErrorType.praseError.1))
                default:
                    break
                }
                return Observable.error(MoyaError.jsonMapping(response))
            }
        }
    }

}

class ErrorFactory {
    class func createError(code: Int = 0, errorMessage message: String = "未知错误") -> Swift.Error {
        return NSError(domain: message, code: code, userInfo: nil) as Swift.Error
    }
}

