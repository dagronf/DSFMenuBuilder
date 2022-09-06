//
//  NSMenu+extensions.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import AppKit
import Foundation

public extension NSMenu {
	/// Create an NSMenu using the specified Menu builder
	///
	/// A convenience method for creating an NSMenu directly from a `Menu` structure
	///
	/// Example :-
	///
	/// ```swift
	///  let menu = NSMenu {
	///     MenuItem("Item 1")
	///     MenuItem("Item 2")
	///     ...
	///  }
	///
	///  menu.popUp(
	///     positioning: nil,
	///     at: .init(x: sender.bounds.minX, y: sender.bounds.maxY),
	///     in: sender
	///  )
	/// ```
	convenience init(@NSMenuBuilder builder: () -> [NSMenuItem]) {
		self.init()
		self.removeAllItems()
		builder().forEach { self.addItem($0) }
	}

	/// Append the contents of a Menu object to this menu
	func append(@NSMenuBuilder builder: () -> [NSMenuItem]) {
		builder().forEach { self.addItem($0) }
	}
}

@resultBuilder
public struct NSMenuBuilder {
	public static func buildBlock(_ components: AnyMenuItem...) -> [NSMenuItem] {
		var results: [NSMenuItem] = []
		components.forEach { menuItem in
			let result = menuItem.item
			if let with = menuItem as? MenuCollection {
				results.append(contentsOf: with.items.map { $0.item })
			}
			else {
				results.append(menuItem.item)
			}

			if let sub = menuItem as? MenuItem,
				let subMenu = sub.subMenu
			{
				result.submenu = subMenu.build()
			}
		}
		return results
	}
}
