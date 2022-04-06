//
//  File.swift
//
//
//  Created by Darren Ford on 6/4/2022.
//

import AppKit
import Foundation

class MenuItemTarget: NSObject, NSMenuItemValidation {
	weak var menuItem: NSMenuItem?

	// Set the action callback
	var action: (() -> Void)?
	// Set the menu validation callback
	var isDisabledCallback: (() -> Bool)?
	// The callback to determine the menu's state.
	var stateCallback: (() -> NSControl.StateValue)?
	// The callback to determine the menu's title.
	var titleCallback: (() -> MenuTitle)?

	init(_ item: NSMenuItem) {
		Swift.print("MenuItemTarget init")
		self.menuItem = item
		super.init()
		item.target = self
		item.action = #selector(self.performAction(_:))
	}

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		if self.menuItem === menuItem {
			// Update the title if a callback is provided
			self.titleCallback?().updateItemTitle(menuItem)

			// Update the state if a callback is provided
			if let newState = self.stateCallback?() {
				self.menuItem?.state = newState
			}

			// If there's a submenu, it should be handled differently
			if let _ = self.menuItem?.submenu {
				// 1. If there's a disabled callback, use it
				if let isDisabled = self.isDisabledCallback {
					return isDisabled() == false
				}
				// Otherwise, the submenu item is enabled
				return true
			}

			// If there's no action (and we don't have a submenu), then it's disabled
			guard self.action != nil else { return false }

			// If there's a callback for checking disabled status, use that to check for disabled status
			if let isDisabled = self.isDisabledCallback {
				return isDisabled() == false
			}

			// The menu has an action, therefore it's enabled
			return true
		}

		return true
	}

	@objc private func performAction(_ sender: NSMenuItem) {
		self.action?()
	}

	deinit {
		Swift.print("MenuItemTarget deinit")
		self.menuItem?.view = nil
	}
}
