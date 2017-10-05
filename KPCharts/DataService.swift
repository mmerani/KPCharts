//
//  DataService.swift
//  devslopes-social
//
//  Created by Jess Rascal on 25/07/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
//let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB references
    private var _REF_BASE = DB_BASE
    private var _REF_CHARTS = DB_BASE.child("charts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage references
   // private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_CHARTS: DatabaseReference {
        return _REF_CHARTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        //let uid = KeychainWrapper.stringForKey(KEY_UID)
        //let uid = KeychainWrapper.set(KEY_UID)
       // let uid = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID)
        let uid = UserDefaults.standard.object(forKey: "uid")
        let user = REF_USERS.child(uid! as! String)
        return user
    }
    
//    var REF_POST_IMAGES: FIRStorageReference {
//        return _REF_POST_IMAGES
//    }
    
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func setChartData(chartData: Dictionary<String,Any>, completion : @escaping (_ success : Bool , _ error : NSError?) -> Void) {
       // REF_CHARTS.childByAutoId().setValue(chartData)
        REF_CHARTS.childByAutoId().setValue(chartData) { (error, snapshot) in
            if error != nil {
                print("Error saving data")
                completion(false,nil)
            } else {
                completion(true,nil)
            }
        }
    }
    
    func findUserCharts(uid: String ,completion : @escaping (_ snapshot : DataSnapshot , _ error : NSError?) -> Void) {
        let query =  REF_CHARTS.queryOrdered(byChild: "uid").queryEqual(toValue: uid)
        query.observe(.value, with: { (results) in
            completion(results,nil)
//            if results.childrenCount > 0 {
//                completion(results,nil)
//            } else {
//                completion(results,nil)
//            }
        })
    }
    
}
