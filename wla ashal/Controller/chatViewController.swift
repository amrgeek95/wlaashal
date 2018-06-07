//
//  chatViewController.swift
//  Mazad
//
//  Created by amr sobhy on 5/7/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Alamofire
import MBProgressHUD
import IQKeyboardManagerSwift
class chatViewController: JSQMessagesViewController,UINavigationControllerDelegate {
    var refreshControl = UIRefreshControl()
    var msgDate = [String]()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 106/255, green: 163/255, blue: 147/255, alpha: 1.0))
    var outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(red: 106/255, green: 163/255, blue: 147/255, alpha: 1.0))
    var messages = [JSQMessage]()
    let sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    var otherId = "8"
    var chat_id = ""
    
    var otherName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        self.setupChatToolBar()
        automaticallyScrollsToMostRecentMessage = true
        reloadMessagesView()
        refreshControl.attributedTitle = NSAttributedString(string: "اسحب للتحديث")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        self.collectionView!.addSubview(refreshControl)

        // Do any additional setup after loading the view.
    }
    func newMessage(_ notification: NSNotification) {
        print()
        self.getMsgs(withLoading: false)
        
    }
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension chatViewController:UITextFieldDelegate{
    
    func setup() {
        self.senderId = userData["id"] as? String ?? ""
        self.senderDisplayName = userData["name"] as? String ?? ""
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)

    }
    func setupChatToolBar()  {
    //    self.inputToolbar.contentView.rightBarButtonItemWidth = 90
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero;
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero;
        self.inputToolbar.contentView.leftBarButtonItem = nil
          self.inputToolbar.contentView.textView.placeHolder = ""

        sendButton.setImage(UIImage(named:"send-icon.png"), for: UIControlState())
        self.inputToolbar.contentView.rightBarButtonItem.isHidden = true
        self.inputToolbar.contentView.rightBarButtonContainerView.addSubview(sendButton)
        self.inputToolbar.contentView.rightBarButtonContainerView.superview?.bringSubview(toFront: sendButton)
        
        sendButton.addTarget(self, action: #selector(chatViewController.sendPressed), for: .touchUpInside)
        self.sendButton.isEnabled = true
        
    }
    
    func textChanged(_ notification: Notification){
        if let hasText = notification.object as? NSNumber {
            if Bool(hasText) {
                self.sendButton.isEnabled = true
            }else{
                self.sendButton.isEnabled = false
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "textChanged"), object: nil)
       NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "newMessage"), object: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#394044")
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
          self.tabBarController?.tabBar.isHidden = false
        
    }
   

    func refresh(_ refreshControl: UIRefreshControl) {
        getMsgs(withLoading: true)
        // Code to refresh table view
         refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        super.viewWillAppear(true)
        print("check")
        NotificationCenter.default.addObserver(self, selector: #selector(chatViewController.textChanged(_:)), name:NSNotification.Name(rawValue: "textChanged"), object: nil)
       
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        if chat_id == "0" {
            startChat()
        }else{
         
            getMsgs(withLoading: true)
        }
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
          self.tabBarController?.tabBar.isHidden = true
    }
    
    func applicationDidBecomeActive() {
        
        print("what")
        // self.getMsgs(withLoading: false)
        // handle event
        
    }
    
    
}

extension chatViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         print("msgCountcollectionView\(self.messages.count)")
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        self.messages.remove(at: indexPath.row)
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 20.0
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
       
        let attributes : [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 10.0), NSForegroundColorAttributeName : UIColor.lightGray]

        print(msgDate)
        
        return NSAttributedString(string: msgDate[indexPath.row], attributes: attributes)

    }
    /*
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message: JSQMessage = self.messages[indexPath.item]
        
        return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
    }*/
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        if data.senderId == otherId {
            return self.incomingBubble
        }else{
         return   self.outgoingBubble
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        self.inputToolbar.contentView.textView.resignFirstResponder()
        
    }
    func sendPressed()  {
        if self.inputToolbar.contentView.textView.text.characters.count > 0 {
            
            
            self.didPressSend(self.inputToolbar.contentView.rightBarButtonItem, withMessageText: self.inputToolbar.contentView.textView.text, senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: Date())
            
            self.sendMsg(msg: messages[messages.count-1].text as AnyObject , type: "text")
            self.inputToolbar.contentView.textView.resignFirstResponder()
            self.inputToolbar.contentView.textView.text = ""
          
            
            
        }
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print("test")
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
       // message?.messageStatus = "Sending"
     msgDate.append("منذ اقل من دقيقة")
        print("test")
        self.messages.append(message!)
        print("test")
       // self.finishSendingMessage()
        print("test")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
extension chatViewController{
    
    func sendMsg(msg:AnyObject, type:String,is_url:Bool?=false ,imageDate :UIImage? = nil, media : AnyObject? = nil) {
        var parameters:[String:AnyObject] = [String:AnyObject]()
   // MBProgressHUD.showAdded(to: self.view, animated: true)
        parameters["user_id"] = userData["id"] as AnyObject?
        parameters["message"] = msg
        parameters["to_id"] = otherId as AnyObject?
        parameters["chat_id"] = chat_id as AnyObject
        print(parameters)
        
        let send_url = base_url + "send_message"
        Alamofire.request(send_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
                if let results = response.result.value as? [String:AnyObject] {
                    if let status = results["status"] as? Bool {
                        var msgParse = ["from_id":userData["id"],"to_id":self.otherId,"chat_id":1,"message":msg]
                      //  self.parseMessage(msg: msgParse as [String : AnyObject])
                        self.getMsgs(withLoading: true)
                    }
                }
            
        }
       // self.messages[self.messages.count-1].messageStatus = "Sent"
        self.collectionView.reloadData()
        
       
        
    }
    
    
    func getMsgs(withLoading:Bool)  {
        if(Reachability.isConnectedToNetwork()){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            if chat_id == "0" {
               startChat()
            return
            }
           
            var parameters:[String:AnyObject] = [String:AnyObject]()
            parameters["user_id"] = userData["id"] as AnyObject?
            parameters["to_id"] = otherId as AnyObject?
            parameters["message"] = "" as AnyObject
            parameters["chat_id"] = chat_id as AnyObject
            print("parameters\(parameters)")
            var msg_url = base_url + "get_chat_messages"
            Alamofire.request(msg_url, method: .get, parameters: parameters).responseJSON{
                (response) in
                print("chatResponse\(response)")
                 self.messages.removeAll()
                switch response.result {
                case .success:
                    print("response ygd3an \(response.result.value)")
                    if let results = response.result.value as? [String:AnyObject] {
                        if let status = results["status"] as? Bool {
                            if let chats = results["chats"] as? [[String:AnyObject]] {
                                for chat:[String:AnyObject] in chats {
                                    self.messages.append(self.parseMessage(msg: chat))
                                }
                            }
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.collectionView.reloadData()
                            self.automaticallyScrollsToMostRecentMessage = true
                            print("msgCountApi\(self.messages.count)")
                            self.finishReceivingMessage()
                            
                        }else{
                            MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }else{
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                case .failure(let error):
                    print(error)
                    self.getMsgs(withLoading: true)
                    break
                }
              
            }
            
        }
        
    }
    func startChat() {
        var parameters:[String:AnyObject] = [String:AnyObject]()
        parameters["user_id"] = userData["id"] as AnyObject?
        
        parameters["to_id"] = otherId as AnyObject?
        parameters["chat_id"] = 0 as AnyObject
        print(parameters)
        
        let send_url = base_url + "start_chat"
        Alamofire.request(send_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            if let results = response.result.value as? [String:AnyObject] {
                print(results)
                if let status = results["status"] as? Bool {
                   self.chat_id = results["chat_id"] as? String ?? ""
                    self.getMsgs(withLoading: true)
                }
            }
            
        }
    }
    
    func parseMessage(msg:[String:AnyObject]) -> JSQMessage {
        
        var from = userData["id"]
        
        var senderName = userData["name"]
        var outgoing = true
        print(otherId)
        
        if msg["from_id"] as? String ?? "" == otherId{
            senderName = otherName
            outgoing = false
            from = otherId
        }
        if var msg_text = msg["message"] as? String {
           msgDate.append(msg["date"] as? String ?? "")
            print("msgtext\(msg_text)")
           
            let message = JSQMessage(senderId: "\(from!)"  , senderDisplayName: otherName, date: Date(), text: msg_text)
            print(message)
            if let seenFlg = msg["seen"] as? Bool{
                if seenFlg == true{
                    //message?.messageStatus = "Read"
                }else{
                  //  message?.messageStatus = "Delevered"
                }
            }
            return message!
        } else{
            let message = JSQMessage(senderId: "\(from!)"  , senderDisplayName: otherName, date: Date(), text: (" " as? String)!)
            return message!
        }
    }
    
    
}
