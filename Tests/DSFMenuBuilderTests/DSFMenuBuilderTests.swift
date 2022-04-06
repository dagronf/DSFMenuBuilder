import XCTest
@testable import DSFMenuBuilder

final class DSFMenuBuilderTests: XCTestCase {

	func testBuild() throws {

		let menu = NSMenu {
			MenuItem("caterpillar")
			MenuItem("noodle")
				.onAction {
					Swift.print("Got here!")
				}
		}

		XCTAssertEqual(2, menu.items.count)
		XCTAssertEqual("caterpillar", menu.items[0].title)
		XCTAssertEqual("noodle", menu.items[1].title)

		menu.performActionForItem(at: 1)

	}
}
