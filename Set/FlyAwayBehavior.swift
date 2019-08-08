//
//  FlyAwayBehavior.swift
//  Animated Set
//
//  Created by Bilguunzaya Battogtokh on 5/11/19.
//  Copyright © 2019 Bilguunzaya Battogtokh. All rights reserved.
//

import UIKit
//swiftlint:disable line_length
class FlyAwayBehavior: UIDynamicBehavior {

    var items: [UIDynamicItem]
    init(items: [UIDynamicItem]) {
        self.items = items
    }

    override func willMove(to dynamicAnimator: UIDynamicAnimator?) {
        if dynamicAnimator != nil {
            flyaway()
        }
    }

    private func flyaway() {
        for item in items {
            let push = UIPushBehavior(items: [item], mode: .instantaneous)
            push.magnitude = CGFloat.random(in: 2...4)
            push.angle = CGFloat.random(in: 0...(2 * .pi))
            addChildBehavior(push)
        }

        let collision = UICollisionBehavior(items: items)
        collision.translatesReferenceBoundsIntoBoundary = true
//        collision.action = { [unowned collision] in
//            if let referenceBounds = collision.dynamicAnimator?.referenceView?.bounds {
//                for item in collision.items {
//                    if !referenceBounds.contains(item.center) {
//                        item.center = CGRect(center: item.center, size: item.bounds.size).contained(in: referenceBounds)!.center
//                        collision.dynamicAnimator?.updateItem(usingCurrentState: item)
//                    }
//                }
//            }
//        }

        addChildBehavior(collision)
        let physics = UIDynamicItemBehavior(items: items)
        physics.allowsRotation = true
        physics.elasticity = 0.8
        physics.resistance = 0.4
        physics.angularResistance = 0.2
        addChildBehavior(physics)
    }

    func remove(item: UIDynamicItem) {
        for child in childBehaviors {
            if let behavior = child as? UIDynamicItemBehavior {
                behavior.removeItem(item)
            } else if let behavior = child as? UICollisionBehavior {
                behavior.removeItem(item)
            } else if let behavior = child as? UIPushBehavior {
                behavior.removeItem(item)
            } else {
                continue
            }
        }
    }
}
