Class {
	#name : #TLMorphConnection,
	#superclass : #Morph,
	#instVars : [
		'fromMorph',
		'toMorph',
		'segment'
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

{ #category : #layout }
TLMorphConnection >> computeBounds [
	| oldBounds delta |
	oldBounds := bounds.
	bounds := segment encompassingRectangleAsPharoRectangle expanded.

	delta := bounds origin - oldBounds origin.
	(delta closeTo: 0 @ 0) ifTrue: [ ^ self ].	"If the delta is 0@0 then the bounds did not changed and we have nothing to do more."

	self layoutChanged.
	self changed
]

{ #category : #accessing }
TLMorphConnection >> computeSegment [
	"Maybe we should cache this later? Or do not recompute it all the time"

	| fromMorphCenter toMorphCenter lineBetweenCenters intersectionPoints |
	fromMorphCenter := self fromMorph center asGPoint.
	toMorphCenter := self toMorph center asGPoint.
	
	lineBetweenCenters := GLine through: fromMorphCenter and: toMorphCenter.

	intersectionPoints := self fromMorph shape intersectionsWith: lineBetweenCenters.
	segment
		v1:
			(intersectionPoints
				ifEmpty: [ fromMorphCenter "This can happen if we overlap shapes" ]
				ifNotEmpty: [ intersectionPoints fold: [ :point1 :point2 | (point1 distanceTo: toMorphCenter) < (point2 distanceTo: toMorphCenter) ifTrue: [ point1 ] ifFalse: [ point2 ] ] ]).

	intersectionPoints := self toMorph shape intersectionsWith: lineBetweenCenters.
	segment
		v2:
			(intersectionPoints
				ifEmpty: [ toMorphCenter "This can happen if we overlap shapes" ]
				ifNotEmpty: [ intersectionPoints fold: [ :point1 :point2 | (point1 distanceTo: fromMorphCenter) < (point2 distanceTo: fromMorphCenter) ifTrue: [ point1 ] ifFalse: [ point2 ] ] ]).
			
	self computeBounds
]

{ #category : #connecting }
TLMorphConnection >> connect: aMorphNode to: anotherMorphNode [
	fromMorph := aMorphNode.
	toMorph := anotherMorphNode
]

{ #category : #'geometry testing' }
TLMorphConnection >> containsPoint: aPoint [
	^ segment closeTo: aPoint asGPoint
]

{ #category : #drawing }
TLMorphConnection >> drawOnAthensCanvas: anAthensCanvas [
	| shape stroke |
	self computeSegment.
	shape := segment asAthensPathOn: anAthensCanvas.
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

{ #category : #'event handling' }
TLMorphConnection >> handlesMouseDown: evt [
	^ true
]

{ #category : #initialization }
TLMorphConnection >> initialize [ 
	super initialize.
	segment := GSegment new
]

{ #category : #'event handling' }
TLMorphConnection >> mouseDown: evt [
	super mouseDown: evt.
	self color: Color random
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
