Extension { #name : #UserInputEvent }

{ #category : #'*Telescope-Morphic' }
UserInputEvent >> prepareEventFromAthens: anAthensSceneView [
	self wasHandled: false.
	position := (anAthensSceneView pointPositionInScene: position)
]
