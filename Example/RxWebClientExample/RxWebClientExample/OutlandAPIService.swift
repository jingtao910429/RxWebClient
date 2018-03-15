//
//  OutlandAPIService.swift
//  rabbitDoctor
//
//  Created by qianqichao on 2018/1/23.
//  Copyright © 2018年 rabbitDoctor. All rights reserved.
//

import Foundation
import Moya

func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

fileprivate let endpointClosure = { (target: OutlandAPIService) -> Endpoint in
    return Endpoint(url: "", sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: [:])
}

let outlandAPIService = MoyaProvider<OutlandAPIService>(endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

enum OutlandAPIService {
    case overseasHome(cityId: Int, lng: Double, lat: Double, geoSystem: String)
    
    //海外搜索 -- 热门城市/价格数据获取
    case getOverseasHotItem()
    
    //海外搜索 -- 关键字检索
    case overseasFuzzyMatch(cityId: Int, keyword: String)
    
    //海外搜索 -- 条件获取
    case overseasGetComplexCondition(cityId: Int)
    
    //海外搜索 -- 城市获取
    case overseasCityList(cityId: Int, withUnlimitedOps4City: Bool)
    
}

extension OutlandAPIService: TargetType {
    var baseURL: URL { return URL.init(string: "")!}
    
    var headers: [String : String]? {
        return nil
    }
    
    var path: String {
        switch self {
        case .overseasHome(_):
            return "rabbit/v1/overseas/home"
        case .getOverseasHotItem():
            return "rabbit/v1/overseas/hot-item"
        case .overseasFuzzyMatch(_):
            return "rabbit/v1/overseas/fuzzyMatch"
        case .overseasGetComplexCondition(_):
            return "rabbit/v1/config/overseas/getComplexCondition"
        case .overseasCityList(_):
            return "rabbit/v1/overseas/city-list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .overseasHome(_):
            return .get
        case .getOverseasHotItem():
            return .get
        case .overseasFuzzyMatch(_):
            return .get
        case .overseasGetComplexCondition(_):
            return .get
        case .overseasCityList(_):
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .overseasHome(let cityId, let lng, let lat, let geoSystem):
            return [
                "cityId": cityId,
                "lng": lng,
                "lat": lat,
                "geoSystem": geoSystem
            ]
        case .getOverseasHotItem():
            return [:]
        case .overseasFuzzyMatch(let cityId, let keyword):
            return [
                "cityId":cityId,
                "keyword":keyword
            ]
        case .overseasGetComplexCondition(let cityId):
            return [
                "cityId":cityId
            ]
        case .overseasCityList(let cityId, let withUnlimitedOps4City):
            return [
                "cityId":cityId,
                "withUnlimitedOps4City":withUnlimitedOps4City
            ]
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .overseasHome(_):
            return URLEncoding.default
        case .getOverseasHotItem():
            return URLEncoding.default
        case .overseasFuzzyMatch(_):
            return URLEncoding.default
        case .overseasGetComplexCondition(_):
            return URLEncoding.default
        case .overseasCityList(_):
            return URLEncoding.default
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: self.parameters == nil ? [:] : self.parameters!, encoding: self.parameterEncoding)
    }
    
}
