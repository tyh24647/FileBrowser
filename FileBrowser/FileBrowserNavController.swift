//
//  FileBrowserNavController.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import UIKit


/// 
/// The file browser navigation controller
///
open class FileBrowserNavController: UINavigationController {
    // MARK: - Constant vars
    let parser = FileParser.Constants.kSharedInstance
    
    // MARK: - Init vars
    var fileList: FileListViewController?

    
    // MARK: - Constructors
    
    ///
    /// Initializes to the documents folder
    ///
    /// - returns: The file browser view controller instance
    ///
    public convenience init() {
        let parser = FileParser.Constants.kSharedInstance
        let path = parser.documentsURL()
        self.init(initialPath: path as URL)
    }
    
    
    ///
    /// Initializes to a custom directory path
    ///
    /// - parameter initialDirPath: NSURL - Initial filepath to the specified directory
    ///
    /// - returns: The file browser view controller instance
    ///
    public convenience init(initialPath: URL) {
        let fileListViewController = FileListViewController(withInitialPath: initialPath)
        self.init(rootViewController: fileListViewController)
        self.view.backgroundColor = UIColor.white
        self.fileList = fileListViewController
    }
}
