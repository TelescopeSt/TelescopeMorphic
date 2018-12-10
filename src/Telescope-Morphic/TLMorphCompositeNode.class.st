Class {
	#name : #TLMorphCompositeNode,
	#superclass : #Morph,
	#category : #'Telescope-Morphic-Morphs'
}

{ #category : #'instance creation' }
TLMorphCompositeNode class >> fromCompositeNode: aTLCompositeNode [
	^ self new
		adaptToStylesheet: aTLCompositeNode effectiveStyleSheet forCompositeNode: aTLCompositeNode;
		yourself
]

{ #category : #adapting }
TLMorphCompositeNode >> adaptToStylesheet: aTLStylesheet forCompositeNode: aTLNode [
	self flag: #todo.
	self shouldBeImplemented
]

{ #category : #accessing }
TLMorphCompositeNode >> children [
	^ self submorphs
]
