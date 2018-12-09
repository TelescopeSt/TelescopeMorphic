Class {
	#name : #TLAthensAffineTransform,
	#superclass : #AthensAffineTransform,
	#category : #'Telescope-Morphic'
}

{ #category : #'vector-transform' }
TLAthensAffineTransform >> transform: aPoint [
	| px py |
	px := aPoint x.
	py := aPoint y.
	^ Point
		x: (px + (shx * py) - x) / sx
		y: (shy * px + py - y) / sy
]
