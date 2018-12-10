Extension { #name : #Morph }

{ #category : #'*Telescope-Morphic' }
Morph >> athensSceneView [ 
	"Sometimes event do not go through the athens scene view to be transformed (zoom/panning/rotation), so we need a way to get the transformation."

	^ owner ifNotNil: [ owner athensSceneView ]
]
