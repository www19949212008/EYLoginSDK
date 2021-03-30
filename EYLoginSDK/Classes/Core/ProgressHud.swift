//
//  ProgressHud.swift
//  MuslimPrayerReminder
//
//  Created by eric on 2020/6/16.
//  Copyright © 2020 Eyu. All rights reserved.
//

import UIKit

class ProgressHud: UIView {
    private let textLabel = MarginLabel()
    private let hud = UIActivityIndicatorView(style: .whiteLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        textLabel.textAlignment = .center
        textLabel.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textLabel.numberOfLines = 0
        textLabel.backgroundColor = UIColor.black
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.textColor = UIColor.white
        textLabel.layer.cornerRadius = 5
        textLabel.clipsToBounds = true
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let constraint2 = NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let constraint3 = NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: screenWidth-40)
        self.addConstraints([constraint1, constraint2, constraint3])
        
        hud.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hud)
        hud.isHidden = true
        let constraint4 = NSLayoutConstraint(item: hud, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let constraint5 = NSLayoutConstraint(item: hud, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([constraint4, constraint5])
    }
    
    class func showTextHud(_ text: String) {
        let hud = ProgressHud()
        hud.showText(text)
    }
    
    func showText(_ text: String) {
        textLabel.text = text
        if textLabel.frame == CGRect.zero {
            textLabel.sizeToFit()
        }
        UIApplication.shared.keyWindow?.addSubview(self)
        let constraint1 = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: UIApplication.shared.keyWindow, attribute: .centerX, multiplier: 1, constant: 0)
        let constraint2 = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: UIApplication.shared.keyWindow, attribute: .centerY, multiplier: 1, constant: 0)
        let constraint3 = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: textLabel, attribute: .width, multiplier: 1, constant: 0)
        let constraint4 = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: textLabel, attribute: .height, multiplier: 1, constant: 0)
        UIApplication.shared.keyWindow?.addConstraints([constraint1, constraint2, constraint3, constraint4])
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            self.removeFromSuperview()
        }
    }
    
    func showAnimatedHud() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        textLabel.isHidden = true
        hud.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(self)
        let constraint1 = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: UIApplication.shared.keyWindow, attribute: .top, multiplier: 1, constant: 0)
        let constraint2 = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: UIApplication.shared.keyWindow, attribute: .bottom, multiplier: 1, constant: 0)
        let constraint3 = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: UIApplication.shared.keyWindow, attribute: .left, multiplier: 1, constant: 0)
        let constraint4 = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: UIApplication.shared.keyWindow, attribute: .right, multiplier: 1, constant: 0)
        UIApplication.shared.keyWindow?.addConstraints([constraint1, constraint2, constraint3, constraint4])
        hud.startAnimating()
    }
    
    func stopAnimatedHud() {
        hud.stopAnimating()
        self.removeFromSuperview()
    }
}

class MarginLabel: UILabel {
    
    var contentInset: UIEdgeInsets = .zero
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect: CGRect = super.textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
        //根据edgeInsets，修改绘制文字的bounds
        rect.origin.x -= contentInset.left;
        rect.origin.y -= contentInset.top;
        rect.size.width += contentInset.left + contentInset.right;
        rect.size.height += contentInset.top + contentInset.bottom;
        return rect
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }
}
