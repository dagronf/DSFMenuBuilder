//
//  File.swift
//  
//
//  Created by Darren Ford on 6/4/2022.
//

import AppKit
import Foundation

/// The menu item title
public struct MenuTitle {
	public let title: String?
	public let attributedTitle: NSAttributedString?
	public init(_ title: String) {
		self.title = title
		self.attributedTitle = nil
	}

	public init(_ attributedTitle: NSAttributedString) {
		self.title = nil
		self.attributedTitle = attributedTitle
	}

	@inlinable func updateItemTitle(_ menuItem: NSMenuItem) {
		if let title = self.title {
			menuItem.title = title
		}
		else if let title = self.attributedTitle {
			menuItem.attributedTitle = title
		}
	}
}
