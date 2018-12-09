Extension { #name : #AthensCompositeStrokePaint }

{ #category : #'*Telescope-Morphic' }
AthensCompositeStrokePaint >> athensFillPath: athensPath on: anAthensCanvas [ 

	"This is a terminal method in rendering dispatch scheme
	canvas->shape->paint. See AthensCanvas>>fillShape: "

	strokePaints do: [:paint | 
				paint athensFillPath: athensPath on: anAthensCanvas ]

]
