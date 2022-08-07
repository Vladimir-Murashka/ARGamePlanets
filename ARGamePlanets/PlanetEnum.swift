//
//  PlanetEnum.swift
//  ARGamePlanets
//
//  Created by Swift Learning on 11.07.2022.
//

import UIKit

enum Planet: String, CaseIterable {
    case earth
    case jupiter
    case mars
    case mercury
    case moon
    case neptune
    
    
    var image: UIImage? {
        switch self {
        case .earth:
            return UIImage(named: "earth.jpg")
        case .jupiter:
            return UIImage(named: "jupiter.jpg")
        case .mars:
            return UIImage(named: "mars.jpg")
        case .mercury:
            return UIImage(named: "mercury.jpg")
        case .moon:
            return UIImage(named: "moon.jpg")
        case .neptune:
            return UIImage(named: "neptune.jpg")
        }
    }
}
