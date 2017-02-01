//
//  WebViewController.swift
//  BenYelpApp
//
//  Created by Ben Miller on 2017-02-01.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlToLoad: String?
    
    override func loadView() {
        
        print("url is:  \(urlToLoad!)")
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard urlToLoad != nil && urlToLoad != "" else { return }
        
        let url = URL(string: urlToLoad!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    
}
