Class {
	#name : #TLMorphSimpleNode,
	#superclass : #TLShapeMorph,
	#instVars : [
		'label'
	],
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

{ #category : #accessing }
TLMorphSimpleNode >> addLabelToVisualization [
	label ifNil: [ ^ self ].
	
	owner addMorphFront: label
]

{ #category : #'event handling' }
TLMorphSimpleNode >> handlesMouseDown: evt [
	^ true
]

{ #category : #accessing }
TLMorphSimpleNode >> label: aTLLabelMorph [
	label ifNotNil: [ owner ifNotNil: [ owner removeMorph: label ] ].
	label := aTLLabelMorph.
	owner ifNotNil: [ self addLabelToVisualization ]
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

{ #category : #geometry }
TLMorphSimpleNode >> position: aPoint [
	aPoint = self position ifTrue: [ ^ self ].
	super position: aPoint.
	label ifNotNil: [ :lab | lab updatePositionFollowing: self ]
]
