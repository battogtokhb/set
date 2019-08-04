//
//  CGExtensions.swift
//  Cards
//
//  Created by Paul Hegarty on 4/16/19.
//  Copyright © 2019 CS193p Instructor. All rights reserved.
//

import UIKit

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x-size.width/2, y: center.y-size.height/2), size: size)
    }
    func intersects(_ rects: [CGRect]) -> Bool {
        for rect in rects {
            if intersects(rect) {
                return true
            }
        }
        return false
    }
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    func contained(in outerRect: CGRect) -> CGRect? {
        if size.width > outerRect.size.width || size.height > outerRect.size.height {
            return nil
        } else {
            var containedRect = self
            if minX < outerRect.minX {
                containedRect.origin.x = outerRect.origin.x
            } else if containedRect.maxX > outerRect.maxX {
                containedRect.origin.x = outerRect.maxX - containedRect.size.width
            }
            if minY < outerRect.minY {
                containedRect.origin.y = outerRect.origin.y
            } else if containedRect.maxY > outerRect.maxY {
                containedRect.origin.y = outerRect.maxY - containedRect.size.height
            }
            return containedRect
        }
    }
}

extension CGSize {
    func centered(in rect: CGRect) -> CGRect {
        return CGRect(x: rect.midX-width/2, y: rect.midY-height/2, width: width, height: height)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
    static func random(in rect: CGRect) -> CGPoint {
        return CGPoint(x: CGFloat.random(in: rect.minX...rect.maxX), y: CGFloat.random(in: rect.minY...rect.maxY))
    }
}

extension CGAffineTransform {
    func scaled(by factor: CGFloat) -> CGAffineTransform {
        return scaledBy(x: factor, y: factor)
    }
}
