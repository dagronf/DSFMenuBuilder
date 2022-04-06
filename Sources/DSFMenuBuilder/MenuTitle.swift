//
//  MenuTitle.swift
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

/// The menu item title
public struct MenuTitle {
	public let title: String?
	public let attributedTitle: NSAttributedString?

	/// Create a title object using a String
	public init(_ title: String) {
		self.title = title
		self.attributedTitle = nil
	}

	/// Create a title object with an attributed string for the title
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
