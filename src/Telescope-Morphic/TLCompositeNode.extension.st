Extension { #name : #TLCompositeNode }

{ #category : #'*Telescope-Morphic' }
TLCompositeNode >> asMorphicNode [
	^ TLMorphCompositeNode fromCompositeNode: self
]
