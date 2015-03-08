//
//  TemplateImageView.swift
//  TemplateImageView
//
//  Created by Sihao Lu on 3/6/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit

@IBDesignable class TemplateImageView: UIView {
    
    @IBInspectable var sizeMarkHeight: CGFloat = 5
    @IBInspectable var sizeMarkIndentation: CGFloat = 10
    @IBInspectable var sizeMarkTextSize: CGFloat {
        get {
            return sizeMarkFont.pointSize
        }
        set {
            sizeMarkFont = UIFont(name: "HelveticaNeue-Light", size: newValue)!
        }
    }
    var sizeMarkFont: UIFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
    @IBInspectable var sizeMarkTextColor: UIColor = UIColor.blackColor()
    @IBInspectable var sizeMarkColor: UIColor = UIColor.blackColor()
    @IBInspectable var sizeMarkTextTopPadding: CGFloat = 2
    
    @IBInspectable var show1x: Bool = true
    @IBInspectable var show2x: Bool = true
    @IBInspectable var show3x: Bool = true
    @IBInspectable var simpleSizeMark: Bool = false
    
    @IBInspectable var descriptiveText: String?
    @IBInspectable var descriptiveTextSize: CGFloat {
        get {
            return descriptiveTextFont.pointSize
        }
        set {
            descriptiveTextFont = UIFont(name: "HelveticaNeue", size: newValue)!
        }
    }
    var descriptiveTextFont: UIFont = UIFont(name: "HelveticaNeue", size: 16)!
    @IBInspectable var descriptiveTextColor: UIColor = UIColor.blackColor()
    
    var imageView: UIImageView = UIImageView()
    
    @IBInspectable var image: UIImage? {
        get {
            return imageView.image
        }
        
        set {
            imageView.image = newValue
        }
    }
    
    struct SizeMarkMask: RawOptionSetType, BooleanType {
        private var value: UInt
        
        init(rawValue: UInt) {
            value = rawValue
        }
        
        init(nilLiteral: ()) {
            value = 0
        }
        
        var rawValue: UInt {
            return value
        }
        
        var boolValue: Bool {
            return value != 0
        }
        
        static var allZeros: SizeMarkMask {
            return self(rawValue: 0)
        }
        
        static var None: SizeMarkMask {
            return self(rawValue: 0)
        }
        
        static var Horizontal: SizeMarkMask {
            return self(rawValue: 1)
        }
        
        static var Vertical: SizeMarkMask {
            return self(rawValue: 1 << 1)
        }
        
        static var HorizontalAndVertical: SizeMarkMask {
            return .Horizontal | Vertical
        }
    }
    
    struct SizeDisplayMask: RawOptionSetType, BooleanType {
        private var value: UInt
        
        init(rawValue: UInt) {
            value = rawValue
        }
        
        init(nilLiteral: ()) {
            value = 0
        }
        
        var rawValue: UInt {
            return value
        }
        
        var boolValue: Bool {
            return value != 0
        }
        
        static var allZeros: SizeDisplayMask {
            return self(rawValue: 0)
        }
        
        static var None: SizeDisplayMask {
            return self(rawValue: 0)
        }
        
        static var OneX: SizeDisplayMask {
            return self(rawValue: 1)
        }
        
        static var TwoX: SizeDisplayMask {
            return self(rawValue: 1 << 1)
        }
        
        static var ThreeX: SizeDisplayMask {
            return self(rawValue: 1 << 2)
        }
        
        static var All: SizeDisplayMask {
            return .OneX | .TwoX | .ThreeX
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        #if TARGET_INTERFACE_BUILDER
        if image != nil {
            image!.drawInRect(bounds)
            return
        }
        #endif
        sizeMarkColor.setStroke()
        let boundary = UIBezierPath(rect: bounds)
        boundary.lineJoinStyle = kCGLineJoinRound
        boundary.lineWidth = 2.0
        boundary.stroke()
        let mask: SizeMarkMask = .HorizontalAndVertical
        drawSizeMarks(mask, offset: sizeMarkIndentation, context: context)
        drawDescriptiveText(context: context)
    }
    
    private func drawDescriptiveText(#context: CGContextRef) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        paragraphStyle.lineBreakMode = .ByWordWrapping
        let textAttributes = [NSForegroundColorAttributeName: descriptiveTextColor, NSFontAttributeName: descriptiveTextFont, NSParagraphStyleAttributeName: paragraphStyle]
        if let textString = descriptiveText {
            let text = textString as NSString
            let width: CGFloat = bounds.width / 1.7
            let size = text.boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin | NSStringDrawingOptions.UsesFontLeading, attributes: textAttributes, context: nil)
            let height: CGFloat = size.height
            text.drawInRect(CGRectMake(bounds.width / 2 - width / 2, bounds.height / 2 - height / 2, width, height), withAttributes: textAttributes)
        }
    }
    
    private func drawSizeMarks(mask: SizeMarkMask, offset: CGFloat, context: CGContextRef) {
        let edgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let displayMask: SizeDisplayMask = (show1x ? .OneX : .None) | (show2x ? .TwoX : .None) | (show3x ? .ThreeX : .None)
        let (horizontalText, verticalText) = stringsForSizeMarks(mask, displayMask: displayMask)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        let textAttributes = [NSForegroundColorAttributeName: sizeMarkTextColor, NSFontAttributeName: sizeMarkFont, NSParagraphStyleAttributeName: paragraphStyle]
        if mask & .Horizontal {
            let verticalAssistLine = UIBezierPath()
            verticalAssistLine.moveToPoint(CGPoint(x: edgeInsets.left, y: offset))
            verticalAssistLine.addLineToPoint(CGPoint(x: edgeInsets.left, y: offset + sizeMarkHeight))
            verticalAssistLine.stroke()
            
            let verticalAssistLine2 = UIBezierPath()
            verticalAssistLine2.moveToPoint(CGPoint(x: bounds.width - edgeInsets.right, y: offset))
            verticalAssistLine2.addLineToPoint(CGPoint(x: bounds.width - edgeInsets.right, y: offset + sizeMarkHeight))
            verticalAssistLine2.stroke()
            
            let mainLine = UIBezierPath()
            mainLine.moveToPoint(CGPoint(x: edgeInsets.left, y: offset + sizeMarkHeight / 2.0))
            mainLine.addLineToPoint(CGPoint(x: bounds.width - edgeInsets.right, y: offset + sizeMarkHeight / 2.0))
            mainLine.stroke()
            
            let realSizeMarkIndentation = mask & .Vertical ? sizeMarkIndentation : 0
            
            if let text = horizontalText {
                text.drawInRect(CGRectMake(edgeInsets.left + realSizeMarkIndentation, offset + sizeMarkTextTopPadding, bounds.width - edgeInsets.left - edgeInsets.right - realSizeMarkIndentation, 15), withAttributes: textAttributes)
            }
        }
        if mask & .Vertical {
            let verticalAssistLine = UIBezierPath()
            verticalAssistLine.moveToPoint(CGPoint(x: offset, y: edgeInsets.top))
            verticalAssistLine.addLineToPoint(CGPoint(x: offset + sizeMarkHeight, y: edgeInsets.top))
            verticalAssistLine.stroke()
            
            let verticalAssistLine2 = UIBezierPath()
            verticalAssistLine2.moveToPoint(CGPoint(x: offset, y: bounds.height - edgeInsets.bottom))
            verticalAssistLine2.addLineToPoint(CGPoint(x: offset + sizeMarkHeight, y: bounds.height - edgeInsets.bottom))
            verticalAssistLine2.stroke()
            
            let mainLine = UIBezierPath()
            mainLine.moveToPoint(CGPoint(x: offset + sizeMarkHeight / 2.0, y: edgeInsets.top))
            mainLine.addLineToPoint(CGPoint(x: offset + sizeMarkHeight / 2.0, y: bounds.height - edgeInsets.bottom))
            mainLine.stroke()
            
            let realSizeMarkIndentation = mask & .Horizontal ? sizeMarkIndentation : 0

            CGContextSaveGState(context)
            let context = UIGraphicsGetCurrentContext()
            CGContextTranslateCTM(context, bounds.width, bounds.width)
            let rotation = CGAffineTransformMakeRotation(CGFloat(-M_PI / 2))
            CGContextConcatCTM(context, rotation)
            if let text = verticalText {
                text.drawInRect(CGRectMake(edgeInsets.left + (bounds.width - bounds.height), offset + sizeMarkTextTopPadding - bounds.width, bounds.height - edgeInsets.top - edgeInsets.bottom - sizeMarkIndentation, 15), withAttributes: textAttributes)
            }
            CGContextRestoreGState(context)
        }
    }
    
    private func stringsForSizeMarks(mask: SizeMarkMask, displayMask: SizeDisplayMask) -> (NSString?, NSString?) {
        var horizontal: NSString? = nil
        var vertical: NSString? = nil
        var displays: [NSString]
        if mask & .Horizontal {
            let at1 = NSString(format: "%g@1x", bounds.width * 1)
            let at2 = NSString(format: "%g@2x", bounds.width * 2)
            let at3 = NSString(format: "%g@3x", bounds.width * 3)
            if simpleSizeMark {
                horizontal = NSString(format: "%g", bounds.width * 1)
            } else {
                displays = [NSString]()
                if displayMask & .OneX {
                    displays.append(at1)
                }
                if displayMask & .TwoX {
                    displays.append(at2)
                }
                if displayMask & .ThreeX {
                    displays.append(at3)
                }
                horizontal = (displays as NSArray).componentsJoinedByString(" ")
            }
        }
        if mask & .Vertical {
            let at1 = NSString(format: "%g@1x", bounds.height * 1)
            let at2 = NSString(format: "%g@2x", bounds.height * 2)
            let at3 = NSString(format: "%g@3x", bounds.height * 3)
            if simpleSizeMark {
                vertical = NSString(format: "%g", bounds.height * 1)
            } else {
                displays = [NSString]()
                if displayMask & .OneX {
                    displays.append(at1)
                }
                if displayMask & .TwoX {
                    displays.append(at2)
                }
                if displayMask & .ThreeX {
                    displays.append(at3)
                }
                vertical = (displays as NSArray).componentsJoinedByString(" ")
            }
        }
        return (horizontal, vertical)
    }


    
    override func prepareForInterfaceBuilder() {
        backgroundColor = UIColor.clearColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clearColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(imageView)
        bringSubviewToFront(imageView)
        let top = NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
        addConstraints([top, bottom, left, right])
    }

}
