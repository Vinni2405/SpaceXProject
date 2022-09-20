//
//  MissionTableViewModelTests.swift
//  SpaceXProjectTests
//
//  Created by  Vinni on 09/19/22.
//

import XCTest
@testable import SpaceXProject

class MissionTableViewModelTests: XCTestCase {
    
    var viewModel: MissionTableViewModel?
    
    var expectation: XCTestExpectation?

    override func setUpWithError() throws {
        let handler = MockAPIHandler()
        viewModel = MissionTableViewModel(delegate: self, handler: handler)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFetchMissionsAndMissionCount() {
        
        expectation = XCTestExpectation(description: "Data should not be empty")
        
        viewModel?.fetchMissions()
        
        wait(for: [expectation!], timeout: 1)
        
        XCTAssertTrue(viewModel?.getMissionCount(section: 0) == 0)
        XCTAssertTrue(viewModel?.getMissionCount(section: 1) == 3)
    }
    
    func testReturnMission() {
        expectation = XCTestExpectation(description: "Data should not be empty")
        
        viewModel?.fetchMissions()
        
        wait(for: [expectation!], timeout: 1)
        
        XCTAssertNotNil(viewModel?.returnMission(at: 0, section: 1))
    }
    
    func testGetSmallMissionImage() {
        expectation = XCTestExpectation(description: "Data should not be empty")
        
        viewModel?.fetchMissions()
        
        wait(for: [expectation!], timeout: 1)
        
        XCTAssertNotNil(viewModel?.getSmallMissionImageForMission(at: 0, section: 1))
    }
    
    func testGetLargeMissionImage() {
        expectation = XCTestExpectation(description: "Data should not be empty")
        
        viewModel?.fetchMissions()
        
        wait(for: [expectation!], timeout: 1)
        
        XCTAssertNotNil(viewModel?.getLargeMissionImageForMission(at: 0, section: 1))
    }
    
    func testGetMissionName() {
        expectation = XCTestExpectation(description: "Data should not be empty")
        
        viewModel?.fetchMissions()
        
        wait(for: [expectation!], timeout: 1)
        
        XCTAssertNotNil(viewModel?.getMissionNameForMission(at: 0, section: 1))
    }
    
    func testGetRocketNameForMission() {
        expectation = XCTestExpectation(description: "Data should not be empty")
        
        viewModel?.fetchMissions()
        
        wait(for: [expectation!], timeout: 1)
        
        XCTAssertNotNil(viewModel?.getRocketNameForMission(at: 0, section: 1))
    }
    
    func testGetLaunchSiteAndDateForMission() {
        expectation = XCTestExpectation(description: "Data should not be empty")
        
        viewModel?.fetchMissions()
        
        wait(for: [expectation!], timeout: 1)
        
        XCTAssertNotNil(viewModel?.getLaunchSiteAndDateForMission(at: 0, section: 1))
    }
}

extension MissionTableViewModelTests: MissionTableViewModelDelegate {
    func didGetData(error: Error?) {
        if let error = error {
            XCTFail(error.localizedDescription)
        }
        expectation?.fulfill()
    }
}

class MockAPIHandler: APIService {
    
    func fetchData<T>(urlString: String, completion: ((Result<T, Error>) -> Void)?) where T : Decodable, T : Encodable {
        
        var data: Data?
        
        guard let file = Bundle.main.url(forResource: "mockData.json", withExtension: nil) else {
            completion?(.failure("Could not find mockData.json"))
            return
        }
        
        do {
            data = try Data(contentsOf: file)
        }
        catch {
            completion?(.failure(error))
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data!)
            completion?(.success(decodedData))
        }
        catch {
            completion?(.failure(error))
        }
    }
}
