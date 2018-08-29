Class {
	#name : #TLMorphSimpleNode,
	#superclass : #Morph,
	#traits : 'TLRequiredForConnector',
	#classTraits : 'TLRequiredForConnector classTrait',
	#instVars : [
		'innerMorph'
	],
	#category : #'Telescope-Morphic'
}

{ #category : #'instance creation' }
TLMorphSimpleNode class >> fromSimpleNode: aTLSimpleNode [
	^ self new
		adaptToStylesheet: aTLSimpleNode effectiveStyleSheet;
		yourself
]

{ #category : #adapting }
TLMorphSimpleNode >> adaptToStylesheet: aTLStylesheet [
	self innerMorph: aTLStylesheet shape asMorphNode.
	self innerMorph
		color: aTLStylesheet backgroundColor;
		borderColor: aTLStylesheet borderColor;
		borderWidth: aTLStylesheet borderWidth;
		width: aTLStylesheet width;
		height: aTLStylesheet height.
	
	self extent: self innerMorph extent
		
]

{ #category : #accessing }
TLMorphSimpleNode >> children [
	^ #()
]

{ #category : #accessing }
TLMorphSimpleNode >> dimension [
	^ self extent
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
	self addMorph: self innerMorph.
	self innerMorph position: self position
]
