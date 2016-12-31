//
//  Log.swift
//  FileBrowser
//
//  Created by Tyler hostager on 12/31/16.
//  Copyright © 2016 Tyler Hostager. All rights reserved.
//

import Foundation


/// Logger object to write data to the console
public class Log {
    
    init() {
        
    }
    
    static func d(withMessage message: String) -> Void {
        if message.isEmpty || message == "" {
            return
        }
        
        print("> " + message)
    }
    
    static func e(withErrorMsg errorMsg: String) -> Void {
        if errorMsg.isEmpty || errorMsg == "" {
            return
        }
        
        print("> \tERROR: " + errorMsg)
    }
}
