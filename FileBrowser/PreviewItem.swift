//
//  PreviewItem.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import Foundation
import QuickLook


///
/// Data object which contains the item to be viewed. This is managed
/// using the 'PreviewManager.swift' object in the 'Utils' group (see for usage)
///
class PreviewItem: NSObject, QLPreviewItem {
    
    /*!
     * @abstract The URL of the item to preview.
     * @discussion The URL must be a file URL.
     */
    
    var filePath: URL?
    
    public var previewItemURL: URL? {
        if let filePath = filePath {
            return filePath
        }
        
        return nil
    }
    
    
}
