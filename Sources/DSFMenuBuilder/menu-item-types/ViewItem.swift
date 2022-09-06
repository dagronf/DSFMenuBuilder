//
//  ViewItem.swift
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

#if canImport(SwiftUI)
import SwiftUI
#endif

/// A menu item containing a custom view
public class ViewItem: MenuItem {
	/// Create a new menu item that hosts an NSView
	/// - Parameters:
	///   - title: The title to use for the menu item
	///   - viewController: The view controller for the view to be displayed
	///
	/// A hosted view in a menu item requires a title so that for components that do custom handling
	/// (eg. an NSPopoverButton) it can fall back to the simple title for display when needed
	///
	/// If your custom view needs to be able to react to menu item changes, conform your view's NSViewController
	/// to the `ViewControllerMenuActions` protocol to receive menu item updates.
	public init(_ title: String, _ viewController: NSViewController) {
		super.init()
		self.setup(viewController: viewController)
		self.item.title = title
	}

//	deinit {
//		Swift.print("ViewItem deinit")
//	}

	// The view embedded within the menu item. The custom view will become a child of this view
	private let core = NSMenuItemHighlightableView()
}

// MARK: SwiftUI

public extension ViewItem {
	/// Create a new menu item that hosts a SwiftUI view
	/// - Parameters:
	///   - title: The title to use for the menu item
	///   - view: The SwiftUI view to host within the menu item
	///
	/// A hosted view in a menu item requires a title so that for components that do custom handling
	/// (eg. an NSPopoverButton) it can fall back to the simple title for display when needed
	@available(macOS 10.15, *)
	convenience init<CustomView: View>(_ title: String, _ view: CustomView) {
		let vc = HostingViewController(view)
		vc.view.translatesAutoresizingMaskIntoConstraints = false
		self.init(title, vc)
	}
}

private extension ViewItem {
	func setup(viewController: NSViewController) {
		// Attach the effect view to the menuitem
		self.item.view = viewController.view
		self.target.viewController = viewController
	}
}

#if canImport(SwiftUI)



@available(macOS 10.15, *)
private class HostingViewController<CustomView: View>: NSViewController {
	let client: CustomView
	override func loadView() {
		let v = NSView()
		v.translatesAutoresizingMaskIntoConstraints = false
		let c = NSHostingView(rootView: self.client)
		c.translatesAutoresizingMaskIntoConstraints = false

		v.addSubview(c)
		c.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
		c.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
		c.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
		c.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true

		self.view = v
	}

	init(_ view: CustomView) {
		self.client = view
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

//	deinit {
//		Swift.print("HostingViewController: deinit")
//	}
}
#endif
