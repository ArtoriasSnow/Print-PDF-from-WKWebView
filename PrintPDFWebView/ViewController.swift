//
//  ViewController.swift
//  PrintPDFWebView
//
//  Created by Peter on 30/08/15.
//  Copyright © 2015 finchapps.is. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var webView: WKWebView
    @IBOutlet weak var printButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)!
        
        self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.UIDelegate = self
        
        view.insertSubview(webView, belowSubview: progressView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)


    
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "loading") {
        }
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    
    @IBAction func loadWebpage(sender: AnyObject) {
    
        let urlString = "http://www.bbc.com/capital/story/20150828-icash-get-rich-from-the-cult-of-apple"
        let url = NSURL(string:urlString)
        let request = NSURLRequest(URL:url!)
        
        webView.loadRequest(request)
    }
    
    
    @IBAction func loadPDF(sender: AnyObject) {
        
        let urlString = "http://kmmc.in/wp-content/uploads/2014/01/lesson2.pdf"
        let url = NSURL(string:urlString)
        let request = NSURLRequest(URL:url!)
        
        webView.loadRequest(request)
    }

    @IBAction func print(sender: AnyObject) {
        
        let printController = UIPrintInteractionController.sharedPrintController()
        
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.General
        printInfo.jobName = (webView.URL?.absoluteString)!
        printInfo.duplex = UIPrintInfoDuplex.None
        printInfo.orientation = UIPrintInfoOrientation.Portrait
        
        
        //        let formatter: UIViewPrintFormatter = webView.viewPrintFormatter()
        //        formatter.contentInsets = UIEdgeInsetsZero
        //        formatter.startPage = 0
        //
        //        printController.printFormatter = formatter
        
        
        
        let renderer: UIPrintPageRenderer = UIPrintPageRenderer()
        webView.viewPrintFormatter().printPageRenderer?.headerHeight = 30.0
        webView.viewPrintFormatter().printPageRenderer?.footerHeight = 30.0
        webView.viewPrintFormatter().contentInsets = UIEdgeInsetsMake(0, 30, 0, 30)
        webView.viewPrintFormatter().startPage = 0
        
        renderer.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAtIndex: 0)
        
        printController.printPageRenderer = renderer
        
        
        printController.printInfo = printInfo
        printController.showsPageRange = true
        printController.showsNumberOfCopies = true
        
        printController.presentFromBarButtonItem(printButton, animated: true, completionHandler: nil)
    }

}

