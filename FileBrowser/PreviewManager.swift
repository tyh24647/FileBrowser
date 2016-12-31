//
//  PreviewManager.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import UIKit
import QuickLook


///
/// Manager for the previews of files
///
class PreviewManager: NSObject, QLPreviewControllerDataSource {
    // MARK: - init vars
    var filePath: URL?
    
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let item = PreviewItem()
        
        if let filePath = filePath {
            item.filePath = filePath
        }
        
        return item
    }
    
    ///
    /// Returns the UIViewController object to display the preview
    /// of the specified file
    ///
    /// - warning: file parameters must not be nil
    /// - parameters:
    ///     - file: The file to preview
    ///     - fromNavigation: Whether or not the preview comes from navigation
    /// - returns: The instance of the UIViewController object that is specific
    /// to the specified file
    ///
    func previewViewControllerForFile(_ file: FBFile, fromNavigation: Bool) -> UIViewController {
        
        // check for plist or json
        if file.type == .PLIST || file.type == .JSON {
            let webviewPreviewViewContoller = WebviewPreviewViewController(
                nibName: "WebviewPreviewViewContoller",
                bundle: Bundle(for: WebviewPreviewViewController.self)
            );
            
            webviewPreviewViewContoller.file = file
            return webviewPreviewViewContoller
        } else {
            let previewTransitionViewController = PreviewTransitionViewController(nibName: "PreviewTransitionViewController", bundle: Bundle(for: PreviewTransitionViewController.self))
            
            previewTransitionViewController.quickLookPreviewController.dataSource = self
            self.filePath = file.filePath as URL
            
            if fromNavigation {
                return previewTransitionViewController.quickLookPreviewController
            }
            
            return previewTransitionViewController
        }
    }
    
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
}


