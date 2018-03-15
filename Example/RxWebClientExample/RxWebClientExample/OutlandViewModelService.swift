//
//  OutlandViewModelService.swift
//  rabbitDoctor
//
//  Created by qianqichao on 2018/1/23.
//  Copyright © 2018年 rabbitDoctor. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

struct CommonModel: APIModelConvertible ,NonnilMappable {
    typealias StructType = CommonModel
    
    var resultCode: Int = 0
    var errMsg: String = ""
    var success: String = ""
    var city: String = ""
    var errCode: String = ""
    
    init?(map: Map) {
        if shouldReturnNil(map) {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        resultCode <- map["resultCode"]
        errMsg <- map["errMsg"]
        success <- map["success"]
        city <- map["city"]
        errCode <- map["errCode"]
        errMsg <- map["errDesc"]
    }
    
    var nonnilMapProperties: [String] {
        return []
    }
    
}

class OutlandViewModelService: NSObject {
    func overseasHome(cityId: Int, lng: Double, lat: Double, geoSystem: String) -> Observable<CommonModel> {
        return outlandAPIService.request(OutlandAPIService.overseasHome(cityId: cityId, lng: lng, lat: lat, geoSystem: geoSystem))
            .mapObject(CommonModel.self)
    }
}

