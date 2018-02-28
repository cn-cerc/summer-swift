//
//  LoginViewController.swift
//  summer
//
//  Created by 王雨 on 2018/2/26.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import UIKit

let Margin : CGFloat = 30
class LoginViewController : UIViewController {
    var bgImgView : UIImageView?
    var logoImgView : UIImageView?
    var accountView : UIView?
    var accountImgView : UIImageView?
    var pwdImgView : UIImageView?
    var accountTF : UITextField?
    var pwdTF : UITextField?
    var selectedServer : NSInteger?
    var selectServerBtn : UIButton?
    var remeberPwdBtn : UIButton?
    var signBtn : UIButton?
    var isRemeberPwd : Bool?//是否记住密码
    var accounts : [String]? = [String]()
    var pwds : [String]? = [String]()
    var dropdownMenu : LMJDropdownMenu?
    
    lazy var servers : [String] = {
        let arr = ["香港","北京","伦敦"]
        return arr
    }()
    override func viewDidLoad() {
        isRemeberPwd = true
        selectedServer = UserDefaultsUtils.intValueWithKey(key: "selectedServer")
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //读取本地存储的账号
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = (filePath as NSString).appendingPathComponent("LoginAccount.plist")
        let results = NSArray(contentsOfFile: path)
        if results != nil {
            for dic in results! {
                let dict = dic as! NSDictionary
                accounts?.append(dict["account"]! as! String)
                pwds?.append(dict["password"]! as! String)
            }
            let lastDic = results?.lastObject as! NSDictionary
            let account = lastDic["account"] as! String
            if (account.count != 0) {
                accountTF?.text = account
            }
            let pwd = lastDic["password"] as! String
            if pwd.count != 0 {
                pwdTF?.text = pwd
            }
        }
        if accounts != nil {
            //账户的下拉列表的数据源
            dropdownMenu?.setMenuTitles(accounts!, rowHeight: 35)
            dropdownMenu?.delegate = self
        }
    }
}
extension LoginViewController {
    func setupUI() {
        //背景图片
        bgImgView = UIImageView.init(frame: view.frame)
        bgImgView?.image = UIImage.init(named: "login_bg")
        view.addSubview(bgImgView!)
        //logo图片
        logoImgView = UIImageView.init(frame: CGRect(x: SCREEN_WIDTH/2-45, y: 100, width: 90, height: 90))
        logoImgView?.image = UIImage.init(named: "logo")
        view.addSubview(logoImgView!)
        //账户的下拉列表
        dropdownMenu = LMJDropdownMenu.init(frame: CGRect(x: Margin, y: (logoImgView?.frame.maxY)! + 50, width: SCREEN_WIDTH - 2 * Margin, height: 45))
        dropdownMenu?.backgroundColor = UIColor.init(white: 1.0, alpha: 0.3)
        dropdownMenu?.layer.cornerRadius = 5
        dropdownMenu?.layer.masksToBounds = true
        view.addSubview(dropdownMenu!)
        //账户输入框
        accountView = UIView.init(frame: CGRect(x: Margin, y: (logoImgView?.frame.maxY)! + 50, width: SCREEN_WIDTH - 2 * Margin - 30, height: 45))
        accountView?.backgroundColor = UIColor.clear
        view.addSubview(accountView!)
        
        accountImgView = UIImageView.init(frame: CGRect(x: 12.5, y:12.5, width: 20, height: 20))
        accountImgView?.image = UIImage.init(named: "login_account")
        accountView?.addSubview(accountImgView!)
        
        let accountTFWidth = SCREEN_WIDTH - 2 * Margin - 32.5 - 10
        accountTF = UITextField.init(frame: CGRect(x: (accountImgView?.frame.maxX)!+10, y: 7.5, width: accountTFWidth - 30, height: 30))
        accountTF?.placeholder = "请输入您的账号"
        accountTF?.font = UIFont.systemFont(ofSize: 14)
        accountTF?.tintColor = UIColor.white
        accountView?.addSubview(accountTF!)
   
        //密码输入框
        let pwdView = UIView.init(frame: CGRect(x: Margin, y: (accountView?.frame.maxY)! + 15, width: SCREEN_WIDTH - 2 * Margin, height: 45))
        pwdView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.3)
        pwdView.layer.cornerRadius = 5
        pwdView.layer.masksToBounds = true
        view.addSubview(pwdView)
        pwdImgView = UIImageView.init(frame: CGRect(x: 12.5, y: 12.5, width: 20, height: 20))
        pwdImgView?.image = UIImage.init(named: "login_pwd")
        pwdView.addSubview(pwdImgView!)
        pwdTF = UITextField.init(frame: CGRect(x: (pwdImgView?.frame.maxX)!+10, y: 7.5, width: accountTFWidth, height: 30))
        pwdTF?.isSecureTextEntry = true
        pwdTF?.placeholder = "请输入您的密码"
        pwdTF?.font = UIFont.systemFont(ofSize: 14)
        pwdTF?.tintColor = UIColor.white
        pwdView.addSubview(pwdTF!)
        
        //选择服务器
        selectServerBtn = UIButton.init(type: .custom)
        selectServerBtn?.frame = CGRect(x: Margin, y: pwdView.frame.maxY + 10, width: SCREEN_WIDTH - 2 * Margin, height: 30)
        selectServerBtn?.setTitleColor(UIColor.white, for: .normal)
        selectServerBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        selectServerBtn?.setTitle("登录主机:\(self.servers[selectedServer!])  >", for: .normal)
        selectServerBtn?.setTitle("\(self.servers[selectedServer!])  >", for: .selected)
        selectServerBtn?.sizeToFit()
        selectServerBtn?.addTarget(self, action: #selector(selectServer), for: .touchUpInside)
        selectServerBtn?.titleLabel?.textAlignment = .left
        view.addSubview(selectServerBtn!)
        
        //记住密码按钮
        remeberPwdBtn = UIButton.init(type: .custom)
        remeberPwdBtn?.frame = CGRect(x: SCREEN_WIDTH-Margin-70, y: (selectServerBtn?.frame.maxY)! + 10, width: 15, height: 15)
        remeberPwdBtn?.setImage(UIImage.init(named: "login_remeber"), for: .normal)
        remeberPwdBtn?.setImage(UIImage.init(named: "login_not_remeber"), for: .selected)
        remeberPwdBtn?.addTarget(self, action: #selector(remeberPwd), for: .touchUpInside)
        view.addSubview(remeberPwdBtn!)
        let remeberLbl = UILabel.init(frame: CGRect(x: (remeberPwdBtn?.frame.maxX)!, y: (remeberPwdBtn?.frame.origin.y)!-3, width: 55, height: 20))
        remeberLbl.text = "记住密码"
        remeberLbl.font = UIFont.systemFont(ofSize: 12)
        remeberLbl.textColor = UIColor.white
        view.addSubview(remeberLbl)
        //登录按钮
        signBtn = UIButton.init(type: .custom)
        signBtn?.frame = CGRect(x: Margin, y: remeberLbl.frame.maxY + 15, width: SCREEN_WIDTH - 2 * Margin, height: 45)
        signBtn?.backgroundColor = UIColor.green
        signBtn?.setTitle("登录", for: .normal)
        signBtn?.setTitleColor(UIColor.white, for: .normal)
        signBtn?.addTarget(self, action: #selector(login), for: .touchUpInside)
        signBtn?.layer.cornerRadius = 5
        signBtn?.layer.masksToBounds = true
        view.addSubview(signBtn!)
        
        //底部可点击的提示语
        let textView = UITextView.init()
        textView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 50, width: SCREEN_WIDTH, height: 30)
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.delegate = self
        view.addSubview(textView)
        
        let contentStr = "如有疑问请 联系客服"
        let range = (contentStr as NSString).range(of: "如有疑问请")
        let range1 = (contentStr as NSString).range(of: "联系客服")
    
        let attrStr = NSMutableAttributedString(string: contentStr)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, contentStr.count-1))// 添加对齐方式
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(white: 1.0, alpha: 0.7), range: range)
        attrStr.addAttribute(NSLinkAttributeName, value: "contact://", range: range1)
        textView.attributedText = attrStr
        textView.linkTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }


}
extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        accountTF?.resignFirstResponder()
        pwdTF?.resignFirstResponder()
    }
}
//MARK: - Action
extension LoginViewController {
    //选择服务器
    func selectServer() {
        selectServerBtn?.isSelected = true
        YBPickerTool.show([self.servers], didSelect: { (indexPath) in
            self.selectServerBtn?.isSelected = false
            var index = indexPath?.row
            if indexPath == nil {
                index = self.selectedServer
                
            }
            self.selectedServer = index
            self.selectServerBtn?.setTitle("登录主机:\(self.servers[index!])  >", for: .normal)
            if index == 0 {
                
            } else if index == 1 {
                
            } else {
                
            }
        }) {
            self.selectServerBtn?.isSelected = false
            self.selectServerBtn?.setTitle("登录主机:\(self.servers[self.selectedServer!])  >", for: .normal)
        }
    }
    //记住密码
    func remeberPwd() {
        remeberPwdBtn?.isSelected = !(remeberPwdBtn?.isSelected)!
        isRemeberPwd = !(remeberPwdBtn?.isSelected)!
    }
    //登录
    func login() {
        //判断输入为空
        guard accountTF?.text != nil else {return}
        guard pwdTF?.text != nil else {return}
        //登录接口判断登录成功之后
        let mainVC = MainViewController()
        let mainNav = BaseNavViewController(rootViewController:mainVC)
        UIApplication.shared.keyWindow?.rootViewController = mainNav
        
        UserDefaultsUtils.saveIntValue(value: selectedServer!, key: "selectedServer")
        //将登录的账号存入本地的plist文件
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = (filePath as NSString).appendingPathComponent("LoginAccount.plist")
      
        let results = NSArray(contentsOfFile: path)
        var tmpArr = NSMutableArray.init()
        if results != nil {
            tmpArr = NSMutableArray(array: results!)
        }
        if tmpArr.contains(["account" : accountTF?.text, "password" : pwdTF?.text]) == false {
            tmpArr.add(["account" : accountTF?.text, "password" : pwdTF?.text])
        }
        tmpArr.write(toFile: path, atomically: true)
        
    }
}
extension LoginViewController : LMJDropdownMenuDelegate {
    func dropdownMenu(_ menu: LMJDropdownMenu!, selectedCellNumber number: Int) {
        accountTF?.text = accounts?[number]
        pwdTF?.text = pwds?[number]
    }
}
//MARK: - 点击联系客服
extension LoginViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "contact" {
            print("联系客服")
            return false
        }
        return true
    }
}

