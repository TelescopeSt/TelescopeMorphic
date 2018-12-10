Extension { #name : #AthensMorphScene }

{ #category : #'*Telescope-Morphic' }
AthensMorphScene >> handleEvent: anEvent in: aScene [
	anEvent prepareEventFromAthens: aScene.
	self morph processEvent: anEvent.
	^ anEvent wasHandled
]
