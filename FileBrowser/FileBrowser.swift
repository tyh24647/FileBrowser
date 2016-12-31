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
open class FileBrowser: UINavigationController {
    // init parser from shared instance
    let parser = FileParser.Constants.kSharedInstance
    // create container for the files list
    var fileList: FileListViewController?

    
    // MARK: - File types to exclude from the file browser
    
    /// Types to exclude from the file browser
    open var excludesFileExtensions: [String]? {
        didSet {
            parser.excludesFileExtensions = excludesFileExtensions
        }
    }
    
    /// Paths to exclude from the file browser
    open var excludesFilePaths: [URL]? {
        didSet {
            parser.excludesFilePaths = excludesFilePaths
        }
    }
    
    /// Overrides the default preview/actionsheet behavior in favor of custom file heading
    open var didSelectFile: ((FBFile) -> ())? {
        didSet {
            fileList?.didSelectFile = didSelectFile
        }
    }
    
    
    
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
