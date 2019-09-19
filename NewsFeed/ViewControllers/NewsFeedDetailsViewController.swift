//
//  NewsFeedDetailsViewController.swift
//  NewsFeed
//
//  Created by Gamenexa_iOS3 on 18/09/19.
//  Copyright © 2019 Gamenexa_iOS3. All rights reserved.
//

import UIKit
import WebKit

class NewsFeedDetailsViewController: UIViewController {

    var news : NewsFeed?
   var wkWebView = WKWebView()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        wkWebView.frame = self.view.frame
        self.view.addSubview(wkWebView)
        
        wkWebView.navigationDelegate = self
        self.view.bringSubviewToFront(self.spinner)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.spinner.startAnimating()
       wkWebView.load(NSURLRequest(url: NSURL(string: news!.article_url!)! as URL) as URLRequest)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsFeedDetailsViewController: WKNavigationDelegate {
 
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        print("=== didFailProvisionalNavigation ===", error.localizedDescription )
    }
    
    
    /*! @abstract Invoked when content starts arriving for the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("=== didCommit navigation ===")
    }
    
    
    /*! @abstract Invoked when a main frame navigation completes.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
        print("=== didFinish navigation ===")
       // self.spinner.stopAnimating()
    }
}
