//
//  NSView+constraints.swift
//
//  Created by Darren Ford on 22/2/2022.
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
