//
//  File.swift
//
//
//  Created by Darren Ford on 6/4/2022.
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
		MenuTitle(title).updateItemTitle(self.item)
	}

	/// Create a menu item with an attributed string for the title
	public init(_ attributedTitle: NSAttributedString) {
		super.init(item: NSMenuItem())
		MenuTitle(attributedTitle).updateItemTitle(self.item)
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

// MARK: - Modifiers

public extension MenuItem {
	/// The action callback for the menu item.
	///
	/// By default, if an action is supplied it is automatically enabled. To disable, use the `disabled` callback.
	/// If there's no action or the 'disabled' block returns 'true' then the item is disabled
	func onAction(_ callback: @escaping () -> Void) -> Self {
		self.target.action = callback
		return self
	}

	/// Set the block used to determine whether the menu item is enabled/disabled
	func disabled(_ callback: @escaping () -> Bool) -> Self {
		self.target.isDisabledCallback = callback
		self.item.isEnabled = !callback()
		return self
	}

	/// Set the block used to determine the state of the menu item
	func state(_ callback: @escaping () -> NSControl.StateValue) -> Self {
		self.target.stateCallback = callback
		self.item.state = callback()
		return self
	}

	/// The title for the menu item
	func title(_ callback: @escaping () -> MenuTitle) -> Self {
		self.target.titleCallback = callback
		callback().updateItemTitle(self.item)
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

	/// The identifier for the menu item
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
