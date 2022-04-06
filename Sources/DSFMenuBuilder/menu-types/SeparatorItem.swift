//
//  File.swift
//  
//
//  Created by Darren Ford on 6/4/2022.
//

import AppKit
import Foundation

/// A menu item separator
public class Separator: AnyMenuItem {
	public init() {
		super.init(item: NSMenuItem.separator())
	}
}
