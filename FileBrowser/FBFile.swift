//
//  FBFile.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import UIKit


/// 
/// FBFile is an object containing a file within the file browser
///
open class FBFile: NSObject {
    /// Display name - String.
    open let displayName: String
    /// Is directory? - Bool.
    open let isDirectory: Bool
    /// File extension - String?
    open let fileExtension: String?
    /// File attributes (including size, creation date, etc.) - NSDictionary?
    open let fileAttributes: NSDictionary?
    /// File path - NSURL
    open let filePath: URL
    /// File type - FBFileType
    open let type: FBFileType
    
    
    ///
    /// Initializes an FBFile object with a specified filepath
    ///
    /// - parameter filePath: NSURL The user-specified filepath
    /// - returns: FBFile object
    ///
    init(withFilePath filePath: URL) {
        self.filePath = filePath
        let isDirectory = checkDirectory(atFilePath: filePath)
        self.isDirectory = isDirectory
        
        if self.isDirectory {
            self.fileAttributes = nil
            self.fileExtension = nil
            self.type = .Directory
        } else {
            self.fileAttributes = getFileAttributes(atFilePath: self.filePath)
            self.fileExtension = filePath.pathExtension
            
            if let fileExtension = fileExtension {
                self.type = FBFileType(rawValue: fileExtension) ?? .Default
            } else {
                self.type = .Default
            }
        }
        
        self.displayName = filePath.lastPathComponent
    }
}


///
/// File types enumeration
///
public enum FBFileType: String {
    /// Directory
    case Directory = "directory"
    /// GIF file
    case GIF = "gif"
    /// JPG file
    case JPG = "jpg"
    /// PLIST file
    case JSON = "json"
    /// PDF file
    case PDF = "pdf"
    /// PLIST file
    case PLIST = "plist"
    /// PNG file
    case PNG = "png"
    /// ZIP file
    case ZIP = "zip"
    /// Any file
    case Default = "file"
    
    
    ///
    /// Retrieves the representative image for the specified file type
    ///
    /// - warning: will not return an image if the file type is not supported
    /// - returns: UIImage object for the specified file type
    ///
    public func image() -> UIImage? {
        let bundle = Bundle(for: FileParser.self)
        var fileName = String()
        
        switch self {
        case .Directory:
            fileName = "folder@2x.png"
        case .JPG, .PNG, .GIF:
            fileName = "image@2x.png"
        case .PDF:
            fileName = "pdf@2x.png"
        case .ZIP:
            fileName = "zip@2x.png"
        default:
            fileName = "file@2x.png"
        }
        
        let file = UIImage(named: fileName, in: bundle, compatibleWith: nil)
        return file
    }
}


///
/// Check if file path NSURL is a valid directory or a file
///
/// - warning: the URL must be valid
/// - parameter filePath: NSURL file path
/// - returns: isDirectory. Bool.
///
func checkDirectory(atFilePath filePath: URL) -> Bool {
    var isDirectory = false
    
    do {
        var resourceValue: AnyObject?
        
        try (filePath as NSURL).getResourceValue(&resourceValue, forKey: URLResourceKey.isDirectoryKey)
        
        if let number = resourceValue as? NSNumber, number == true {
            isDirectory = true
        }
    } catch {
#if DEBUG
        Log.e(withErrorMsg: "Unable to locate the file or directory at the specified path")
#endif
    }
    
    return isDirectory
}


///
/// Retrieves the file attributes of the file at the specified path
///
/// - warning: URL must be valid
/// - parameter filePath: NSURL the specified file path
/// - returns: the attributes of the specified file
///
func getFileAttributes(atFilePath filePath: URL) -> NSDictionary? {
    let fileManager = FileParser.Constants.kSharedInstance.fileManager ?? FileManager.default
    
    do {
        let attributes = try fileManager.attributesOfItem(atPath: filePath.path) as NSDictionary
        return attributes
    } catch {
#if DEBUG
        Log.e(withErrorMsg: "Unable to locate the file or directory at the specified path")
#endif
    }
    
    return nil
}

