//
//  FileParser.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import Foundation


/// File parsing object which handles and parses the files in the file manager
public class FileParser {
    
    // MARK: Init constant vars
    struct ErrorMsgs {
        static let kFileExtensionsError = "Unable to set values for excluded file extensions"
        static let kFileManagerError = "Unable to set the specified file manager. Setting to default value..."
    }
    
    struct Constants {
        static let kSharedInstance = FileParser()
        static let kDefaultFileManager = FileManager.default
        static let kFileManagerAlreadySet = "File manager already set. Skipping procedure..."
    }
    
    // MARK: Init vars
    var excludesFilePaths: [URL]?
    var fileManager: FileManager?
    
    // MARK: "Excludes file extensions"
    var _excludesFileExtensions = [String]()
    var excludesFileExtensions: [String]? {
        get {
            return _excludesFileExtensions.map({$0.lowercased()})
        } set {
            if let newValue = newValue {
                _excludesFileExtensions = newValue
            } else {
                Log.e(withErrorMsg: ErrorMsgs.kFileExtensionsError)
            }
        }
    }
    
    
    
    // MARK: Constructors
    
    /// Default constructor
    init() {
        setDefaultFileManager()
    }
    
    
    ///
    /// Constructs a FileParser object with a specified file manager
    ///
    /// - warning: If file manager is null, will be set to default value instead
    /// - parameter newFileManager: The file manager to be assigned upon initialization
    ///
    init(withFileManager newFileManager: FileManager?) {
        setFileManager(toFileManager: newFileManager)
    }
    
    
    
    // MARK: Functions
    
    ///
    /// Retrieves the documents URL
    ///
    /// - warning: file manager must exist
    /// - returns: the documents URL
    ///
    func documentsURL() -> URL {
        if fileManager == nil {
            setDefaultFileManager()
        }
        
        return fileManager!.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    }
    
    
    ///
    /// Retrieves the files for the directory at the specified path
    ///
    /// - warning: If directory path is null, files will not be returned
    /// - parameter directoryPath: The path in which to return the desired files
    /// - returns: The specified array of files
    ///
    func filesForDirectory(_ directoryPath: URL) -> [FBFile] {
        var files = [FBFile]()
        var filePaths = [URL]()
        
        fileManager = fileManager ?? Constants.kDefaultFileManager
        
        
        // get contents
        do {
            filePaths = try self.fileManager!.contentsOfDirectory(
                at: directoryPath,
                includingPropertiesForKeys: [],
                options: [.skipsHiddenFiles]
            )
        } catch {
            return files
        }
        
        
        // Parse
        for filePath in filePaths {
            let file = FBFile(withFilePath: filePath)
            
            if let excludesFileExtensions = excludesFileExtensions, let fileExtensions = file.fileExtension, excludesFileExtensions.contains(fileExtensions) {
                continue
            }
            
            if let excludesFilePaths = excludesFilePaths, excludesFilePaths.contains(file.filePath) {
                continue
            }
            
            if !file.displayName.isEmpty {
                files.append(file)
            }
        }
        
        
        // Sort files
        return files.sorted() {
            $0.displayName < $1.displayName
        }
    }
    
    /// Assigns the file manager to the default file manager
    func setDefaultFileManager() -> Void {
        if fileManager == nil {
            setFileManager(toFileManager: Constants.kDefaultFileManager)
        } else {
            Log.d(withMessage: Constants.kFileManagerAlreadySet)
        }
    }
    
    
    ///
    /// Assigns the file manager to the specified file manager
    ///
    /// - warning: If file manager is null, will be set to default value instead
    /// - parameter newFileManager: The file manager to be assigned
    ///
    func setFileManager(toFileManager newFileManager: FileManager?) -> Void {
        if newFileManager != nil {
            fileManager = newFileManager
        } else {
            Log.e(withErrorMsg: ErrorMsgs.kFileManagerError)
            setFileManager(toFileManager: Constants.kDefaultFileManager)
        }
    }
    
    
    ///
    /// Retrieves the file manager
    ///
    /// - returns: the file manager object
    ///
    public func getFileManager() -> FileManager {
        return fileManager ?? FileManager.default
    }
    
}


