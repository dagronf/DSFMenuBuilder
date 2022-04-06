//
//  ViewItem.swift
//  
//
//  Created by Darren Ford on 6/4/2022.
//

import AppKit
import Foundation

/// A menu item containing a custom view
public class ViewItem: MenuItem {

	private let core = NSMenuItemHighlightableView()
	private let viewController: NSViewController

	public init(_ viewController: NSViewController) {
		self.viewController = viewController
		super.init()
		self.setup()
	}

	deinit {
		Swift.print("ViewItem deinit")
	}

	private func setup() {
		self.core.translatesAutoresizingMaskIntoConstraints = false
		self.core.addSubview(self.viewController.view)
		self.core.pinEdges(to: self.viewController.view)
		self.item.view = self.core
	}
}
