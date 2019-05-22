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

@IBDesignable public class YQRedDot: UIView {
    
    /// 红点上显示的数字，只对number型有效
    @IBInspectable public var value: Int = 0 {
        didSet {
            guard type == .number else {
                fatalError("当前类型不是number,不允许设置value")
            }
            let text = self.value.text()
            size = text.size(with: font)
            self.text = text
            setNeedsDisplay()
        }
    }
    public var type: YQRedDotType = .number {
        didSet {
            if self.type == .number {
                size = text.size(with: font)
            } else {
                size = CGSize(width: 8, height: 8)
            }
            setNeedsDisplay()
        }
    }
    @IBInspectable public var font: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            guard type == .number else {
                return
            }
            size = text.size(with: self.font)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var valueColor: UIColor = UIColor.white {
        didSet {
            guard type == .number else {
                return
            }
            setNeedsDisplay()
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
            guard type == .number else {
                return
            }
            setNeedsDisplay()
        }
    }
    private lazy var style: NSParagraphStyle = {
        var style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        return style
    }()
    
    init() {
        super.init(frame:CGRect.zero)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        context.setFillColor(UIColor.red.cgColor)
        if size.width == size.height {
            let width = min(bounds.width, bounds.height)
            let x = (bounds.width - width) / 2
            let y = (bounds.height - width) / 2
            context.fillEllipse(in: CGRect(x: x, y: y, width: width, height: width))
        } else {
            let radius = bounds.height / 2
            context.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi / 2 * 3, clockwise: false)
            context.addLine(to: CGPoint(x: bounds.width - radius, y: 0))
            context.addArc(center: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi / 2, clockwise: false)
            context.fillPath()
        }
        guard type == .number else {return}
        let text = self.text as NSString
        let drawRect = bounds.inset(by: contentInsets)
        text.draw(in: drawRect, withAttributes: [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.foregroundColor: valueColor, NSAttributedString.Key.font: font])
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: size.width + contentInsets.left + contentInsets.right, height: size.height + contentInsets.top + contentInsets.bottom)
    }

}

private let YQRedDotNumberTag: Int = 235813
private let YQRedDotSolidTag: Int = 1235813

extension UIView {
    
    /// 展示带数字的小红点
    /// 数字如果小于等于0就隐藏
    /// - Parameter value: 数字
    func showBadge(_ value: Int) {
        guard value > 0 else {
            hideBadge()
            return
        }
        if let view = viewWithTag(YQRedDotNumberTag) as? YQRedDot {
            view.value = value
        } else {
            let view = YQRedDot()
            view.value = value
            view.tag = YQRedDotNumberTag
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            view.centerXAnchor.constraint(equalTo: trailingAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: topAnchor).isActive = true
        }
    }
    
    /// 隐藏小红点
    func hideBadge() {
        if let view = viewWithTag(YQRedDotNumberTag) as? YQRedDot {
            view.removeFromSuperview()
        }
    }
    
    /// 显示实心红点
    func showRedDot() {
        if let view = viewWithTag(YQRedDotSolidTag) as? YQRedDot {
            view.type = .solid
        } else {
            let view = YQRedDot()
            view.type = .solid
            view.tag = YQRedDotSolidTag
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            view.centerXAnchor.constraint(equalTo: trailingAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: topAnchor).isActive = true
        }
    }
    
    /// 隐藏实心红点
    func hideRedDot() {
        if let view = viewWithTag(YQRedDotSolidTag) as? YQRedDot {
            view.removeFromSuperview()
        }
    }
    
    public var badge: Int {
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
    
    public var redDot: Bool {
        set {
            if newValue {
                showRedDot()
            } else {
                hideRedDot()
            }
        }
        get {
            if let view = viewWithTag(YQRedDotSolidTag) as? YQRedDot {
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
    fileprivate func size(with font: UIFont) -> CGSize {
        guard !isEmpty else {
            return CGSize.zero
        }
        let string = self as NSString
        var size = string.size(withAttributes: [NSAttributedString.Key.font : font])
        if size.height > size.width {
            size.width = size.height
        }
        return size
    }
}
