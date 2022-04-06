//
//  File.swift
//  
//
//  Created by Darren Ford on 6/4/2022.
//

import Foundation
import AppKit

extension NSMenu {
	public convenience init(@NSMenuBuilder builder: () -> [NSMenuItem]) {
		self.init()
		self.removeAllItems()
		builder().forEach { self.addItem($0) }
	}
}


@resultBuilder
public struct NSMenuBuilder {
	public static func buildBlock(_ components: AnyMenuItem...) -> [NSMenuItem] {
		components.map { menuItem in
			let result = menuItem.item
			if let sub = menuItem as? MenuItem,
				let subMenu = sub.subMenu
			{
				result.submenu = subMenu.menu
			}
			return result
		}
	}
}
