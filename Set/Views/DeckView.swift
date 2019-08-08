//
//  DeckView.swift
//  Animated Set
//
//  Created by Bilguunzaya Battogtokh on 5/10/19.
//  Copyright © 2019 Bilguunzaya Battogtokh. All rights reserved.
//

import UIKit

@IBDesignable
class DeckView: UIView {

    var deckColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) { didSet { setNeedsDisplay() } }

    var deckText = "Text" { didSet { setNeedsDisplay() } }

    /* Following set up & init code obtained from Lecture 9. */

    private func setTransparentInitialBackground() {
        backgroundColor = .clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTransparentInitialBackground()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTransparentInitialBackground()
    }

    private lazy var deckLabel: UILabel = createLabel()

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        addSubview(label)
        return label
    }

    private func resizeLabel(_ label: UILabel) {
        label.text = deckText
        label.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height / 2)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        resizeLabel(deckLabel)
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        deckColor.setFill()
        path.fill()
    }
}

extension DeckView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
    }

    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }

    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
}
