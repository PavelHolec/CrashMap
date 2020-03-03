import XCTest

class Crash_MapUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    func testAnnotationSelection() {
        let meteorite1IdToTest = "57165"
        let meteorite2IdToTest = "56353"
        
        XCTContext.runActivity(named: "Meteorite List - Tap meteorite \(meteorite1IdToTest)") { _ in
            app.tables.cells["cell_\(meteorite1IdToTest)"].tap()
        }
        
        XCTContext.runActivity(named: "Meteorite List - Tap meteorite annotation \(meteorite2IdToTest)") { _ in
            let annotation = app.otherElements["pin_\(meteorite2IdToTest)"]
            app.tapCoordinate(at: CGPoint(x: annotation.frame.midX, y: annotation.frame.midY))
            
            // Does not work
            //annotation.buttons.firstMatch.tap()
        }
        
        XCTContext.runActivity(named: "Meteorite List - Check if meteorite \(meteorite2IdToTest) is selected") { _ in
            let meteorite2cell = app.tables.cells[meteorite2IdToTest].firstMatch
            XCTAssertEqual(meteorite2cell.isSelected, true)
        }
    }
}

extension XCUIApplication {
    func tapCoordinate(at point: CGPoint) {
        let normalized = coordinate(withNormalizedOffset: .zero)
        let offset = CGVector(dx: point.x, dy: point.y)
        let coordinate = normalized.withOffset(offset)
        coordinate.tap()
    }
}
