//
//  CustomMenuItemView.swift
//  Simple Menu Builder Demo
//
//  Created by Darren Ford on 6/4/2022.
//

import Cocoa
import DSFMenuBuilder

class CustomMenuItemView: NSViewController, ViewControllerMenuActions {
	@objc dynamic var value: Double = 25
	@objc dynamic var disabled = false

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}

	deinit {
		Swift.print("CustomMenuItemView deinit")
	}

	func enabledChanged(_ enabled: Bool) {
		self.disabled = !enabled
	}

	func stateChanged(_ state: NSControl.StateValue) {}

	override func mouseUp(with event: NSEvent) {
		super.mouseUp(with: event)

		// Dismiss the ViewItem
		self.performActionForViewItemAndDismiss()
	}
}
