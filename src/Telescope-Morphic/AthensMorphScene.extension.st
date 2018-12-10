Extension { #name : #AthensMorphScene }

{ #category : #'*Telescope-Morphic' }
AthensMorphScene >> handleEvent: anEvent in: aScene at: aPoint [ 
	anEvent prepareEventFrom: aScene toMorphicAt: aPoint.
	self morph processEvent: anEvent.
	^ anEvent wasHandled
]
