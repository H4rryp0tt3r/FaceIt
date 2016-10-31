import UIKit

@IBDesignable
class FaceView: UIView {

    let scale: CGFloat = 0.90

    private var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }

    private var faceCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    private struct Ratios {
        static let FaceRadiusToEyeOffSet: CGFloat = 3
        static let FaceRadiusToEyeRadius: CGFloat = 10
        static let FaceRadiusToMouthWidth: CGFloat = 1
        static let FaceRadiusToMouthHeight: CGFloat = 3
        static let FaceRadiusToMouthRadius: CGFloat = 3
    }

    private enum Eye {
        case Left
        case Right
    }

    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = faceRadius / Ratios.FaceRadiusToEyeOffSet
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left:
            eyeCenter.x -= eyeOffset
        default:
            eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }

    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Ratios.FaceRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
    }

    private func pathForMount() -> UIBezierPath {
        let mouthWidth = faceRadius / Ratios.FaceRadiusToMouthWidth
        let mouthHeight = faceRadius / Ratios.FaceRadiusToMouthHeight
        let mouthOffSet = faceRadius / Ratios.FaceRadiusToMouthRadius

        let mouthRect = CGRect(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthOffSet, width: mouthWidth, height: mouthHeight)

        let mouthCurvature: Double = 1.0

        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)

        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 3.0

        return path
    }

    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = 3.0
        return path
    }

    override func draw(_ rect: CGRect) {
        UIColor.blue.set()
        pathForCircleCenteredAtPoint(midPoint: faceCenter, withRadius: faceRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMount().stroke()
    }
}
