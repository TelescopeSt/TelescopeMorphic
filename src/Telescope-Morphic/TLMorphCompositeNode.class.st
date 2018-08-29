Class {
	#name : #TLMorphCompositeNode,
	#superclass : #Morph,
	#category : #'Telescope-Morphic'
}

{ #category : #'instance creation' }
TLMorphCompositeNode class >> fromCompositeNode: aTLCompositeNode [
	^ self new
		adaptToStylesheet: aTLCompositeNode effectiveStyleSheet;
		yourself
]

{ #category : #adapting }
TLMorphCompositeNode >> adaptToStylesheet: aTLStylesheet [
	self shouldBeImplemented
]

{ #category : #testing }
TLMorphCompositeNode >> occupyMaxSpace [
	^ false
]
