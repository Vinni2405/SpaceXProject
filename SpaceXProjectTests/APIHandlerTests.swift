//
//  APIHandlerTests.swift
//  APIHandlerTests
//
//  Created by  Vinni on 09/19/22.
//

import XCTest
@testable import SpaceXProject

class APIHandlerTests: XCTestCase {
    
    var handler: APIHandler?

    override func setUpWithError() throws {
        // set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        handler = APIHandler(session: URLSession(configuration: configuration))
    }
    
    override func tearDownWithError() throws {
        handler = nil
    }
    
    func testGetDataFromAPIWithCompletionHandler() {
        
        let expectation = XCTestExpectation(description: "Data is not empty")
        
        handler?.fetchData(urlString: URLString.spaceXLaunches) { (result: Result<[Mission], Error>) in
            switch result {
            case .success(let missions):
                XCTAssertFalse(missions.isEmpty, "Array of missions should not be empty")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Failed to fetch data \(String(describing: failure))")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }
}
