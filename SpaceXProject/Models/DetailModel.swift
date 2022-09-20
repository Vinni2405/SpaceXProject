//
//  DetailModel.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import Foundation

class Detail {
    
    var title: String
    var content = String()
    var isExpanded = false
    var tier: Int
    lazy var children = [Detail]()
    
    private var rawContent: Any
    
    init(title: String, rawContent: Any, tier: Int = 1) {
        self.title = title
        self.rawContent = rawContent
        self.tier = tier
        self.content = setContent(rawContent)
    }
    
    func setContent(_ value: Any) -> String {
        
        var stringValue = "N/A"
        
        switch value {
            
        case nil:
            return stringValue
            
        case _ as Int?:
            if let value = value as? Int {
                stringValue = "\(value)"
            }
            
        case _ as Double?:
            if let value = value as? Double {
                stringValue = "\(value)"
            }
            
        case _ as String?:
            if let value = value as? String {
                stringValue = "\(value)"
            }
            
        case _ as Bool?:
            if let value = value as? Bool {
                stringValue = "\(value)"
            }
        
        case let values as Array<Any>?:
            
            if let values = values {
                for (index, value) in values.enumerated() {
                    children.append(Detail(title: "\(index+1)",
                                           rawContent: value,
                                           tier: tier + 1))
                }
                if !values.isEmpty {
                    stringValue = ""
                }
            }
            
        case let values as Dictionary<String,Any>?:
            if let values = values {
                let keys = values.keys.compactMap({ $0 }).sorted()
                for key in keys {
                    children.append(Detail(title: key.formatAsTitle(),
                                           rawContent: values[key] as Any,
                                           tier: tier + 1))
                }
                if !values.isEmpty {
                    stringValue = ""
                }
            }
            
        case let value as PropertyLoopable:
            
            do {
                let children = try value.allProperties()
                let keys = children.keys.compactMap({ $0 }).sorted()
                for key in keys {
                    self.children.append(Detail(title: key.formatAsTitle(),
                                                rawContent: children[key] as Any,
                                                tier: tier + 1))
                }
            }
            catch {
                print(error)
            }
            stringValue = ""
            
        default:
            stringValue = ""
        }
        
        return stringValue
        
    }
}
