//
//  Model.swift
//  ibar
//
//  Created by PixelShi on 6/3/16.
//  Copyright © 2016 sharingames. All rights reserved.
//

import UIKit
import ObjectMapper

public protocol Identifiable {
    associatedtype Identifiable: Equatable
    var id: Identifiable { get }
}


extension Collection where Iterator.Element: Identifiable {
    
    func indexOf(_ element: Self.Iterator.Element) -> Self.Index? {
        return self.index { $0.id == element.id }
    }
    
}

private var _instance = [String: Any]()

// 数据模型不可空字段判断组件
public protocol NonnilMappable: Mappable {
    var nonnilMapProperties: [String] { get }
    func shouldReturnNil(_ map: Map) -> Bool
}

extension NonnilMappable {
    func shouldReturnNil(_ map: Map) -> Bool {
        for property in nonnilMapProperties {
            if map[property].currentValue == nil {
                return true
            }
        }
        return false
    }
}

// 数据处理通用组件
public protocol APIModelConvertible {
    static func toModel(_ dic: [String: Any]) -> Self?
}

extension APIModelConvertible where Self: Mappable {
    static func toModel(_ dic: [String: Any]) -> Self? {
        return Mapper<Self>().map(JSON: dic)
    }
}

func jsonObjectToResponseDic(_ obj: Any) -> [String: Any]? {
    return obj as? [String: Any]
}

func jsonObjectToResponseDicArray(_ obj: Any) -> [[String: Any]]? {
    return obj as? [[String: Any]]
}

func jsonObjectToResponseDic<T>(_ obj: T) -> [String: Any]? {
    return obj as? [String: Any]
}

func responseDicToAPIModel<T: APIModelConvertible>(_ dic: [String: Any]) -> T? {
    return T.toModel(dic)
}

func responseDicToAPIModelArray<T: APIModelConvertible>(_ dicArray: [[String: Any]]) -> [T]? {
    var modelArray: [T] = []
    for dic in dicArray {
        modelArray.append(T.toModel(dic)!)
    }
    return modelArray
}
