Extension { #name : #GShape }

{ #category : #'*Telescope-Morphic' }
GShape >> encompassingRectangleAsPharoRectangle [
	^ Rectangle encompassing: (self encompassingRectangle vertices collect: [ :gPoint | gPoint x @ gPoint y ])
]
