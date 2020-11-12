//
//  NSObject+LogProperties.swift
//  JWPreview
//
//  Created by Amitai Blickstein on 7/7/19.
//  Copyright © 2019 JWPlayer. All rights reserved.
//

import Foundation
import ObjectiveC

extension NSObject {
    func prettyProperties() -> String { return createPropertiesString() }

    func createPropertiesString() -> String {
        var ret = "----------------------------------------------- Properties for object \(NSStringFromClass(Self.self))\n[\n"

        var numberOfProperties: UInt32 = 0
        let propertyArrayPointer = class_copyPropertyList(Self.self, &numberOfProperties)
        let propertyArray = Array(UnsafeBufferPointer(start: propertyArrayPointer, count: Int(numberOfProperties)))

        for property in propertyArray {
            if let name = String(cString: property_getName(property), encoding: .utf8),
                let value = value(forKey: name)
            {
                ret += "\t\(name): \(value),\n"
            }
        }
        free(propertyArrayPointer)
        ret += "]\n-----------------------------------------------\n"
        return ret
    }

    func logProperties() {
        print(createPropertiesString())
    }
    
    // MARK: class function versions
    // helpful for lldb
    
    static func prettyProperties(of obj: NSObject) -> String {
        return obj.prettyProperties()
    }
    
    static func logProperties(of obj: NSObject) {
        print(obj.createPropertiesString())
    }
}
