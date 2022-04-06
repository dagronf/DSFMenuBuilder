//
//  MenuItem.swift
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

import AppKit
import Foundation

/// The core menu item type with a title etc.
public class MenuItem: AnyMenuItem {
	/// Create an 'empty' menu item
	public init() {
		super.init(item: NSMenuItem())
	}

	/// Create a menu item with a simple title
	public init(_ title: String) {
		super.init(item: NSMenuItem())
		self.item.title = title
	}

	/// Create a menu item with an attributed string for the title
	public init(_ attributedTitle: NSAttributedString) {
		super.init(item: NSMenuItem())
		self.item.attributedTitle = attributedTitle
	}

	/// Create a menu item with a submenu builder
	public convenience init(_ title: String, @MenuBuilder builder: () -> [AnyMenuItem]) {
		self.init(title)
		self.subMenu = Menu(builder: builder)
	}

	/// Create a menu item containing a submenu
	public convenience init(_ title: String, subMenu: Menu) {
		self.init(title)
		self.subMenu = subMenu
	}

	// Private

	// The submenu if the menu item has one
	var subMenu: Menu?

	// The custom menu target
	var target: MenuItemTarget {
		return self.item.representedObject as! MenuItemTarget
	}
}

// MARK: - Actions

public extension MenuItem {
	/// The action callback for when the user selects the menu item.
	///
	/// By default, if an action is supplied it is automatically enabled. To disable, use the `disabled` callback.
	///
	/// Example :-
	///
	/// ```swift
	///  let menu = Menu {
	///     MenuItem("Tile Left")
	///        .onAction { [weak self] in /* Tile the windows to the left */ }
	///     MenuItem("Tile Right")
	///        .onAction { [weak self] in /* Tile the windows to the right */ }
	///  }
	/// ```
	func onAction(_ callback: @escaping () -> Void) -> Self {
		self.target.action = callback
		return self
	}
}

// MARK: - Modifiers

public extension MenuItem {
	/// A callback for retrieving the menu item enabled state when it is required for display.
	///
	/// This is useful when you have stored your Menu object as a property (rather than re-building it each time
	/// it's required).
	///
	/// Example :-
	///
	/// ```swift
	///  let menu = Menu {
	///     MenuItem("Header")
	///        .disabled { [weak self] in self?.myModel.headerEnabled ?? .off }
	///     MenuItem("Footer")
	///        .disabled { [weak self] in self?.myModel.footerEnabled ?? .off }
	///     MenuItem("Page")
	///        .disabled { true }  // Always disabled
	///  }
	/// ```
	func disabled(_ callback: @escaping () -> Bool) -> Self {
		self.target.isDisabledCallback = callback
		self.item.isEnabled = !callback()
		return self
	}

	/// A callback for retrieving the menu item state when it is required for display.
	///
	/// This is useful when you have stored your Menu object as a property (rather than re-building it each time
	/// it's required).
	///
	/// Example :-
	///
	/// ```swift
	///  let menu = Menu {
	///     MenuItem("Header")
	///        .state { [weak self] in self?.myModel.headerState ?? .off }
	///     MenuItem("Footer")
	///        .state { [weak self] in self?.myModel.footerState ?? .off }
	///  }
	/// ```
	func state(_ callback: @escaping () -> NSControl.StateValue) -> Self {
		self.target.stateCallback = callback
		self.item.state = callback()
		return self
	}

	/// A callback for retrieving the menu item title when it is required for display.
	///
	/// This is useful when you have stored your Menu object as a property (rather than re-building it each time
	/// it's required).
	///
	/// Example :-
	///
	/// ```swift
	///  let menu = Menu {
	///     MenuItem()
	///        .title { [weak self] in self?.myModel.title ?? "" }
	///  }
	/// ```
	func title(_ callback: @escaping () -> String) -> Self {
		self.target.titleCallback = callback
		self.item.title = callback()
		return self
	}

	func attributedTitle(_ callback: @escaping () -> NSAttributedString) -> Self {
		self.target.attributedTitleCallback = callback
		self.item.attributedTitle = callback()
		return self
	}
}

// MARK: - Properties

public extension MenuItem {
	/// The identifier for the menu item
	func identifier(_ identifier: NSUserInterfaceItemIdentifier) -> Self {
		self.item.identifier = identifier
		return self
	}

	/// The convenience identifier for the menu item
	func identifier(_ identifier: String) -> Self {
		self.item.identifier = NSUserInterfaceItemIdentifier(identifier)
		return self
	}

	/// The indentation level for the menu item
	func indentationLevel(_ count: UInt) -> Self {
		self.item.indentationLevel = Int(count)
		return self
	}

	/// Set the menu item's image
	func image(_ image: NSImage) -> Self {
		self.item.image = image
		return self
	}

	/// Set the state images for the menu item
	func stateImage(_ stateImage: MenuStateImage) -> Self {
		self.item.onStateImage = stateImage.onImage
		self.item.offStateImage = stateImage.offImage
		self.item.mixedStateImage = stateImage.mixedImage
		return self
	}
}
