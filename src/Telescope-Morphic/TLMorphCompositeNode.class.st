Class {
	#name : #TLMorphCompositeNode,
	#superclass : #Morph,
	#traits : 'TLRequiredForConnector',
	#classTraits : 'TLRequiredForConnector classTrait',
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

{ #category : #accessing }
TLMorphCompositeNode >> children [
	^ self submorphs
]
