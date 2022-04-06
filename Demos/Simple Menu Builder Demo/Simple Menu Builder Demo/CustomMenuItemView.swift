//
//  CustomMenuItemView.swift
//  Simple Menu Builder Demo
//
//  Created by Darren Ford on 6/4/2022.
//

import Cocoa
import DSFMenuBuilder

class CustomMenuItemView: ViewItemViewController {

	@objc dynamic var value: Double = 25
	@objc dynamic var disabled: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

	override func enableChanged(_ isEnabled: Bool) {
		disabled = !isEnabled
	}

//	deinit {
//		Swift.print("CustomMenuItemView deinit")
//	}
}
