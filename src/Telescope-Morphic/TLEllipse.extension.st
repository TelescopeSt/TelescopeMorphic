Extension { #name : #TLEllipse }

{ #category : #'*Telescope-Morphic' }
TLEllipse class >> asMorphNode [
	^ PolygonMorph new
		beSmoothCurve;
		setVertices:
			{(-1 @ 0).
			(0 @ 1).
			(1 @ 0).
			(0 @ -1)};
		yourself
]
