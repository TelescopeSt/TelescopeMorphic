Extension { #name : #TLCircle }

{ #category : #'*Telescope-Morphic' }
TLCircle class >> asMorphNode [
	TLNotSupportedFunctionalityException signal: 'Circle is not available for nodes. Maybe you want a TLEllipse?'
]
