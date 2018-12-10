Class {
	#name : #TLMorphSimpleNode,
	#superclass : #Morph,
	#instVars : [
		'innerMorph'
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
	self flag: #todo.	"The shape should not be get that way. Check the content of #applyMorphicNodeStyleFor:on: to see how to get it."
	self innerMorph: (aTLStylesheet obtainValue: #shape forEntity: aTLNode entity inNode: aTLNode) asMorphNode.
	aTLStylesheet applyMorphicNodeStyleFor: aTLNode on: self innerMorph
]

{ #category : #accessing }
TLMorphSimpleNode >> children [
	^ #()
]

{ #category : #'geometry testing' }
TLMorphSimpleNode >> containsPoint: aPoint [
	^ self innerMorph containsPoint: aPoint
]

{ #category : #accessing }
TLMorphSimpleNode >> dimension [
	^ self extent
]

{ #category : #geometry }
TLMorphSimpleNode >> extent: aPoint [
	self innerMorph extent: aPoint.
	super extent: self innerMorph extent.
	
	self flag: #todo. "I'm not really found of this hack to re-center both morphs after we apply the style. Maybe there is something better to do?"
	self removeMorph: self innerMorph.
	self addMorphCentered: self innerMorph
]

{ #category : #'event handling' }
TLMorphSimpleNode >> handlesMouseDown: evt [
	^ true
]

{ #category : #hack }
TLMorphSimpleNode >> incomingAdjacentNodes [
	self flag: #TODO. "This is because of an issue of the connector. Normally, a GUI element should not hold the model node neither the connector should interact with GUI elements."
	^ self modelNode incomingAdjacentNodes
]

{ #category : #initialization }
TLMorphSimpleNode >> initialize [
	super initialize.
	self color: Color transparent
]

{ #category : #accessing }
TLMorphSimpleNode >> innerMorph [
	^ innerMorph
]

{ #category : #accessing }
TLMorphSimpleNode >> innerMorph: anObject [
	self innerMorph ifNotNil: [ self removeMorph: self innerMorph ].
	innerMorph := anObject.
	self addMorph: self innerMorph
]

{ #category : #'event handling' }
TLMorphSimpleNode >> mouseDown: evt [
	super mouseDown: evt.
	self innerMorph color: Color random
]

{ #category : #'event handling' }
TLMorphSimpleNode >> mouseMove: evt [
	self athensSceneView
		ifNotNil: [ :sv | self center: (sv pointPositionInScene: evt position) ]
		ifNil: [ self center: evt position ].
	^ true
]
