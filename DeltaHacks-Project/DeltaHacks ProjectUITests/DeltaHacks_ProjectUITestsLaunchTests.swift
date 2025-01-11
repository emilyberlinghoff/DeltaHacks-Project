import XCTest

final class DeltaHacks_ProjectUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Example: Validate the presence of a UI element to confirm app launch
        let launchScreenElement = app.staticTexts["Welcome to DeltaHacks Project"] // Replace with an actual identifier or text in your app
        XCTAssertTrue(launchScreenElement.exists, "The app did not launch successfully or the expected element is missing.")
    }
}
