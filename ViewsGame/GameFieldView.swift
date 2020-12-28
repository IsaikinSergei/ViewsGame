//
//  GameFieldView.swift
//  ViewsGame
//
//  Created by Sergei Isaikin on 28.12.2020.
//

import UIKit

@IBDesignable

class GameFieldView: UIView {
    @IBInspectable var shapeColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapePosition: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapesize: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var isShapeHidden: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    var shapeHithandler: (() -> Void)?
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !isShapeHidden else {
            curPath = nil
            return
        }
        shapeColor.setFill()
        let path = getTrianglePath(in: CGRect(origin: shapePosition, size: shapesize))
        path.fill()
        curPath = path
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let curPath = curPath else { return }
        let hit = touches.contains(where: { touch -> Bool in
            let touchPoint = touch.location(in: self)
            return curPath.contains(touchPoint)
        })
        if hit {
            shapeHithandler?()
        }
    }
    
    func randomizeShapes() {
        let maxX = bounds.maxX - shapesize.width
        let maxY = bounds.maxY - shapesize.height
        let x = CGFloat(arc4random_uniform(UInt32(maxX)))
        let y = CGFloat(arc4random_uniform(UInt32(maxY)))
        shapePosition = CGPoint(x: x, y: y)
    }
    
    private var curPath: UIBezierPath?
    private func getTrianglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 0
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.stroke()
        path.fill()
        return path
        
    }
    
}
