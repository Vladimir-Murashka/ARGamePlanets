//
//  CollisionCategory.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 29.06.2022.
//

struct CollisionCategory: OptionSet{
    let rawValue: Int
    
    static let missleCategory = CollisionCategory(rawValue: 1 << 0)
    static let targetCategory = CollisionCategory(rawValue: 1 << 1)
}
