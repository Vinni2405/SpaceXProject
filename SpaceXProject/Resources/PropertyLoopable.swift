//
//  PropertyLoopable.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import Foundation

protocol PropertyLoopable {
    func allProperties() throws -> [String : Any]
}

extension PropertyLoopable {
    
    /// Returns dictionary [String:Any] of all properties in a class or struct.
    func allProperties() throws -> [String : Any] {
        var result = [String : Any]()
        
        let mirror = Mirror(reflecting: self)
        
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw "something unwanted happened"
        }
        
        for (label, value) in mirror.children {
            guard let label = label else {
                continue
            }
            result[label] = value
        }
        return result
    }
}
