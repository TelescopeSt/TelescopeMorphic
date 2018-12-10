Extension { #name : #UserInputEvent }

{ #category : #'*Telescope-Morphic' }
UserInputEvent >> prepareEventFrom: aTLAthensSceneView toMorphicAt: aPoint [
	self wasHandled: false.
	position := aPoint
]
