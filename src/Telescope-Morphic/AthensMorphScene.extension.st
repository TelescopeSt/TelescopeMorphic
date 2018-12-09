Extension { #name : #AthensMorphScene }

{ #category : #'*Telescope-Morphic' }
AthensMorphScene >> handleEvent: anEvent in: aScene at: aPoint [ 
	anEvent wasHandled: false.
	anEvent setPosition: aPoint.
	self morph processEvent: anEvent.
	^ anEvent wasHandled
]
