//
//  FileListViewController.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import UIKit


///
/// The view controller for the list of files in the browser
///
class FileListViewController: UIViewController {
    
    // init IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // init vars
    var didSelectFile: ((FBFile) -> ())?
    var files = [FBFile]()
    var filteredFiles = [FBFile]()
    var initialPath: URL?
    var sections: [[FBFile]] = []
    
    // init constants
    let collation = UILocalizedIndexedCollation.current()
    let parser = FileParser.Constants.kSharedInstance
    let previewManager = PreviewManager()
    
    // init search controller
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    
    // MARK: - Constructor
    
    convenience init(withInitialPath initialPath: URL) {
        self.init(nibName: "FileBrowser", bundle: Bundle(for: FileListViewController.self))
        self.edgesForExtendedLayout = UIRectEdge()
        
        // set initial file path
        self.initialPath = initialPath
        self.title = initialPath.lastPathComponent
        
        // set search controller delegates
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        // add dismiss button
        let dismissBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FileListViewController.dismiss(button:)))
        self.navigationItem.rightBarButtonItem = dismissBtn
    }
    
    
    ///
    /// Deconstructs the file list view controller object
    ///
    deinit {
        if #available(iOS 9.0, *) {
            searchController.loadViewIfNeeded()
        } else {
            searchController.loadView()
        }
    }
    
    
    ///
    /// Dismiss function - legacy functionality from objective-c
    ///
    /// - parameter button: the button to dismiss the view controller
    ///
    @objc func dismiss(button: UIBarButtonItem = UIBarButtonItem()) {
        self.dismiss(animated: true, completion: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    ///
    /// Indexes files for quick lookup through the search bar
    ///
    func indexFiles() -> Void {
        let selector: Selector = #selector(getter: UIPrinter.displayName)
        sections = Array(repeating: [], count: collation.sectionTitles.count)
        if let sortedObjects = collation.sortedArray(from: files, collationStringSelector: selector) as? [FBFile] {
            for obj in sortedObjects {
                let sectionNum = collation.section(for: obj, collationStringSelector: selector)
                sections[sectionNum].append(obj)
            }
        }
    }
    
    
    
    func fileForIndexPath(_ indexPath: IndexPath) -> FBFile {
        return searchController.isActive ? filteredFiles[(indexPath as NSIndexPath).row] : sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
    }
    
    
    
    func filterContentForSearchText(_ searchText: String) -> Void {
        filteredFiles = files.filter({ (file: FBFile) -> Bool in
            return file.displayName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let initialPath = initialPath {
            files = parser.filesForDirectory(initialPath)
            indexFiles()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // scroll to hide the search bar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
        
        // ensure the nav bar is visible
        self.navigationController?.isNavigationBarHidden = false
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
