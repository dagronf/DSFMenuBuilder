import XCTest
@testable import DSFMenuBuilder

final class DSFMenuBuilderTests: XCTestCase {

	func testBuild() throws {

		let menu = NSMenu {
			MenuItem("caterpillar")
				.tag(9001)
			MenuItem("noodle")
				.onAction {
					Swift.print("Got here!")
				}
		}

		XCTAssertEqual(2, menu.items.count)
		XCTAssertEqual("caterpillar", menu.items[0].title)
		XCTAssertEqual("noodle", menu.items[1].title)

		XCTAssertEqual(9001, menu.items[0].tag)

		menu.performActionForItem(at: 1)

	}

	func testMenuCollection() throws {

		let collection: [Int] = [12, 22, 32, 42]

		do {
			let menu = NSMenu {
				Separator()
				MenuItemCollection(collection) { item in
					MenuItem("Fred \(item)")
						.onAction {
							Swift.print("\(item)")
						}
				}
				Separator()
			}

			XCTAssertEqual(6, menu.items.count)
			XCTAssertTrue(menu.items[0].isSeparatorItem)
			XCTAssertEqual("Fred 12", menu.items[1].title)
			XCTAssertEqual("Fred 22", menu.items[2].title)
			XCTAssertEqual("Fred 32", menu.items[3].title)
			XCTAssertEqual("Fred 42", menu.items[4].title)
			XCTAssertTrue(menu.items[5].isSeparatorItem)
		}
	}

	func testMenuCollectionWithNonArrayType() throws {
		do {
			let menu = Menu {
				MenuItemCollection(1...4) { item in
					MenuItem("Item \(item)")
						.tag(item)
						.onAction {
							Swift.print("\(item)")
						}
				}
				MenuItem("noodle") {
					MenuItem("submenu-noodle")
						.tag(9909)
				}
					.tag(9987)
			}

			XCTAssertEqual(5, menu.menuItems.count)

			let nsmenu = menu.menu
			XCTAssertEqual(5, nsmenu.items.count)
			XCTAssertEqual(1, nsmenu.items[0].tag)
			XCTAssertEqual("Item 1", nsmenu.items[0].title)
			XCTAssertEqual(2, nsmenu.items[1].tag)
			XCTAssertEqual(3, nsmenu.items[2].tag)
			XCTAssertEqual("Item 3", nsmenu.items[2].title)
			XCTAssertEqual(4, nsmenu.items[3].tag)
			XCTAssertEqual(9987, nsmenu.items[4].tag)
			XCTAssertEqual("noodle", nsmenu.items[4].title)

			let submenu = try XCTUnwrap(nsmenu.items[4].submenu)
			XCTAssertEqual("submenu-noodle", submenu.items[0].title)
			XCTAssertEqual(9909, submenu.items[0].tag)
		}
	}

	func testMenuCollectionWithComplexType() throws {
		do {
			struct ItemType {
				let name: String
				let tag: Int
			}

			let items = [
				ItemType(name: "one", tag: 111),
				ItemType(name: "two", tag: 222),
				ItemType(name: "three", tag: 333)
			]

			let menu = NSMenu {
				MenuItemCollection(items) { item in
					MenuItem(item.name)
						.tag(item.tag)
						.onAction {
							Swift.print("\(item.name), tag = \(item.tag)")
						}
				}
			}

			XCTAssertEqual(3, menu.numberOfItems)
			XCTAssertEqual("one", menu.item(at: 0)?.title)
			XCTAssertEqual(111, menu.item(at: 0)?.tag)
			XCTAssertEqual("two", menu.item(at: 1)?.title)
			XCTAssertEqual(222, menu.item(at: 1)?.tag)
			XCTAssertEqual("three", menu.item(at: 2)?.title)
			XCTAssertEqual(333, menu.item(at: 2)?.tag)
		}
	}
}
