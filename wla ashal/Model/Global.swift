
import Foundation
import UIKit
func saveUserData(userData : [String:AnyObject]) {
    
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: userData)
    
    UserDefaults.standard.set(encodedData, forKey: "userData")
    
    UserDefaults.standard.synchronize()
}
func loadUserData() ->AnyObject {
    
    // retrieving a value for a key
    if let data = UserDefaults.standard.data(forKey: "userData") {
        let user_Data = NSKeyedUnarchiver.unarchiveObject(with: data)
        userData = user_Data as! [String : Any]
    } else {
        userData = [:]
    }
    
    if let checkData =  UserDefaults.standard.value(forKey: "userData") as? AnyObject  {
        
        return checkData
    }else{
        return false as AnyObject
    }
    
}
func checkUserData () ->Bool {
    if let data =  UserDefaults.standard.data(forKey: "userData")   {
        
        let checkData = NSKeyedUnarchiver.unarchiveObject(with: data)
        print(checkData)
        if let check = checkData as? [String:AnyObject] {
            return true
        }else{
            return false
        }
        
        
    }else{
        return false
    }
}
func removeUserData(){
    let defaults: UserDefaults = UserDefaults.standard
    defaults.removeObject(forKey: "userData")
    defaults.synchronize()
}


//save data for driver
func saveData(name:String){
    UserDefaults.standard.set(true, forKey: name)
    
    UserDefaults.standard.synchronize()
}
func checkData (name:String) ->Bool {
    if let data =  UserDefaults.standard.value(forKey: name)   {
        print(data)
        
        if data as? Bool == true {
            if name == "taxi"{
                isTaxi = true
            }
            else if name == "delivery" {
                isDelivery = true
            }
            return true
        }else{
            return false
        }
    }else{
        return false
    }
}
func removeData(name:String){
    let defaults: UserDefaults = UserDefaults.standard
    defaults.removeObject(forKey:name)
    defaults.synchronize()
}
