//
//  EYNotificationControllerViewController.swift
//  EYLoginSDK
//
//  Created by eric on 2021/9/23.
//

import UIKit

class EYNotificationController: UIViewController {
    let scrollView = UIScrollView()
    let contentLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "防沉迷通知"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(self.close))
//        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
        setupUI()
    }
    

    @objc
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        EYLoginSDKManager.shared().showingVc = nil
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        titleLabel.text = "国家新闻出版署关于进一步严格管理切实防止未成年人沉迷网络游戏的通知"
        scrollView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        let tc1 = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 20)
        let tc2 = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 15)
        let tc3 = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width - 30)
        scrollView.addConstraints([tc1, tc2, tc3])
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.numberOfLines = 0
        contentLabel.text = "       各省、自治区、直辖市新闻出版局，各网络游戏企业，有关行业组织：\n       一段时间以来，未成年人过度使用甚至沉迷网络游戏问题突出，对正常生活学习和健康成长造成不良影响，社会各方面特别是广大家长反映强烈。为进一步严格管理措施，坚决防止未成年人沉迷网络游戏，切实保护未成年人身心健康，现将有关要求通知如下。\n        一、严格限制向未成年人提供网络游戏服务的时间。自本通知施行之日起，所有网络游戏企业仅可在周五、周六、周日和法定节假日每日20时至21时向未成年人提供1小时网络游戏服务，其他时间均不得以任何形式向未成年人提供网络游戏服务。\n        二、严格落实网络游戏用户账号实名注册和登录要求。所有网络游戏必须接入国家新闻出版署网络游戏防沉迷实名验证系统，所有网络游戏用户必须使用真实有效身份信息进行游戏账号注册并登录网络游戏，网络游戏企业不得以任何形式（含游客体验模式）向未实名注册和登录的用户提供游戏服务。\n      三、各级出版管理部门加强对网络游戏企业落实提供网络游戏服务时段时长、实名注册和登录、规范付费等情况的监督检查，加大检查频次和力度，对未严格落实的网络游戏企业，依法依规严肃处理。\n      四、积极引导家庭、学校等社会各方面营造有利于未成年人健康成长的良好环境，依法履行未成年人监护职责，加强未成年人网络素养教育，在未成年人使用网络游戏时督促其以真实身份验证，严格执行未成年人使用网络游戏时段时长规定，引导未成年人形成良好的网络使用习惯，防止未成年人沉迷网络游戏。\n     五、本通知所称未成年人是指未满18周岁的公民，所称网络游戏企业含提供网络游戏服务的平台。\n      本通知自2021年9月1日起施行。《国家新闻出版署关于防止未成年人沉迷网络游戏工作的通知》（国新出发〔2019〕34号）相关规定与本通知不一致的，以本通知为准。"
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        scrollView.addSubview(contentLabel)
        let cc1 = NSLayoutConstraint(item: contentLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 15)
        let cc2 = NSLayoutConstraint(item: contentLabel, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 15)
        let cc3 = NSLayoutConstraint(item: contentLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width - 30)
        scrollView.addConstraints([cc1, cc2, cc3])
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: 0, height: contentLabel.frame.maxY + 15)
    }
}
