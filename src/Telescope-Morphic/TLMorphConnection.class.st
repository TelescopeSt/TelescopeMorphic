Class {
	#name : #TLMorphConnection,
	#superclass : #Morph,
	#instVars : [
		'fromMorph',
		'toMorph'
	],
	#category : #'Telescope-Morphic-Morphs'
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

{ #category : #connecting }
TLMorphConnection >> connect: aMorphNode to: anotherMorphNode [
	fromMorph := aMorphNode.
	toMorph := anotherMorphNode
]

{ #category : #drawing }
TLMorphConnection >> drawOnAthensCanvas: anAthensCanvas [
	| shape stroke |
	shape := self segment asAthensPathOn: anAthensCanvas.
	stroke := anAthensCanvas setStrokePaint: self color.
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
TLMorphConnection >> segment [
	"Maybe we should cache this later?"
	| fromMorphCenter toMorphCenter lineBetweenCenters segmentBetweenShapes intersectionPoints |
	fromMorphCenter := self fromMorph center.
	toMorphCenter :=  self toMorph center.
	lineBetweenCenters := GLine through: fromMorphCenter and: toMorphCenter.
	segmentBetweenShapes := GSegment new.
	intersectionPoints := self fromMorph shape intersectLine: lineBetweenCenters.
	intersectionPoints ifEmpty: [ ^ GSegment with: fromMorphCenter with: toMorphCenter ]. "How could that happen?"
	segmentBetweenShapes v1: (intersectionPoints fold: [ :point1 :point2 | ((point1 dist: toMorphCenter) < (point2 dist: toMorphCenter)) ifTrue: [ point1 ] ifFalse: [ point2 ] ]).
	intersectionPoints := self toMorph shape intersectLine: lineBetweenCenters.
	intersectionPoints ifEmpty: [ ^ GSegment with: fromMorphCenter with: toMorphCenter ]. "How could that happen?"
	segmentBetweenShapes v2: (intersectionPoints fold: [ :point1 :point2 | ((point1 dist: fromMorphCenter) < (point2 dist: fromMorphCenter)) ifTrue: [ point1 ] ifFalse: [ point2 ] ]).
	^ segmentBetweenShapes
]

{ #category : #accessing }
TLMorphConnection >> toMorph [
	^ toMorph
]

{ #category : #TODO }
TLMorphConnection >> todo [
	self flag: #todo.
	"For now we only have straight segments. Since I do not like a world with only straight, we should implement hom... euh... curvy segments too"
]
