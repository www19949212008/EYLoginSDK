//
//  EYRegisterView.swift
//  EYLoginSDK
//
//  Created by eric on 2021/9/24.
//

import UIKit

class EYRegisterView: FullScreenBaseView {
    
    override func setupWhiteView() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        titleLabel.text = "注册"
        whiteView.addSubview(titleLabel)
        let tc1 = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: whiteView, attribute: .top, multiplier: 1, constant: 15)
        let tc2 = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: whiteView, attribute: .centerX, multiplier: 1, constant: 0)
        whiteView.addConstraints([tc1, tc2])
        
        let cornerView = UIView()
        cornerView.backgroundColor = UIColor.white
        cornerView.clipsToBounds = true
        cornerView.translatesAutoresizingMaskIntoConstraints = false
        cornerView.layer.cornerRadius = 5
        whiteView.addSubview(cornerView)
        let cnc1 = NSLayoutConstraint(item: cornerView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 15)
        let cnc2 = NSLayoutConstraint(item: cornerView, attribute: .left, relatedBy: .equal, toItem: whiteView, attribute: .left, multiplier: 1, constant: 15)
        let cnc3 = NSLayoutConstraint(item: cornerView, attribute: .right, relatedBy: .equal, toItem: whiteView, attribute: .right, multiplier: 1, constant: -15)
        let cnc4 = NSLayoutConstraint(item: cornerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250+4/UIScreen.main.scale)
        whiteView.addConstraints([cnc1, cnc2, cnc3, cnc4])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
}
