//
//  NSMenu+extensions.swift
//
//  Created by Darren Ford on 6/4/2022.
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import AppKit

extension NSMenu {
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
	public convenience init(@NSMenuBuilder builder: () -> [NSMenuItem]) {
		self.init()
		self.removeAllItems()
		builder().forEach { self.addItem($0) }
	}
}


@resultBuilder
public struct NSMenuBuilder {
	public static func buildBlock(_ components: AnyMenuItem...) -> [NSMenuItem] {
		components.map { menuItem in
			let result = menuItem.item
			if let sub = menuItem as? MenuItem,
				let subMenu = sub.subMenu
			{
				result.submenu = subMenu.build()
			}
			return result
		}
	}
}
