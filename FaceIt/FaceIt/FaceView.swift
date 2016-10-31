import UIKit

class FaceView: UIView {
    override func draw(_ rect: CGRect) {
        let faceRadius = min(bounds.size.width, bounds.size.height) / 2
        let faceCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let face = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        face.lineWidth = 3.0
        UIColor.blue.set()
        face.stroke()
    }
}
