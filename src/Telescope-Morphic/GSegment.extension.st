Extension { #name : #GSegment }

{ #category : #'*Telescope-Morphic' }
GSegment >> asAthensPathOn: anAthensCanvas [
	^ anAthensCanvas
		createPath: [ :builder | 
			builder absolute.
			builder moveTo: self v1.
			builder lineTo: self v2.
			builder close.
			builder ]
]

{ #category : #'*Telescope-Morphic' }
GSegment >> closeTo: aGPoint [
	^ ((v2 distanceTo: aGPoint) + (aGPoint distanceTo: v1) - self length) abs < 0.05
]

{ #category : #'*Telescope-Morphic' }
GSegment >> encompassingRectangleAsPharoRectangle [
	^ Rectangle origin: (v1 coordinates upperLimitsWith: v2 coordinates) corner: (v1 coordinates lowerLimitsWith: v2 coordinates)
]
