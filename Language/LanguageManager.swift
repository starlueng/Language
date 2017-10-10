//
//  LanguageManager.swift
//  Language
//
//  Created by Starlueng on 2017/10/10.
//  Copyright © 2017年 梁书洋. All rights reserved.
//

import UIKit

enum LaunguageSet {
    
    case English ;
    
    case SimplifiedChinese
}

class LanguageManager: NSObject {
    
    static let languageCodes = ["en" , "zh-Hans"]
    
    static let languageStrings = ["English","Simplified Chinese"]
    
    static let languageSaveKey = "userLanguage"
    
    class func setupCurrentLanguage(){
        
        var currentLanguage :String? = UserDefaults.standard.object(forKey: LanguageManager.languageSaveKey) as? String
        
        if currentLanguage == nil {
            let languages :[String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
            
            if (languages.count > 0){
                currentLanguage = languages.first
                //保存数据
                UserDefaults.standard.set(currentLanguage, forKey: LanguageManager.languageSaveKey)
                
                UserDefaults.standard.synchronize()
            }
          
        }
        //保存数据
        UserDefaults.standard.set([currentLanguage], forKey: "AppleLanguages")
        
        UserDefaults.standard.synchronize()
//        Bundle.setLanguage(launguage: currentLanguage)
    }
    
    class func LanguageStrings() -> [String]{
        
        return LanguageManager.languageStrings
    }
    
    class func currentLanguageString() -> String{
        
        let currentCode :String? = UserDefaults.standard.object(forKey: LanguageManager.languageSaveKey) as? String
        
        for item in 0 ..< LanguageManager.languageCodes.count {
            let itemCode = LanguageManager.languageCodes[item]
            if  itemCode == currentCode {
                
                return NSLocalizedString(languageStrings[item], comment: "")
            }
        }
        
        return ""
    }
    
    class func currentLanguageCode() -> String? {
        
        return UserDefaults.standard.object(forKey: LanguageManager.languageSaveKey) as? String
    }
    
    class func currentLanguageIndex() -> Int {
        
        let currentCode :String? = UserDefaults.standard.object(forKey: LanguageManager.languageSaveKey) as? String
        
        for item in 0 ..< LanguageManager.languageCodes.count {
            let itemCode = LanguageManager.languageCodes[item]
            if  itemCode == currentCode {
                
                return item
            }
        }
        
        return 0
    }
    
    class func saveLanguageByIndex(index:Int){
        
        if index >= 0 && index < LanguageManager.languageCodes.count {
            let code = LanguageManager.languageCodes[index]
            
            UserDefaults.standard.set(code, forKey: LanguageManager.languageSaveKey)
            UserDefaults.standard.synchronize()
           _ =  Bundle.setLanguage(launguage: code)
        }
    }
    class func saveLanguageByCode (code:String) {
        
        for item in 0 ..< LanguageManager.languageCodes.count {
            let itemCode = LanguageManager.languageCodes[item]
            if  itemCode == code {
                
                saveLanguageByIndex(index: item)
                break;
            }
        }
    }
    
    class func isCurrentLanguageRTL() -> Bool{
        
        let currentLanguageIndex = self.currentLanguageIndex()
        
        let locale = NSLocale.characterDirection(forLanguage: languageCodes[currentLanguageIndex])
        
        return locale == .rightToLeft
    }
}

class BundleEx: Bundle {
    
    static var  kBundleKey  = "bundleKey"
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String{
        
        let associateBundle = objc_getAssociatedObject(self, &(BundleEx.kBundleKey)) as? Bundle
        if associateBundle != nil {
            
            let string = associateBundle?.localizedString(forKey: key, value: value, table: tableName)
            return string!
        }else{
            let string = super.localizedString(forKey: key, value: value, table: tableName)
            return string
            
        }
        
    }
}

private var onceAction = true

extension Bundle {
    
    class  func setLanguage(launguage:String?) ->Bundle?{
        
        if onceAction {
            
            _ = object_setClass(Bundle.main, BundleEx.self)
            onceAction = false
        }
        
        if #available(iOS 9.0, *) {
            if LanguageManager.isCurrentLanguageRTL()  {
                
                if (UIView.responds(to: #selector(setter: UIView.semanticContentAttribute))){
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    
                }
            }else{
                if (UIView.responds(to: #selector(setter: UIView.semanticContentAttribute))){
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    
                }
                
            }
        }
        UserDefaults.standard.set(LanguageManager.isCurrentLanguageRTL(), forKey: "AppleTextDirection")
        UserDefaults.standard.set(LanguageManager.isCurrentLanguageRTL(), forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.synchronize()
        
        var value : Bundle?
        if launguage != nil {
            value = Bundle.init(path: Bundle.main.path(forResource: launguage, ofType: "lproj")!)
        }
        objc_setAssociatedObject(Bundle.main, BundleEx.kBundleKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return value

    }
    
    class func currentLanguage() -> Bundle{
        
        let language = LanguageManager.currentLanguageCode()
        let newBundle = Bundle.init(path: Bundle.main.path(forResource: language, ofType: "lproj")!)
        return newBundle!
    }
}
