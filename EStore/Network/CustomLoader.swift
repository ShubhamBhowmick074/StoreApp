//
//  ProductsDataModel.swift
//  EStore
//
//  Created by Shubham Bhowmick on 21/08/23.
//

import UIKit

class CustomLoader: NSObject {
    
    // MARK: - Properties
    
    static let shared = CustomLoader()
    var loaderView: UIView!
    var spinnerSize: CGSize = CGSize(width: 60, height: 60)
    var messageLabel = UILabel()
    
    // MARK: - LifeCycle Functions
    
    override init() {
        super.init()
        setUpLoaderView()
    }
    
    // MARK: - Helper Functions
    
    func show(text: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {
                return
            }
            self.loaderView.alpha = 0
            self.messageLabel.text = text ?? ""
            guard let window = UIApplication.shared.appWindow else { return }
            window.addSubview(self.loaderView)
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.loaderView.alpha = 1
            }) { (finish) in
                //
            }
        }
    }
    
    func hide(completion: (() -> ())? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {
                return
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.loaderView.alpha = 0
            }) { (finish) in
                self.loaderView.removeFromSuperview()
                completion?()
            }
        }
    }
    
    func setUpLoaderView() {
        loaderView = UIView()
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loaderView.frame = UIScreen.main.bounds
        
        let spinnerView = SpinnerView()
        spinnerView.frame.size = spinnerSize
        spinnerView.center = loaderView.center
        
        messageLabel.font = .systemFont(ofSize: 16.0)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        messageLabel.center = CGPoint(x: loaderView.center.x, y: loaderView.center.y+45)
        
        loaderView.addSubview(spinnerView)
        loaderView.addSubview(messageLabel)
        
    }
    
}

class SpinnerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 4.5
        setPath()
    }

    override func didMoveToWindow() {
        self.animate()
    }

    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }

    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7),
            ]
        }
    }

    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)

        animateStrokeHueWithDuration(duration: totalSeconds * 5)
    }

    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }

    func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        let count = 36
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        animation.values = (0 ... count).map {
            UIColor(hue: CGFloat($0) / CGFloat(count), saturation: 1, brightness: 1, alpha: 1).cgColor
        }
        animation.duration = duration
        animation.calculationMode = .linear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }

}
