//
//  ViewItem+NSViewController.swift
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

/// If your custom view needs to be able to react to menu item changes, conform
/// your view's NSViewController to this protocol to receive menu updates.
public protocol ViewControllerMenuActions {
	func enabledChanged(_ enabled: Bool)
	func stateChanged(_ state: NSControl.StateValue)
}

public extension NSViewController {
	/// Trigger the action for the ViewItem and dismiss the menu
	func performActionForViewItemAndDismiss() {
		if let menuItem = self.view.enclosingMenuItem,
		   let menu = menuItem.menu
		{
			menu.performActionForItem(at: menu.index(of: menuItem))
		}
		self.dismissViewItem()
	}

	/// Dismiss the menu containing the ViewItem
	func dismissViewItem() {
		self.view.enclosingMenuItem?.menu?.cancelTracking()
	}
}
