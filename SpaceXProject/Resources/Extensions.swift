//
//  Extensions.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import Foundation

extension String {
    
    /// Converts string from camel case to spaced words with uppercased first letters.
    /// - Example: thisIsATitle ---> This Is A Title
    func formatAsTitle() -> String {
        var newString = ""
        
        let uppercase = CharacterSet.uppercaseLetters
        let first = String(self.unicodeScalars.first!).uppercased()
        newString.append(first)
        for scalar in self.unicodeScalars.dropFirst() {
            if uppercase.contains(scalar) {
                newString.append(" ")
            }
            let character = Character(scalar)
            newString.append(character)
        }
        return newString
    }
}
