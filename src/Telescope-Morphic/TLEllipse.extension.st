Extension { #name : #TLEllipse }

{ #category : #'*Telescope-Morphic' }
TLEllipse class >> asMorphNode [
	^ TLShapeMorph shape: (GEllipse center: 0 @ 0 a: 1 b: 1)
]
