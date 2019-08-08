//
//  SetCard.swift
//  Set
//
//  Created by Bilguunzaya Battogtokh on 4/16/19.
//  Copyright © 2019 Bilguunzaya Battogtokh. All rights reserved.
//

import Foundation
// swiftlint:disable line_length
struct SetCard: Hashable {
    /*
     The four features (number of shapes, shape, shading, color) of a card in the game Set each have three possible values (or "flavors"). For instance, for the feature color, the possible values are red, green, or purple. Therefore, we can use the enum Flavor to represent the possibile value for each feature.
     
     Also note from spec: "It’d probably be good MMVC design not to hardwire specific color names or shape names (like diamond or oval or green or striped) into the property names in your Model code."
     */
    enum Flavor: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3

        static var allCases: [Flavor] {
            return [one, two, three]
        }
    }

    let number: Flavor
    let shape: Flavor
    let color: Flavor
    let shading: Flavor

    func printFeatures() {
        print("number: \(number.rawValue), shape: \(shape.rawValue), color: \(color.rawValue), shading: \(shading.rawValue)")
    }

    /*
     Compare two cards.
    */
    static func == (lhs: SetCard, rhs: SetCard) -> Bool {
        return( lhs.number == rhs.number &&
                lhs.shading == rhs.shading &&
                lhs.color == rhs.color &&
                lhs.shape == rhs.shape)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
        hasher.combine(shape)
        hasher.combine(color)
        hasher.combine(shading)
    }
}
