//
//  ViewController.swift
//  Language
//
//  Created by Starlueng on 2017/10/10.
//  Copyright © 2017年 梁书洋. All rights reserved.
//

import UIKit
 func localizedFromTable(key:String,tableName:String) -> String {
    
    return Bundle.currentLanguage().localizedString(forKey: key, value: key, table: tableName)
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
       
//        [LanguageManager setupCurrentLanguage];
//        [LanguageManager saveLanguageByCode:@"zh-Hans"];
        let button = UIButton.init(type: .system)
        
        button.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        let s = localizedFromTable(key: "点击", tableName: "newSetting")
        button.setTitle(s, for: .normal)
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(ViewController.changes(button:)), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func changes(button:UIButton) -> Void {
        let s = localizedFromTable(key: "点击", tableName: "newSetting")
        button.setTitle(s, for: .normal)
       let string =  LanguageManager.currentLanguageCode()
        
        if string == "en" {
             LanguageManager.saveLanguageByCode(code: "zh-Hans")
        }else{
            
            LanguageManager.saveLanguageByCode(code: "en")
        }
        //重新设置root viewcontroller，重新加载时会加载切换后的语言资源
  
        let appdelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate .reloadViewCS()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

