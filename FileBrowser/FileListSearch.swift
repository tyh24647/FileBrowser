//
//  FileListSearch.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import UIKit

extension FileListViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    // MARK: - UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController) {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
    
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
