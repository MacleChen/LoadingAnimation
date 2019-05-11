//
//  ViewController.swift
//  LoadingAnimation
//
//  Created by 陈帆 on 2019/5/11.
//  Copyright © 2019 陈帆. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var gradientLayer: CALayer?
    private var rightSymbolLayer: CAShapeLayer?
    private var rightCircleSymbolLayer: CAShapeLayer?
    private var grandidentProgress: ZXYGradientProgress?

    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func refleshBtnClick(_ sender: Any) {
        addLoadingAnimation(superView: view1)
        addRightSymbolAnimation(superView: view2)
        
        // 进度
        let progressWH: CGFloat = view3.bounds.size.width
        if grandidentProgress != nil {
            grandidentProgress?.removeFromSuperview()
        }
        grandidentProgress = ZXYGradientProgress.init(frame: CGRect(x: (view3.bounds.size.width - progressWH) / 2, y: 0, width: progressWH, height: progressWH), progress: 0)
        grandidentProgress?.bottomColor = UIColor.lightGray;
        view3.addSubview(grandidentProgress!)
        
        addRightCircleSymbolAnimation(superView: view4)
    }
    


    @IBAction func slipperBtnClick(_ sender: UISlider) {
        grandidentProgress?.progress = CGFloat(sender.value)
    }
    
}



extension ViewController {
    
    // MARK:  加载小圆圈
    func addLoadingAnimation(superView: UIView) {
        if self.gradientLayer != nil {
            self.gradientLayer?.removeFromSuperlayer()
            self.gradientLayer = nil
        }
        
        // 形状
        let lineWidth: CGFloat = 4
        let middleColor = UIColor.init(red: 255.0/255.0, green: 134.0/255.0, blue: 134.0/255.0, alpha: 1.0)
        let circleLayer = CAShapeLayer.init()
        circleLayer.lineWidth = lineWidth;
        //        circleLayer.frame = self.translateTypeView.bounds
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        
        // 曲线
        //        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: self.translateTypeView.width / 2, y: self.translateTypeView.height / 2), radius: self.translateTypeView.height / 2, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(Double.pi * 2), clockwise: true) // 有毛边
        let circlePath = UIBezierPath.init(ovalIn: superView.bounds)
        circleLayer.path = circlePath.cgPath
        
        // 渐变
        self.gradientLayer = CALayer.init()
        // 渐变1
        let gradient = CAGradientLayer.init()
        gradient.frame = CGRect(x: -lineWidth * 2, y: -lineWidth * 2, width: superView.bounds.size.width / 2 + lineWidth * 2, height: superView.bounds.size.height + lineWidth*3)
        gradient.colors = [UIColor.red.cgColor, middleColor.cgColor]
        //        gradient.locations = [NSNumber(value: 0.1), NSNumber(value:1.0)] // 设置比例
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.shadowPath = circlePath.cgPath
        
        // 渐变1
        let gradient2 = CAGradientLayer.init()
        gradient2.frame = CGRect(x: superView.bounds.size.width / 2, y: -lineWidth * 2, width: superView.bounds.size.width / 2 + lineWidth * 2, height: superView.bounds.size.height + lineWidth*3)
        gradient2.colors = [UIColor.white.cgColor, middleColor.cgColor]
        //        gradient2.locations = [NSNumber(value: 0.1), NSNumber(value:1.0)]
        gradient2.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient2.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient2.shadowPath = circlePath.cgPath
        
        gradientLayer!.addSublayer(gradient)
        gradientLayer!.addSublayer(gradient2)
        gradientLayer!.mask = circleLayer
        
        // CABasicAnimation strokeEnd动画
        let pathAnimation = CABasicAnimation()
        pathAnimation.keyPath = "strokeEnd"
        pathAnimation.duration = 1.0
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.repeatCount = 1
        circleLayer.add(pathAnimation, forKey: "strokeEndAnimationcircle")
        
        // 旋转z
        let rotateAnima = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotateAnima.duration = 1.0
        rotateAnima.repeatCount = HUGE
        rotateAnima.fromValue = NSNumber(value: 0.0)
        rotateAnima.toValue = NSNumber(value: Double.pi * 2)
        rotateAnima.beginTime = CACurrentMediaTime() + 3.0 / 4.0
        
        gradientLayer!.add(rotateAnima, forKey: "rotateAnimationcircle")
        gradientLayer!.frame = superView.bounds  // 一定要设置frame，不然anchorPoint(锚点--旋转中心点始终是（0,0）)
        superView.layer.addSublayer(gradientLayer!)
    }
    
    // MARK: 对勾
    func addRightSymbolAnimation(superView: UIView) {
        if self.rightSymbolLayer != nil {
            self.rightSymbolLayer?.removeFromSuperlayer()
            self.rightSymbolLayer = nil
        }
        // 形状
        let lineWidth: CGFloat = 3
        self.rightSymbolLayer = CAShapeLayer.init()
        rightSymbolLayer!.lineWidth = lineWidth;
        //        circleLayer.frame = self.translateTypeView.bounds
        rightSymbolLayer!.fillColor = UIColor.clear.cgColor
        rightSymbolLayer!.strokeColor = UIColor.blue.cgColor
        
        // 曲线
        //        let bezierPath = UIBezierPath.init(arcCenter: CGPoint(x: self.translateTypeView.width / 2, y: self.translateTypeView.height / 2), radius: self.translateTypeView.width / 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)  // 画圈
        
        let bezierPath = UIBezierPath.init()
        // 对拐角和终点的处理
        bezierPath.lineCapStyle = CGLineCap.round  // 圆角
        bezierPath.lineJoinStyle = CGLineJoin.round
        
        // 画直线
        bezierPath.move(to: CGPoint(x: superView.bounds.size.width / 5, y: superView.bounds.size.width / 2))
        bezierPath.addLine(to: CGPoint(x: superView.bounds.size.width / 5.0 * 2.0, y: superView.bounds.size.width / 4.0 * 3))
        // 画斜线
        bezierPath.addLine(to: CGPoint(x: superView.bounds.size.width / 8.0 * 6, y: superView.bounds.size.width / 4.0 + 4))
        
        rightSymbolLayer!.path = bezierPath.cgPath
        
        // 动画设置
        // CABasicAnimation strokeEnd动画
        let pathAnimation = CABasicAnimation()
        pathAnimation.keyPath = "strokeEnd"
        pathAnimation.duration = 0.5
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.repeatCount = 1
        rightSymbolLayer!.add(pathAnimation, forKey: "strokeEndAnimationcircle")
        
        superView.layer.addSublayer(rightSymbolLayer!)
    }
    
    
    // MARK: 对勾（带圆圈）
    func addRightCircleSymbolAnimation(superView: UIView) {
        if self.rightCircleSymbolLayer != nil {
            self.rightCircleSymbolLayer?.removeFromSuperlayer()
            self.rightCircleSymbolLayer = nil
        }
        // 形状
        let lineWidth: CGFloat = 6
        self.rightCircleSymbolLayer = CAShapeLayer.init()
        rightCircleSymbolLayer!.lineWidth = lineWidth;
        //        circleLayer.frame = self.translateTypeView.bounds
        rightCircleSymbolLayer!.fillColor = UIColor.clear.cgColor
        rightCircleSymbolLayer!.strokeColor = UIColor.purple.cgColor
        // 对拐角和终点的处理
        rightCircleSymbolLayer?.lineCap = CAShapeLayerLineCap.round  // 圆角
        rightCircleSymbolLayer?.lineJoin = CAShapeLayerLineJoin.round
        
        // 阴影
        rightCircleSymbolLayer!.shadowColor = UIColor.black.cgColor
        rightCircleSymbolLayer!.shadowOffset = CGSize(width: 0.5, height: 0.5)
        rightCircleSymbolLayer!.shadowOpacity = 0.12
        
        // 曲线
        let bezierPath = UIBezierPath.init(arcCenter: CGPoint(x: superView.bounds.size.width / 2, y: superView.bounds.size.height / 2), radius: superView.bounds.size.width / 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)  // 画圈
        
        // 画直线
        bezierPath.move(to: CGPoint(x: superView.bounds.size.width / 5, y: superView.bounds.size.width / 2))
        bezierPath.addLine(to: CGPoint(x: superView.bounds.size.width / 5.0 * 2.0, y: superView.bounds.size.width / 4.0 * 3))
        // 画斜线
        bezierPath.addLine(to: CGPoint(x: superView.bounds.size.width / 8.0 * 6, y: superView.bounds.size.width / 4.0 + 4))
        
        rightCircleSymbolLayer!.path = bezierPath.cgPath
        
        // 动画设置
        // CABasicAnimation strokeEnd动画
        let pathAnimation = CABasicAnimation()
        pathAnimation.keyPath = "strokeEnd"
        pathAnimation.duration = 2
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.repeatCount = 1
        rightCircleSymbolLayer!.add(pathAnimation, forKey: "strokeEndAnimationcircle")
        
        superView.layer.addSublayer(rightCircleSymbolLayer!)
    }
}

