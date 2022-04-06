//
//  ViewItem.swift
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

#if canImport(SwiftUI)
import SwiftUI
#endif

/// A menu item containing a custom view
public class ViewItem: MenuItem {

	/// Create a new menu item that hosts a NSView
	/// - Parameters:
	///   - title: The title to use for the menu item
	///   - viewController: The view controller for the view to be displayed
	///
	/// A hosted view in a menu item requires a title so that for components that do custom handling
	/// (eg. an NSPopoverButton) it can fall back to the simple title for display when needed
	public init(_ title: String, _ viewController: ViewItem.ViewController) {
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
		self.init(title, HostingViewController(view))
	}
}

public extension ViewItem {
	/// If true, displays a menu-style highlight under the custom view when the mouse pointer hovers over the menu item
	func showsHighlight(_ showsHighlight: Bool) -> Self {
		self.target.viewController?.showsHighlight = showsHighlight
		return self
	}
}

private extension ViewItem {
	func setup(viewController: ViewItem.ViewController) {
		self.core.translatesAutoresizingMaskIntoConstraints = false
		let customView = viewController.view
		customView.translatesAutoresizingMaskIntoConstraints = false

		// Add the custom view to the effect view, and pin within the effect container
		self.core.addSubview(customView)
		customView.pinEdges(to: self.core)

		// Attach the effect view to the menuitem
		self.item.view = self.core
		self.target.viewController = viewController
	}
}

// MARK: - ViewItemViewController

extension ViewItem {

	/// A custom view controller for hosting a view within a menu item
	///
	/// If you are creating a custom menu item view using NSViewController in Interface Builder,
	/// you'll need to set the base class for the NSViewController object to `ViewItemViewController`
	@objc(ViewItemViewController) open class ViewController: NSViewController {

		/// Override to receive callbacks relating to the 'enabled' status of the view
		open func enableChanged(_ isEnabled: Bool) {}

		/// Override to receive callbacks relating to the 'state' status of the view
		open func stateChanged(_ state: NSControl.StateValue) {}

		//	deinit {
		//		Swift.print("ViewItemViewController deinit")
		//	}

		// Private

		// The menu highlighting view at the top level of the NSMenuItem
		internal var menuView: NSMenuItemHighlightableView {
			return self.view.superview as! NSMenuItemHighlightableView
		}

		// Does the view display a menu highlight underneath the view when the mouse is over the view?
		internal var showsHighlight: Bool = true {
			didSet {
				self.menuView.showsHighlight = showsHighlight
			}
		}

		// Enable or disable the view content.
		internal var isEnabled: Bool = true {
			didSet {
				self.menuView.isEnabled = isEnabled
				self.enableChanged(isEnabled)
			}
		}

		// The current state of the menu item
		internal var state: NSControl.StateValue = .off {
			didSet {
				self.stateChanged(self.state)
			}
		}
	}
}

#if canImport(SwiftUI)
@available(macOS 10.15, *)
	private class HostingViewController<CustomView: View>: ViewItem.ViewController {
	let client: CustomView
	override func loadView() {
		self.view = NSHostingView(rootView: self.client)
	}
	init(_ view: CustomView) {
		self.client = view
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

//	deinit {
//		Swift.print("HostingViewController: deinit")
//	}
}
#endif
