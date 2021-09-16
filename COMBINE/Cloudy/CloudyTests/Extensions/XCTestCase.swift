//
//  XCTestCase.swift
//  CloudyTests
//
//  Created by Bart Jacobs on 22/06/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import XCTest

extension XCTestCase {

    // MARK: - Helper Methods

    func loadStub(name: String, extension: String) -> Data {
        // Obtain Reference to Bundle
        let bundle = Bundle(for: type(of: self))
        
        // Ask Bundle for URL of Stub
        let url = bundle.url(forResource: name, withExtension: `extension`)
        
        // Use URL to Create Data Object
        return try! Data(contentsOf: url!)
    }
    
}
