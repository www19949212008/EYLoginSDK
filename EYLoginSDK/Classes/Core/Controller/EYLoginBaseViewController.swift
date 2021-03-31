//
//  EYLoginBaseViewController.swift
//  EYLoginSDK
//
//  Created by eric on 2021/3/20.
//

import UIKit

class EYLoginBaseViewController: UIViewController {
    var titleString: String {
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.text = titleString
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleConstrait1 = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let titleConstrait2 = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 25 + UIApplication.shared.statusBarFrame.height)
        view.addConstraints([titleConstrait1, titleConstrait2])
        
        let remindLabel = UILabel()
        remindLabel.textColor = UIColor.lightGray
        remindLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(remindLabel)
        remindLabel.text = "《健康游戏忠告》：抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防上当受骗。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。"
        view.addSubview(remindLabel)
        remindLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(remindLabel)
        remindLabel.numberOfLines = 0
        let remindConstrait1 = NSLayoutConstraint(item: remindLabel, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 15)
        let remindConstrait2 = NSLayoutConstraint(item: remindLabel, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -15)
        let remindConstrait3 = NSLayoutConstraint(item: remindLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -20)
        view.addConstraints([remindConstrait1, remindConstrait2, remindConstrait3])
    }
    
    func createTextField(placeHold: String) -> UITextField {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 45))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = placeHold
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1/UIScreen.main.scale
        textField.layer.borderColor = UIColor.black.cgColor
        textField.tintColor = UIColor.black
        return textField
    }
    
    func createOrangeButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = buttonThemeColorNormol
        button.layer.cornerRadius = 20
        return button
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
