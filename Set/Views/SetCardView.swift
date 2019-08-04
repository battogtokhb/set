//
//  CardView.swift
//  Graphical Set
//
//  Created by Bilguunzaya Battogtokh on 4/28/19.
//  Copyright © 2019 Bilguunzaya Battogtokh. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    
    enum Shape{
        case oval
        case diamond
        case squiggle
    }
    
    var shape: Shape = .oval { didSet {
        setNeedsDisplay()
        setNeedsLayout()
        } }
    
    
    
    enum Shading{
        case solid
        case striped
        case open
    }
    
    var shading : Shading = .solid { didSet { setNeedsDisplay()
        setNeedsLayout()
        
        } }
    
    
    var status : SetGame.CardStatus = SetGame.CardStatus.selected{
        didSet{
            switch status{
            case .normal:
                background = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            case .selected:
                background = #colorLiteral(red: 0.7929172409, green: 0.9453280717, blue: 1, alpha: 1)
                borderColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
                
            case .matched:
                background = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                
            case .mismatched:
                background = #colorLiteral(red: 1, green: 0.76047181, blue: 0.81289631, alpha: 1)
                borderColor = #colorLiteral(red: 1, green: 0.5463533477, blue: 0.5794819581, alpha: 1)
                
            }
        }
    }
    
    
    
    
    private let faceDownColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
    
    var isFaceUp : Bool = true { didSet { setNeedsDisplay()
        setNeedsLayout()
        
        } }
    
    var toDeal : Bool = true
    
    
    var shapeColor : UIColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) { didSet { setNeedsDisplay()
        setNeedsLayout()
        
        } }
    
    
    
    var borderColor : UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1){ didSet { setNeedsDisplay()
        setNeedsLayout()
        
        } }
    
    
    var background : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1){ didSet { setNeedsDisplay()
        setNeedsLayout()
        
        } }
    
    
    var number : Int = 1 { didSet { setNeedsDisplay()
        setNeedsLayout()
        
        } }
    
    
    init(card : SetCard, status: SetGame.CardStatus) {
        super.init(frame: CGRect())
        switch card.color.rawValue{
        case 1: self.shapeColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case 2: self.shapeColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        case 3: self.shapeColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        default:
            break
        }
        
        switch card.shading.rawValue{
        case 1: self.shading = .solid
        case 2: self.shading = .striped
        case 3: self.shading = .open
        default: break
        }
        
        switch card.shape.rawValue{
        case 1: self.shape = .oval
        case 2: self.shape = .diamond
        case 3: self.shape = .squiggle
        default: break
        }
        
        
        self.number = card.number.rawValue
        
        switch status {
        case .normal:
            self.background = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            self.status = .normal
        case .selected:
            self.background = #colorLiteral(red: 0.7929172409, green: 0.9453280717, blue: 1, alpha: 1)
            self.borderColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
            self.status = .selected
        case .matched:
            self.background = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            self.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            self.status = .matched
            
        case .mismatched:
            self.background = #colorLiteral(red: 1, green: 0.76047181, blue: 0.81289631, alpha: 1)
            self.borderColor = #colorLiteral(red: 1, green: 0.5463533477, blue: 0.5794819581, alpha: 1)
            self.status = .mismatched
            
            
        }
        
        
        
        
        
        
        setTransparentInitialBackground()
        contentMode = .redraw
    }
    
    
    /*
     Use grid to divide drawing area of each Card View into different cells (CGRects) depending on
     how many shapes need to be drawn.
     */
    
    private lazy var grid = Grid(layout: .dimensions(rowCount: number, columnCount: 1), frame:  bounds.zoom(by: SizeRatio.shapesDrawingAreaZoomFactor))
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawCard(in: rect)
        
    }
    
    /*
     Set the card background to have a border and a background color.
     */
    
    private func drawCard(in rect: CGRect){
        if isFaceUp {
            //Draw a rounded rect representing the border
            let borderRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            borderColor.setFill()
            borderRect.fill()
            
            //Draw an "inner" rounded rect on the previous one representing background color
            let innerBackgroundRect = UIBezierPath(roundedRect: bounds.zoom(by: SizeRatio.innerBackgroundZoomFactor), cornerRadius: cornerRadius / 2)
            
            background.setFill()
            innerBackgroundRect.fill()
            
            drawCardShapes(in: rect)
        }
        else{
            let borderRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            faceDownColor.setFill()
            borderRect.fill()
            
        }
        
        
    }
    
    private var drawableRect : CGRect{
        return bounds.zoom(by: SizeRatio.shapesDrawingAreaZoomFactor)
    }
    
    private var shapeHorizontalMargin : CGFloat{
        return drawableRect.width * 0.015
    }
    
    private var shapeVerticalMargin : CGFloat{
        return drawableRect.height * 0.015
    }
    
    /*
     Calculate how tall each shape should be
     */
    private var shapeHeight : CGFloat{
        return ((drawableRect.height - 6 * shapeVerticalMargin) / 3) * 0.80
    }
    
    /*
     Calculate how wide each shape should be
     */
    private var shapeWidth : CGFloat{
        return drawableRect.width * 0.80
    }
    
    
    private func drawCardShapes(in rect : CGRect){
        grid.frame = bounds.zoom(by: SizeRatio.shapesDrawingAreaZoomFactor)
        grid.layout = .dimensions(rowCount: number, columnCount: 1)
        shapeColor.setStroke()
        shapeColor.setFill()
        for idx in 0..<number{
            if let cellRect = grid[idx]?.inset(by: CGSize(width: shapeHorizontalMargin, height: shapeVerticalMargin)){
               
                    let path = getShapePath(in : cellRect)
                    shapeColor.setStroke()
                    switch shading{
                    case .open: path.stroke()
                    case .solid: path.fill()
                    case .striped: putStripes(in: path, on: cellRect)
                    }
                
                
            }
        }
    }
    
    
    
    private func getShapePath(in rect : CGRect) -> UIBezierPath{
        switch shape{
        case .diamond: return diamondPath(in: rect)
        case .oval: return ovalPath(in: rect)
        case .squiggle: return squigglePath(in: rect)
        }
    }
    
    private func diamondPath(in rect : CGRect) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX - shapeWidth / 2 , y: rect.midY ))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - shapeHeight / 2 ))
        path.addLine(to: CGPoint(x: rect.midX + shapeWidth / 2, y: rect.midY ))
        path.addLine(to: CGPoint(x: rect.midX , y: rect.midY + shapeHeight / 2  ))
        path.close()
        path.lineWidth = SizeRatio.pathLineWidth
        return path
    }
    
    private func ovalPath(in rect : CGRect) -> UIBezierPath{
        let path = UIBezierPath(roundedRect: CGRect(x: rect.midX - shapeWidth / 2, y: rect.midY - shapeHeight / 2 , width: shapeWidth, height: shapeHeight), cornerRadius: shapeHeight / 2)
        path.lineWidth = SizeRatio.pathLineWidth
        return path
    }
    
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
    
    /*
     
     NOTE: Adapted from the following reference on StackOverflow: https://stackoverflow.com/questions/25387940/how-to-draw-a-perfect-squiggle-in-set-card-game-with-objective-c
     
     Personal modifications made: Original calculations on startingX and startingY
     
     */
    
    private func squigglePath(in rect : CGRect) -> UIBezierPath{
        let path = UIBezierPath()
        let startingX = rect.midX - shapeWidth / 2
        let startingY = rect.midY - shapeHeight / 2
        path.move(to: CGPoint(x: startingX  + shapeWidth * 0.05 , y: startingY + shapeHeight * 0.40 ))
        path.addCurve(
            to:   CGPoint(x: startingX + shapeWidth * 0.35 , y: startingY + shapeHeight * 0.25 ),
            controlPoint1: CGPoint(x: startingX + shapeWidth * 0.09 , y: startingY + shapeHeight * 0.15 ),
            controlPoint2: CGPoint(x: startingX + shapeWidth * 0.18 , y: startingY + shapeHeight * 0.10 ))
        
        path.addCurve(
            to: CGPoint(x: startingX + shapeWidth * 0.75 , y: startingY + shapeHeight * 0.30 ),
            controlPoint1: CGPoint(x: startingX + shapeWidth * 0.40 , y: startingY + shapeHeight * 0.30 ),
            controlPoint2: CGPoint(x: startingX + shapeWidth * 0.60 , y: startingY + shapeHeight * 0.45 ))
        //
        path.addCurve(
            to: CGPoint(x:  startingX + shapeWidth * 0.97 , y: startingY + shapeHeight * 0.35 ),
            controlPoint1: CGPoint(x:  startingX + shapeWidth * 0.87 , y: startingY + shapeHeight * 0.15 ),
            controlPoint2: CGPoint(x:  startingX + shapeWidth * 0.98 , y: startingY + shapeHeight * 0.00 ))
        
        path.addCurve(
            to: CGPoint(x:  startingX + shapeWidth * 0.45 , y: startingY + shapeHeight * 0.85 ),
            controlPoint1: CGPoint(x:  startingX + shapeWidth * 0.95 , y: startingY + shapeHeight * 1.10 ),
            controlPoint2: CGPoint(x:  startingX + shapeWidth * 0.50 , y: startingY + shapeHeight * 0.95 ))
        
        path.addCurve(
            to: CGPoint(x:  startingX + shapeWidth * 0.25 , y: startingY + shapeHeight * 0.85 ),
            controlPoint1: CGPoint(x:  startingX + shapeWidth * 0.40 , y: startingY + shapeHeight * 0.80 ),
            controlPoint2: CGPoint(x:  startingX + shapeWidth * 0.35 , y: startingY + shapeHeight * 0.75 ))
        
        path.addCurve(
            to: CGPoint(x:  startingX + shapeWidth * 0.05 , y: startingY + shapeHeight * 0.40 ),
            controlPoint1: CGPoint(x:  startingX + shapeWidth * 0.00 , y: startingY + shapeHeight * 1.10 ),
            controlPoint2: CGPoint(x:  startingX + shapeWidth * 0.005 , y: startingY + shapeHeight * 0.60 ))
        
        path.lineWidth = SizeRatio.pathLineWidth
        
        return path
    }
    
    private func putStripes(in path: UIBezierPath, on rect : CGRect){
        let numberOfStripes = 100
        
        let stripesSpacingFactor = CGFloat(rect.width / 10)
        
        UIGraphicsGetCurrentContext()?.saveGState()
        path.addClip()
        
        for x in 0..<numberOfStripes{
            path.move(to: CGPoint(x: CGFloat(x) *   stripesSpacingFactor, y: rect.minX))
            path.addLine(to: CGPoint(x: CGFloat(x) *   stripesSpacingFactor, y: rect.maxY) )
        }
        path.lineWidth = SizeRatio.pathLineWidth
        
        path.stroke()
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
    
    
    
    
}


extension SetCardView
    
{
    
    private struct SizeRatio {
        
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        
        static let cardCenterSizeToBoundsSize: CGFloat = 0.75
        
        static let innerBackgroundZoomFactor : CGFloat = 0.92
        
        static let shapesDrawingAreaZoomFactor : CGFloat = 0.88
        
        static let stripesSpacingFactor : CGFloat = 5
        
        static let pathLineWidth : CGFloat = 1.5
        
    }
    
    
    
    private var cornerRadius: CGFloat {
        
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
        
    }
    
    
    private var cornerOffset: CGFloat {
        
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
        
    }
    
    
    
}
