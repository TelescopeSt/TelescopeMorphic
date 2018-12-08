Class {
	#name : #TLMorphConnection,
	#superclass : #Morph,
	#instVars : [
		'fromMorph',
		'toMorph'
	],
	#category : #'Telescope-Morphic'
}

{ #category : #'instance creation' }
TLMorphConnection class >> fromConnection: aTLConnection [
	^ self new
		adaptToStylesheet: aTLConnection effectiveStyleSheet forConnection: aTLConnection;
		yourself
]

{ #category : #adapting }
TLMorphConnection >> adaptToStylesheet: aTLStylesheet forConnection: aConnection [
	self flag: 'TODO: manage width, etc...'.
	self flag: #todo. "Use #obtainValue:forEntity:inNode:"
	self color: aTLStylesheet color
]

{ #category : #drawing }
TLMorphConnection >> asAthensLinePathOn: anAthensCanvas [
	^ anAthensCanvas
		createPath: [ :builder | 
			builder absolute.
			builder moveTo: self fromMorph center.
			builder lineTo: self toMorph center.
			builder close.
			builder ]
]

{ #category : #drawing }
TLMorphConnection >> asAthensPathOn: anAthensCanvas [
	self flag: #todo.
	^ "self isCurve
		ifTrue: [ self asAthensCurvedPathOn: anAthensCanvas ]
		ifFalse: [" self asAthensLinePathOn: anAthensCanvas "]"
]

{ #category : #connecting }
TLMorphConnection >> connect: aTLMorphSimpleNode to: aTLMorphSimpleNode2 [ 
	self
		fromMorph: aTLMorphSimpleNode;
		toMorph: aTLMorphSimpleNode2
]

{ #category : #drawing }
TLMorphConnection >> drawOn: aCanvas [
	aCanvas
		line: self fromMorph center to: self toMorph center color: self color
]

{ #category : #drawing }
TLMorphConnection >> drawOnAthensCanvas: anAthensCanvas [
	| shape stroke |
	shape := self asAthensPathOn: anAthensCanvas.
	stroke := anAthensCanvas setStrokePaint: Color black.
	stroke width: "border width" 2.
	"self dashedBorder notNil
		ifTrue: [ self setDashOnStroke: stroke ]."
	anAthensCanvas drawShape: shape.
]

{ #category : #accessing }
TLMorphConnection >> fromMorph [
	^ fromMorph
]

{ #category : #accessing }
TLMorphConnection >> fromMorph: anObject [
	fromMorph := anObject
]

{ #category : #accessing }
TLMorphConnection >> toMorph [
	^ toMorph
]

{ #category : #accessing }
TLMorphConnection >> toMorph: anObject [
	toMorph := anObject
]
