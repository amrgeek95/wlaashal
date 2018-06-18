//
//  Utitlites.swift
//  Expand
//
//  Created by amr sobhy on 10/15/17.
//  Copyright © 2017 amr sobhy. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
extension UIButton {
    
    func ButtonborderRound() {
        let myColor = UIColor.clear
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 20.0
    }
    func ButtonborderRoundradius(radius :Float) {
        let myColor = UIColor.clear
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = CGFloat(radius)
    }
    func btndropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        //  layer.shadowOffset = CGSize(width: 1, height: 1) if want to make it to right and bottom only
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3.0
        
    }
}
extension UITextField {
    func TextborderRound(corner:CGFloat = 15.0){
        let myColor = UIColor.lightGray
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = corner
    }
    func placeholderColor (){
        let color = UIColor.red
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName : color])
    }
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(hexString: "#C4C5C7").cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func setTextIcon (image:String){
        self.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: image)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        self.rightView = imageView
    }
    func setTextIconLeft (image:String){
        self.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: image)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        self.leftView = imageView
    }
}

extension UIImageView {
    func ImageBorderRadius(border:CGFloat,corner:CGFloat){
        
        self.layer.masksToBounds = true
        self.layer.borderWidth = border
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = corner
      //  self.layer.clipsToBounds = true
    }
    func ImageBorderCircle(){
        
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        //  self.layer.clipsToBounds = true
    }
}

extension UIView {
    func ViewborderRound(border:CGFloat,corner:CGFloat){
        let myColor = UIColor.clear
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = border
        self.layer.cornerRadius = corner
    }
    
    func ViewborderRoundColor(border:CGFloat,corner:CGFloat,color:UIColor = UIColor.clear){
      //  let myColor = UIColor.clear
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = border
        self.layer.cornerRadius = corner
    }
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 0.5
        
        
        
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, radius: CGFloat = 10) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 10
    }
    
}

//##f1f1f1
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension UILabel {
    
    func alignLabel() {
        self.textAlignment = NSTextAlignment.right
    }
    public var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 11)
        }
    }
}

extension UITextView {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
           // self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 13)
        }
    }
}
extension String {
    var length: Int {
        return self.characters.count
    }
}
extension UITextField {
    
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 13)
            self.autocorrectionType = .no
        }
    }
}
struct userModel {
    var firstName : String = ""
    var lastName : String = ""
    var userEmail : String = ""
    var userPassword : String = ""
    
}

extension NSURL {
    var fragments: [String: String] {
        var results = [String: String]()
        if let pairs = self.fragment?.components(separatedBy: "&"), pairs.count > 0 {
            for pair: String in pairs {
                if let keyValue = pair.components(separatedBy: "=") as [String]? {
                    results.updateValue(keyValue[1], forKey: keyValue[0])
                }
            }
        }
        return results
    }
}
/*
 func parse_text(text:String)->String{
 do{
 
 let doc: Document = try SwiftSoup.parse(text)
 return try doc.text()
 }catch Exception.Error(let type, let message){
 print(message)
 return "\(message)"
 }catch{
 print("error")
 return "error"
 }
 return "error"
 
 }
 */
func calc_sale(old:String , saving:String )->String{
    
    var sale = CGFloat(Float(old)!) - CGFloat(Float(saving)!)
    sale = ( sale / CGFloat(Float(old)!) ) * 100
    return "\(sale)"
    
}
class Utilities: NSObject {
    
    
    class func isEmailValidation(_ email:String)->Bool{
        let emailRegularExpretion = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegularExpretion)
        return emailTest.evaluate(with: email)
    }
}
class UserDataStorage: NSObject {
    
    
    class func checkUserLogin() -> Bool{
        let defaults: UserDefaults = UserDefaults.standard
        var isLogin :Bool = false
        if let checkLogin = defaults.object(forKey: "userLogin") as? Bool{
            isLogin = checkLogin
        }
        return isLogin
    }
    
    
    class func setUserLogin(isLogin: Bool){
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(isLogin, forKey: "userLogin")
        
        defaults.synchronize()
    }
    
    class func setToken(token: String){
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(token, forKey: "token")
        
        defaults.synchronize()
    }
    class func checkToken() -> Bool{
        let defaults: UserDefaults = UserDefaults.standard
        var isToken :Bool = false
        if let checktoken = defaults.object(forKey: "token") as? String{
            isToken = true
        }
        return isToken
    }
    class func getToken() -> String{
        let defaults: UserDefaults = UserDefaults.standard
        var token = ""
        if let checktoken = defaults.object(forKey: "token") as? String{
            token = checktoken
        }
        return token
    }
    
    class func saveUserData(id:String ,email:String,last:String,first:String,password:String){
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(id, forKey: "id")
        defaults.set(email, forKey: "email")
        defaults.set(last, forKey: "last")
        defaults.set(first, forKey: "first")
        defaults.set(password, forKey: "password")
        
        defaults.synchronize()
    }
    
}
extension String{
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    
    public func isPhone()->Bool {
        if self.isAllDigits() == true {
            let phoneRegex = "[235689][0-9]{6}([0-9]{3})?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return  predicate.evaluate(with: self)
        }else {
            return false
        }
    }
    
    
    private func isAllDigits()->Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.characters.count>=6 && self.characters.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    
    //for phone call
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeACall() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}


func toastView(messsage : String, view: UIView ){
    let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height / 2, width: 300,  height : 35))
    toastLabel.backgroundColor = UIColor.lightGray
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center;
    view.addSubview(toastLabel)
    toastLabel.text = messsage
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    UIView.animate(withDuration: 5.0, delay: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
        toastLabel.alpha = 0.0
        
    })
}

public class AlertFun {
    class func ShowAlert(title: String, message: String, in vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
func showAlert(messsage : String, view: UIView ){
    
}
func inputValidation(text: String,message:String ,view:UIView) -> Bool{
    
    if text.isEmpty{
        
        toastView(messsage: message, view: view)
        
        return false
    }
    
    
    return true
    
}
class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "checked")! as UIImage
    let uncheckedImage = UIImage(named: "unchecked")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}


