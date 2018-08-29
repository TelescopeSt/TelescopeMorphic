Extension { #name : #TLConnection }

{ #category : #'*Telescope-Morphic' }
TLConnection >> asMorphicConnection [
	^ TLMorphConnection fromConnection: self
]
