//
//  PositionMatrixViewController.swift
//  Menu Demo
//
//  Created by Darren Ford on 7/4/2022.
//

import Cocoa

class PositionMatrixViewController: NSViewController {

	@IBOutlet weak var tl: NSButton!
	@IBOutlet weak var tm: NSButton!
	@IBOutlet weak var tr: NSButton!
	@IBOutlet weak var ml: NSButton!
	@IBOutlet weak var mm: NSButton!
	@IBOutlet weak var mr: NSButton!
	@IBOutlet weak var bl: NSButton!
	@IBOutlet weak var bm: NSButton!
	@IBOutlet weak var br: NSButton!

	var buttons = [NSButton]()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.

		buttons = [tl, tm, tr, ml, mm, mr, bl, bm, br]

		setAll(.off)
	}

	func setAll(_ state: NSControl.StateValue) {
		buttons.forEach { $0.state = state }
	}

	var allSelected: Bool {
		buttons.allSatisfy { button in
			button.state == .on
		}
	}

	var noneSelected: Bool {
		buttons.allSatisfy { button in
			button.state == .off
		}
	}

}
