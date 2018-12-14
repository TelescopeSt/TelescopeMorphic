Class {
	#name : #TLShapeMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'shape',
		'borderDashSpec'
	],
	#category : #'Telescope-Morphic-Morphs'
}

{ #category : #'instance creation' }
TLShapeMorph class >> shape: aGShape [
	^ self new
		shape: aGShape;
		yourself
]

{ #category : #dashes }
TLShapeMorph >> borderDashOffset [
	borderDashSpec size < 4 ifTrue: [^0.0].
	^ (borderDashSpec fourth) asFloat
]

{ #category : #geometry }
TLShapeMorph >> bounds: newBounds [
	"This method has to be reimplemented since self extent: will also change self bounds origin,
	super bounds would leave me in wrong position when container is growing.
	Always change extent first then position"

	self
		extent: newBounds extent;
		position: newBounds topLeft
]

{ #category : #private }
TLShapeMorph >> computeBounds [
	| oldBounds delta |
	oldBounds := bounds.
	bounds := ((Rectangle origin: self shape encompassingRectangle origin corner: self shape encompassingRectangle corner) expandBy: borderWidth * 0.5) expanded.
	
	delta := bounds origin - oldBounds origin.
	(delta closeTo: (0@0)) ifTrue: [ ^ self ]. "If the delta is 0@0 then the bounds did not changed and we have nothing to do more."
	
	"since we are directly updating bounds, see if any ordinary submorphs exist and move them accordingly"
	self submorphsDo: [ :each | each position: each position + delta ].
	self layoutChanged.
	self changed
]

{ #category : #testing }
TLShapeMorph >> containsPoint: aPoint [
	^ (super containsPoint: aPoint) and: [ self shape includesPoint: aPoint ]
]

{ #category : #accessing }
TLShapeMorph >> couldHaveRoundedCorners [
	^ false
]

{ #category : #dashes }
TLShapeMorph >> dashedBorder [
	^borderDashSpec
	"A dash spec is a 3- or 5-element array with
		{ length of normal border color.
		length of alternate border color.
		alternate border color.
		starting offset.
		amount to add to offset at each step }
	Starting offset is usually = 0, but changing it moves the dashes along the curve."

]

{ #category : #dashes }
TLShapeMorph >> dashedBorder: dashSpec [
	self flag: #todo. "I will need to update the doc because it comes from somewhere else but we do not want all those features so we are updating all that"
	"A dash spec is a 3- or 5-element array with
		{ length of normal border color.
		length of alternate border color.
		alternate border color.
		starting offset.
		amount to add to offset at each step }
	Starting offset is usually = 0, but changing it moves the dashes along the curve."

	borderDashSpec := dashSpec.
	self changed
]

{ #category : #athens }
TLShapeMorph >> drawOnAthensCanvas: anAthensCanvas [
	| athensShape stroke |
	athensShape := self shape asAthensPathOn: anAthensCanvas.
	anAthensCanvas setPaint: self fillStyle.
	anAthensCanvas drawShape: athensShape.
	stroke := anAthensCanvas setStrokePaint: self borderStyle.
	self dashedBorder notNil
		ifTrue: [ self setDashOnStroke: stroke ].
	anAthensCanvas drawShape: athensShape
]

{ #category : #geometry }
TLShapeMorph >> extent: newExtent [
	"The bounds of this morph are computed from the vertices of the polygon. Thus, to change the bounds we need to fit the polygon in the extent."

	self shape
		fitInExtent:
			{newExtent x.
			newExtent y} asGVector.
	self computeBounds
]

{ #category : #private }
TLShapeMorph >> privateMoveBy: delta [
	super privateMoveBy: delta.
	self shape
		translateBy:
			{delta x.
			delta y} asGVector
]

{ #category : #athens }
TLShapeMorph >> setDashOnStroke: anAthensStrokePaint [
	| d commonOffset |
	d := self dashedBorder.
	commonOffset := d size > 3
		ifTrue: [ d fourth ]
		ifFalse: [ 0 ].
	anAthensStrokePaint
		dashes:
			{(d first).
			(d second)}
		offset: commonOffset
]

{ #category : #accessing }
TLShapeMorph >> shape [
	^ shape
]

{ #category : #accessing }
TLShapeMorph >> shape: aGShape [
	shape = aGShape ifTrue: [ ^ self ].
	
	shape := aGShape.
	self computeBounds
]

{ #category : #TODO }
TLShapeMorph >> todo [
	self flag: #todo. 
	
	"- There is some code to manage dash borders but we do not want to use it like that. We want to directly use the border style. So we will need to review everything related to the dashing and add dot border and double border to match cytoscape features"
]
