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
