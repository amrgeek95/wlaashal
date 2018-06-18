//
//  webViewController.swift
//  Expand
//
//  Created by amr sobhy on 12/9/17.
//  Copyright © 2017 amr sobhy. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD
class webViewController: SuperParentViewController , WKNavigationDelegate{
    var webView : WKWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var payment = 0
    var  myBlog  = base_url + "webview"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        // Do any additional setup after loading the view.
    }
    //MARK:- WKNavigationDelegate
    override func viewWillAppear(_ animated: Bool) {
        
        
        print(myBlog)
        
        print("checkouturl")
        self.navigationItem.title = staticNavigation
        let url = NSURL(string: myBlog)
        let request = NSURLRequest(url: url! as URL)
        
        // init and load request in webview.
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#21A6DF")
    }
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activity.startAnimating()
        activity.isHidden = false
        
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.stopAnimating()
        activity.hidesWhenStopped = true
        activity.isHidden = true
    }
    @IBOutlet weak var webkit: WKWebView!
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

