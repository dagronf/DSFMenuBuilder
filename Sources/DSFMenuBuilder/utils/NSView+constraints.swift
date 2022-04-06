//
//  NSView+constraints.swift
//
//  Created by Darren Ford on 22/2/2022.
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

#if os(macOS)

import AppKit

extension NSView {
	/// Pin edges of this view to another view
	func pinEdges(to other: NSView, offset: CGFloat = 0, animate: Bool = false) {
		let which = animate ? self.animator() : self
		which.leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: offset).isActive = true
		which.trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -offset).isActive = true
		which.topAnchor.constraint(equalTo: other.topAnchor, constant: offset).isActive = true
		which.bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -offset).isActive = true
	}
}

#endif
