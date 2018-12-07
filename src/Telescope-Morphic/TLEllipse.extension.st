Extension { #name : #TLEllipse }

{ #category : #'*Telescope-Morphic' }
TLEllipse class >> asMorphNode [
	^ (TLPolygonMorph
		initializeVertices:
		{(-1 @ 0).
	(0 @ 1).
	(1 @ 0).
	(0 @ -1)})
		beSmoothCurve;
		yourself
]
