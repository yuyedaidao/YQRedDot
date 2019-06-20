//
//  YQRedDot.swift
//  YQRedDot_Example
//
//  Created by 王叶庆 on 2019/5/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public enum YQRedDotType {
    
    /// 数字红点
    case number
    
    /// 实心红点
    case solid
}

public class YQRedDotConfigure {
    public static let shared = YQRedDotConfigure()
    private init() {}
    public var valueColor: UIColor = UIColor.white
    public var color: UIColor = UIColor.red
    public var offset: CGPoint = CGPoint.zero
}

@IBDesignable public class YQRedDot: UIView {
    
    /// 红点上显示的数字，只对number型有效
    @IBInspectable public var value: Int = 0 {
        didSet {
            guard type == .number else {
                fatalError("当前类型不是number,不允许设置value")
            }
            let text = self.value.text()
            size = text.size(with: font, insets: contentInsets)
            self.text = text
            setNeedsDisplay()
        }
    }
    public var type: YQRedDotType = .number {
        didSet {
            if self.type == .number {
                size = text.size(with: font, insets: contentInsets)
                self.textLabel.isHidden = false
            } else {
                size = CGSize(width: 8, height: 8)
                self.textLabel.isHidden = true
            }
            setNeedsDisplay()
        }
    }
    @IBInspectable public var font: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            guard type == .number else {
                return
            }
            size = text.size(with: self.font, insets: contentInsets)
            self.textLabel.font = self.font
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var valueColor: UIColor = YQRedDotConfigure.shared.valueColor {
        didSet {
            self.textLabel.textColor = self.valueColor
        }
    }
    
    @IBInspectable public var color: UIColor = YQRedDotConfigure.shared.color {
        didSet {
            if self.color != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable public var contentInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    private var size = CGSize(width: 8, height: 8) {
        didSet {
            if oldValue != self.size {
                invalidateIntrinsicContentSize()
            }
        }
    }
    private var text: String = "" {
        didSet {
            guard type == .number, self.text != oldValue else {
                return
            }
            textLabel.text = self.text
            textLabel.sizeToFit()
        }
    }
    private let textLabel = UILabel()
    private lazy var style: NSParagraphStyle = {
        var style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        return style
    }()
    
    init() {
        super.init(frame:CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.clear
        textLabel.text = text
        textLabel.font = font
        textLabel.textColor = valueColor
        textLabel.textAlignment = NSTextAlignment.center
        addSubview(textLabel)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel.sizeToFit()
        self.textLabel.center = CGPoint(x: (bounds.width - contentInsets.left - contentInsets.right) / 2 + contentInsets.left, y: bounds.height / 2)
    }
    
    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.setFillColor(UIColor.red.cgColor)
        if size.width <= size.height {
            context.fillEllipse(in: bounds)
        } else {
            let radius = size.height / 2
            context.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi / 2 * 3, clockwise: false)
            context.addLine(to: CGPoint(x: bounds.width - radius, y: 0))
            context.addArc(center: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi / 2, clockwise: false)
            context.fillPath()
        }
//        guard type == .number else {return}
//        let text = self.text as NSString
//        let drawRect = bounds.inset(by: contentInsets)
//        text.draw(in: drawRect, withAttributes: [NSAttributedString.Key.foregroundColor: valueColor, NSAttributedString.Key.font: font])
    }
    
    override public var intrinsicContentSize: CGSize {
        return size
    }

}

private let YQRedDotNumberTag: Int = 235813
private let YQRedDotSolidTag: Int = 1235813

public extension UIView {
    
    /// 展示带数字的小红点
    /// 数字如果小于等于0就隐藏
    /// - Parameter value: 数字
    func showBadge(_ value: Int) {
        guard value > 0 else {
            hideBadge()
            return
        }
        let redDot: YQRedDot
        if let view = viewWithTag(YQRedDotNumberTag) as? YQRedDot {
            redDot = view
        } else {
            let offset = YQRedDotConfigure.shared.offset
            let view = YQRedDot()
            view.tag = YQRedDotNumberTag
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            var constraint = view.centerXAnchor.constraint(equalTo: trailingAnchor)
            constraint.constant = offset.x
            constraint.isActive = true
            constraint = view.centerYAnchor.constraint(equalTo: topAnchor)
            constraint.constant = offset.y
            constraint.isActive = true
            redDot = view
        }
        
        redDot.valueColor = YQRedDotConfigure.shared.valueColor
        redDot.color = YQRedDotConfigure.shared.color
        redDot.value = value
    }
    
    /// 隐藏小红点
    func hideBadge() {
        if let view = viewWithTag(YQRedDotNumberTag) as? YQRedDot {
            view.removeFromSuperview()
        }
    }
    
    /// 显示实心红点
    func showRedDot() {
        let redDot: YQRedDot
        if let view = viewWithTag(YQRedDotSolidTag) as? YQRedDot {
            view.type = .solid
            redDot = view
        } else {
            let offset = YQRedDotConfigure.shared.offset
            let view = YQRedDot()
            view.type = .solid
            view.tag = YQRedDotSolidTag
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            var constraint = view.centerXAnchor.constraint(equalTo: trailingAnchor)
            constraint.constant = offset.x
            constraint.isActive = true
            constraint = view.centerYAnchor.constraint(equalTo: topAnchor)
            constraint.constant = offset.y
            constraint.isActive = true
            redDot = view
        }
        redDot.color = YQRedDotConfigure.shared.color
    }
    
    /// 隐藏实心红点
    func hideRedDot() {
        if let view = viewWithTag(YQRedDotSolidTag) as? YQRedDot {
            view.removeFromSuperview()
        }
    }
    
    var badge: Int {
        set {
            showBadge(newValue)
        }
        get {
            if let view = viewWithTag(YQRedDotNumberTag) as? YQRedDot {
                return view.value
            }
            return 0
        }
    }
    
    var redDot: Bool {
        set {
            if newValue {
                showRedDot()
            } else {
                hideRedDot()
            }
        }
        get {
            if let _ = viewWithTag(YQRedDotSolidTag) as? YQRedDot {
                return true
            }
            return false
        }
    }
    
}

extension Int {
    fileprivate func text() -> String {
        let text: String
        if self > 99 {
            text = "\(99)+"
        } else if self > 0 {
            text = "\(self)"
        } else {
            text = ""
        }
        return text
    }
    
}

extension String {
    fileprivate func size(with font: UIFont, insets: UIEdgeInsets = UIEdgeInsets.zero) -> CGSize {
        guard !isEmpty else {
            return CGSize.zero
        }
        let string = self as NSString
        var size = string.size(withAttributes: [NSAttributedString.Key.font : font])
        size = CGSize(width: size.width + insets.left + insets.right, height: size.height + insets.top + insets.bottom)
        if size.width < size.height {
            size.width = size.height
        }
        return size
    }
}
