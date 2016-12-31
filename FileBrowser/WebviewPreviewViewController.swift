//
//  WebviewPreviewViewController.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import UIKit
import WebKit


///
/// The WebView object which renders items that QuickLook cannot display
///
class WebviewPreviewViewController: UIViewController {
    // MARK: - Init vars
    var webView = WKWebView()
    
    // file to display
    var file: FBFile? {
        didSet {
            self.title = file?.displayName
            self.processForDisplay()
        }
    }
    
    
    // MARK: - Sharing
    
    ///
    /// Accesses the 'share' menu allowing for the user to share the file
    /// with the applicable applications
    ///
    func shareFile() -> Void {
        guard let file = file else {
            return
        }
        
        // set activity options view controller - pulls up appropriate ones for filetype
        let activityViewController = UIActivityViewController(activityItems: [file.filePath], applicationActivities: nil)
        
        // present activity view controller
        self.present(activityViewController, animated: true, completion: {
                        self.view.layoutIfNeeded()
        })
    }
    
    
    // MARK: - Processing
    
    ///
    /// Processes the selected file in order to display the file's contents
    /// properly within the webview object
    ///
    func processForDisplay() -> Void {
        guard let file = file, let data = try? Data(contentsOf: file.filePath as URL) else {
            return
        }
        
        var rawStr: String?
        
        // prepare for plist or JSON
        if file.type == .PLIST {
            do {
                if let plistDescription = try (PropertyListSerialization.propertyList(from: data, options: [], format: nil) as AnyObject).description {
                    rawStr = plistDescription
                }
            } catch {
#if DEBUG
                Log.e(withErrorMsg: "Error processing property list file.")
#endif
            }
        } else if file.type == .JSON {
            do {
                // serialize JSON
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                // Return raw JSON string
                if JSONSerialization.isValidJSONObject(jsonObject) {
                    let formattedJSON = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    var jsonStr = String(data: formattedJSON, encoding: String.Encoding.utf8)
                    
                    // unescape forward slashes (preventing parsing errors)
                    jsonStr = jsonStr?.replacingOccurrences(of: "\\/", with: "/")
                    rawStr = jsonStr
                }
            } catch {
#if DEBUG
                Log.e(withErrorMsg: "Error processing JSON data")
#endif
            }
        }
        
        // default
        if rawStr == nil {
            rawStr = String(data: data, encoding: String.Encoding.utf8)
        }
        
        // convert and display string if HTML
        if let convertedStr = convertSpecialChars(ofString: rawStr) {
            let htmlStr = "<html><head><meta name='viewport' content='initial-scale=1.0, user-scalable=no'></head><body><pre>\(convertedStr)</pre></body></html>"
            
            // load HTML into web view
            webView.loadHTMLString(htmlStr, baseURL: nil)
        }
    }
    
    ///
    /// Converts special characters from HTML, XML, etc
    ///
    /// - warning: may not be the best option for some file types
    /// - parameter string: String - The string in which to convert
    /// - returns: The converted string with the proper formatting
    ///
    func convertSpecialChars(ofString string: String?) -> String? {
        guard let string = string else {
            return nil
        }
        
        var str = string
        
        let charDict = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'"
        ]
        
        for (escapedChar, unescapedChar) in charDict {
            str = str.replacingOccurrences(
                of: escapedChar,
                with: unescapedChar,
                options: NSString.CompareOptions.regularExpression,
                range: nil
            )
        }
        
        return str
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        
        // Add share button
        let shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(WebviewPreviewViewController.shareFile))
        self.navigationItem.rightBarButtonItem = shareBtn
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = self.view.bounds
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
