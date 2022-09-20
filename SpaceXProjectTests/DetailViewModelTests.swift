//
//  DetailViewModelTests.swift
//  SpaceXProjectTests
//
//  Created by  Vinni on 09/19/22.
//

import XCTest
@testable import SpaceXProject

class DetailViewModelTests: XCTestCase {
    
    var viewModel: MissionDetailViewModel?
    
    var expectation: XCTestExpectation?
    
    var expectation2: XCTestExpectation?

    override func setUpWithError() throws {
        
        let handler = MockAPIHandler()
        
        viewModel = MissionDetailViewModel(delegate: self)
        
        var mission: Mission?
        
        handler.fetchData(urlString: "") { [weak self] (result: Result<[Mission], Error>) in
            switch result {
            case .success(let missions):
                mission = missions[0]
                self?.viewModel?.setMission(mission!)
            case .failure(let failure):
                fatalError(failure.localizedDescription)
            }
        }
    }

    override func tearDownWithError() throws {
       viewModel = nil
    }

    func testGetDetailCount() {
        XCTAssertTrue(viewModel?.getDetailCount() != 0)
    }
    
    func testGetTitleForRow() {
        XCTAssertFalse(viewModel!.getTitleForRow(at: 0).isEmpty)
    }
    
    func testGetContentForRow() {
        XCTAssertFalse(viewModel!.getContentForRow(at: 0).isEmpty)
    }
    
    func testGetTierForRow() {
        XCTAssertTrue(viewModel!.getTierForRow(at: 0) == 1)
    }
    
    func testCellIsExpandable() {
        XCTAssertTrue(viewModel!.cellIsExpandable(at: 12))
    }
    
    func testCellIsExpanded() {
        XCTAssertFalse(viewModel!.cellIsExpanded(at: 8))
    }
    
    func testGetChildrenForRow() {
        XCTAssertFalse(viewModel!.getChildrenForRow(at: 12).isEmpty)
    }
    
    func testExpandRow() {
        
        expectation = XCTestExpectation(description: "Cell was expanded")
        
        viewModel?.expandRow(at: 12)
        
        wait(for: [expectation!], timeout: 1)
        
        
        
        XCTAssertTrue(viewModel!.cellIsExpanded(at: 12))
    }
    
    func testCollapseAllChildRows() {
        
        expectation = XCTestExpectation(description: "Cell was expanded")
        expectation2 = XCTestExpectation(description: "Cell was collapsed")
        
        viewModel?.expandRow(at: 12)
        
        wait(for: [expectation!], timeout: 1)
        
        viewModel?.collapseAllChildRows(at: 12)
        
        wait(for: [expectation2!], timeout: 1)
        
        XCTAssertFalse(viewModel!.cellIsExpanded(at: 12))
    }
}

extension DetailViewModelTests: MissionDetailViewModelDelegate {
    func insertRows(indexPaths: [IndexPath]) {
        expectation?.fulfill()
    }
    
    func deleteRows(indexPaths: [IndexPath]) {
        expectation2?.fulfill()
    }
}
