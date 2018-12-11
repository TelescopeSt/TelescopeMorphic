Extension { #name : #GPolygon }

{ #category : #'*Telescope-Morphic' }
GPolygon >> asAthensPathOn: anAthensCanvas [
	^ anAthensCanvas
		createPath: [ :builder | 
			builder absolute.
			builder moveTo: self vertices first.
			self vertices allButFirstDo: [ :p | builder lineTo: p ].
			builder close.
			builder ]
]
