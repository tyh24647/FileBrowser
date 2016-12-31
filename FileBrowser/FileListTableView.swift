//
//  FileListTableView.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import UIKit


extension FileListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDatasource, UITableViewDelegate methods
    
    ///
    /// Num sections
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.isActive ? 1 : sections.count
    }
    
    
    ///
    /// Num rows in section
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredFiles.count : sections[section].count
    }
    
    
    ///
    /// Cell for row at index path method
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FileCell"
        var cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = reuseCell
        }
        
        cell.selectionStyle = .blue
        let selectedFile = fileForIndexPath(indexPath)
        cell.textLabel?.text = selectedFile.displayName
        cell.imageView?.image = selectedFile.type.image()
        return cell
    }
    
    
    ///
    /// Did select row at index path
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = fileForIndexPath(indexPath)
        searchController.isActive = false
        
        if selectedFile.isDirectory {
            let fileListViewController = FileListViewController(withInitialPath: selectedFile.filePath)
            fileListViewController.didSelectFile = didSelectFile
            self.navigationController?.pushViewController(fileListViewController, animated:true)
        } else {
            
            if let didSelectFile = didSelectFile {
                self.dismiss()
                didSelectFile(selectedFile)
            } else {
                let filePreview = previewManager.previewViewControllerForFile(selectedFile, fromNavigation: true)
                self.navigationController?.pushViewController(filePreview, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    ///
    /// Title for header in section
    ///
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive {
            return nil
        }
        
        if sections[section].count > 0 {
            return collation.sectionTitles[section]
        } else {
            return nil
        }
    }
    
    
    ///
    /// Section index titles
    ///
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return searchController.isActive ? nil : collation.sectionIndexTitles
    }
    
    
    ///
    /// Section for section index title
    ///
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return searchController.isActive ? 0 : collation.section(forSectionIndexTitle: index)
    }
}





