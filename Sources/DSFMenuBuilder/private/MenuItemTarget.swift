//
//  MenuItemTarget.swift
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

// A target instance for a menu item that handles enabling/state updates/title updates etc.
//
// Created and attached to the NSMenuItem's representedObject 
class MenuItemTarget: NSObject, NSMenuItemValidation {
	weak var menuItem: NSMenuItem?

	// Set the action callback
	var action: (() -> Void)? {
		didSet {
			if action != nil {
				self.menuItem?.action = #selector(self.performAction(_:))
			}
			else {
				self.menuItem?.action = nil
			}
		}
	}

	// Set the menu validation callback
	var isEnabledCallback: (() -> Bool)?
	// The callback to determine the menu's state.
	var stateCallback: (() -> NSControl.StateValue)?
	// The callback to determine the menu's title.
	var titleCallback: (() -> String)?
	var attributedTitleCallback: (() -> NSAttributedString)?

	// If the menu item is a view
	var viewController: NSViewController?

	init(_ item: NSMenuItem) {
		self.menuItem = item
		super.init()
		self.menuItem?.target = self
	}

//	deinit {
//		Swift.print("MenuItemTarget deinit")
//	}

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		if self.menuItem === menuItem {

			let viewProtocol = self.viewController as? ViewControllerMenuActions

			// Update the title if a callback is provided
			if let title = self.titleCallback?() {
				menuItem.title = title
			}
			if let attributedTitle = self.attributedTitleCallback?() {
				menuItem.attributedTitle = attributedTitle
			}

			// Update the state if a callback is provided
			if let newState = self.stateCallback?() {
				self.menuItem?.state = newState
				viewProtocol?.stateChanged(newState)
			}

			// If there's a submenu, it should be handled differently
			if let _ = self.menuItem?.submenu {
				// 1. If there's an enabled callback, use it
				if let isEnabledCB = self.isEnabledCallback {
					let isEnabled = isEnabledCB()
					viewProtocol?.enabledChanged(isEnabled)
					return isEnabled
				}
				// Otherwise, the submenu item is enabled
				return true
			}

			// If there's no action (and we don't have a submenu), then it's disabled
			guard self.action != nil else { return false }

			// If there's a callback for checking enabled status, use that to check for enabled status
			if let isEnabledCB = self.isEnabledCallback {
				let isEnabled = isEnabledCB()
				viewProtocol?.enabledChanged(isEnabled)
				return isEnabled
			}

			// The menu has an action, therefore it's enabled
			viewProtocol?.enabledChanged(true)
			return true
		}

		return false
	}

	@objc private func performAction(_ sender: NSMenuItem) {
		self.action?()
	}
}
