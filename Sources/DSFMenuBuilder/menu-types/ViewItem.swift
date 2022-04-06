//
//  ViewItem.swift
//  
//
//  Created by Darren Ford on 6/4/2022.
//

import AppKit
import Foundation

#if canImport(SwiftUI)
import SwiftUI
#endif

/// A menu item containing a custom view
public class ViewItem: MenuItem {

	/// Create a new menu item containing a view
	public init(_ viewController: ViewItemViewController) {
		super.init()
		self.setup(viewController: viewController)
	}

	#if canImport(SwiftUI)
	/// Create a new menu item that hosts a SwiftUI style view
	@available(macOS 10.15, *)
	public init<CustomView: View>(_ title: String, _ view: CustomView) {
		super.init()
		let wrapped = HostingViewController(view)
		self.setup(viewController: wrapped)
		self.item.title = title
	}
	#endif

	//	deinit {
	//		Swift.print("ViewItem deinit")
	//	}

	// The view embedded within the menu item. The custom view will become a child of this view
	private let core = NSMenuItemHighlightableView()
}

public extension ViewItem {
	/// Should the view show a menu-style highlight when the mouse pointer hovers over the item?
	func showsHighlight(_ showsHighlight: Bool) -> Self {
		self.target.viewController?.showsHighlight = showsHighlight
		return self
	}
}

private extension ViewItem {
	func setup(viewController: ViewItemViewController) {
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

/// A custom view controller for hosting a view within a menu item
///
/// You need to override this in your custom viewcontroller
open class ViewItemViewController: NSViewController {

	// Override to react to enable changes
	open func enableChanged(_ isEnabled: Bool) {}

	// Override to react to state changes
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

#if canImport(SwiftUI)
@available(macOS 10.15, *)
private class HostingViewController<CustomView: View>: ViewItemViewController {
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
