Class {
	#name : #TLMorphSimpleNode,
	#superclass : #TLShapeMorph,
	#category : #'Telescope-Morphic-Morphs'
}

{ #category : #'instance creation' }
TLMorphSimpleNode class >> fromSimpleNode: aTLSimpleNode [
	^ self new
		adaptToStylesheet: aTLSimpleNode effectiveStyleSheet forSimpleNode: aTLSimpleNode;
		yourself
]

{ #category : #adapting }
TLMorphSimpleNode >> adaptToStylesheet: aTLStylesheet forSimpleNode: aTLNode [
	self flag: #todo. "I am not sure this should be here. Maybe we need to refactor the connector."
	aTLStylesheet applyMorphicNodeStyleFor: aTLNode on: self
]

{ #category : #'event handling' }
TLMorphSimpleNode >> handlesMouseDown: evt [
	^ true
]

{ #category : #'event handling' }
TLMorphSimpleNode >> mouseDown: evt [
	super mouseDown: evt.
	self color: Color random
]

{ #category : #'event handling' }
TLMorphSimpleNode >> mouseMove: evt [
	self athensSceneView
		ifNotNil: [ :sv | self center: (sv pointPositionInScene: evt position) ]
		ifNil: [ self center: evt position ].
	^ true
]
