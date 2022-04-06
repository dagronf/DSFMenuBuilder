//
//  ViewItem.swift
//  
//
//  Created by Darren Ford on 6/4/2022.
//

import AppKit
import Foundation

open class ViewItemViewController: NSViewController {

	// Override to react to enable changes
	open func enableChanged(_ isEnabled: Bool) {}

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
}

/// A menu item containing a custom view
public class ViewItem: MenuItem {

	let core = NSMenuItemHighlightableView()
//	private let viewController: ViewItemViewController

	public init(_ viewController: ViewItemViewController) {
		super.init()
		self.setup(viewController: viewController)
	}

	/// Should the view show a menu-style highlight when the mouse pointer hovers over the item?
	public func showsHighlight(_ showsHighlight: Bool) -> Self {
		self.target.viewController?.showsHighlight = showsHighlight
		return self
	}

//	deinit {
//		Swift.print("ViewItem deinit")
//	}

	private func setup(viewController: ViewItemViewController) {
		self.core.translatesAutoresizingMaskIntoConstraints = false
		self.core.addSubview(viewController.view)
		self.core.pinEdges(to: viewController.view)
		self.item.view = self.core
		self.target.viewController = viewController
	}
}
