//
//  MenuCollection.swift
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

/// A menu item that builds menu items using a menu template structure.
///
/// Example :-
///
/// ```swift
/// let menu = Menu {
///    MenuCollection(1...4) { item in
///       MenuItem("Item \(item)")
///          .tag(item)
///          .onAction {
///             Swift.print("User selected \(item)")
///          }
///       Separator()
///    }
/// }
/// ```
public class MenuCollection: AnyMenuItem {
	internal let items: [AnyMenuItem]
	/// Create a menu collection item
	/// - Parameters:
	///   - elements: The sequence of items to add
	///   - builder: The menu template to use for each item in the elements sequence
	public init<ItemContainerType: Sequence>(
		_ elements: ItemContainerType,
		@MenuBuilder builder: (ItemContainerType.Element) -> [AnyMenuItem]
	) {
		var results: [AnyMenuItem] = []
		for item in elements {
			results.append(contentsOf: builder(item))
		}
		self.items = results
		super.init(item: NSMenuItem())
	}
}
