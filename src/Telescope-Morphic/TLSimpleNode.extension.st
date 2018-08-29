Extension { #name : #TLSimpleNode }

{ #category : #'*Telescope-Morphic' }
TLSimpleNode >> asMorphicNode [
	^ TLMorphSimpleNode fromSimpleNode: self
]
