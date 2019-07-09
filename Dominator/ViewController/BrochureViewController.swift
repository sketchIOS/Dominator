//
//  BrochureViewController.swift
//  Dominator
//
//  Created by IOS DEVELOPER on 30/01/19.
//  Copyright © 2019 SketchWebSolutions. All rights reserved.
//

import UIKit
import WebKit

class BrochureViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var brochureLink = "https://www.dominatorsafes.com.au"

    let customIndicator = Indicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: URL(string: brochureLink)!)
        webView.navigationDelegate = self
        webView?.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func callDominatorAction(_ sender: Any) {
        // "+1-(800)-123-4567".makeAColl()
        "1300 366 462".makeACall()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        self.customIndicator.showIdicator(viewcontroller: self)
        self.customIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        self.customIndicator.stopAnimating()
        self.customIndicator.removeFromSuperview()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
        toastView(messsage: error.localizedDescription, view: self.view)
        self.customIndicator.stopAnimating()
        self.customIndicator.removeFromSuperview()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(#function)
        toastView(messsage: error.localizedDescription, view: self.view)
        self.customIndicator.stopAnimating()
        self.customIndicator.removeFromSuperview()
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
