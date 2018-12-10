Class {
	#name : #TLPolygonMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'borderDashSpec',
		'polygon'
	],
	#category : #'Telescope-Morphic-Morphs'
}

{ #category : #initialization }
TLPolygonMorph class >> vertices: aCollection [
	^ self new
		setVertices: aCollection;
		yourself
]

{ #category : #athens }
TLPolygonMorph >> asAthensPathOn: anAthensCanvas [
	^ anAthensCanvas
		createPath: [ :builder | 
			builder absolute.
			builder moveTo: self vertices first.
			self vertices allButFirstDo: [ :p | builder lineTo: p ].
			builder close.
			builder ]
]

{ #category : #dashes }
TLPolygonMorph >> borderDashOffset [
	borderDashSpec size < 4 ifTrue: [^0.0].
	^ (borderDashSpec fourth) asFloat
]

{ #category : #geometry }
TLPolygonMorph >> bounds: newBounds [
	"This method has to be reimplemented since self extent: will also change self bounds origin,
	super bounds would leave me in wrong position when container is growing.
	Always change extent first then position"

	self
		extent: newBounds extent;
		position: newBounds topLeft
]

{ #category : #private }
TLPolygonMorph >> computeBounds [
	| oldBounds delta |
	oldBounds := bounds.
	bounds := (polygon encompasingRectangle expandBy: borderWidth * 0.5) expanded.
	
	delta := bounds origin - oldBounds origin.
	delta = (0@0) ifTrue: [ ^ self ]. "If the delta is 0@0 then the bounds did not changed and we have nothing to do more."
	
	"since we are directly updating bounds, see if any ordinary submorphs exist and move them accordingly"
	self submorphsDo: [ :each | each position: each position + delta ].
	self layoutChanged.
	self changed
]

{ #category : #testing }
TLPolygonMorph >> containsPoint: aPoint [
	^ (super containsPoint: aPoint) and: [ self polygon includesPoint: aPoint ]
]

{ #category : #testing }
TLPolygonMorph >> couldHaveRoundedCorners [
	^ false
]

{ #category : #dashes }
TLPolygonMorph >> dashedBorder [
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
TLPolygonMorph >> dashedBorder: dashSpec [
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
TLPolygonMorph >> drawOnAthensCanvas: anAthensCanvas [
	| shape stroke |
	shape := self asAthensPathOn: anAthensCanvas.
	anAthensCanvas setPaint: self fillStyle.
	anAthensCanvas drawShape: shape.
	stroke := anAthensCanvas setStrokePaint: self borderStyle.
	self dashedBorder notNil
		ifTrue: [ self setDashOnStroke: stroke ].
	anAthensCanvas drawShape: shape
]

{ #category : #geometry }
TLPolygonMorph >> extent: newExtent [
	"The bounds of this morph are computed from the vertices of the polygon. Thus, to change the bounds we need to fit the polygon in the extent."

	self polygon fitInExtent: newExtent.
	self computeBounds
]

{ #category : #initialization }
TLPolygonMorph >> initialize [
	super initialize.
	polygon := GPolygon new
]

{ #category : #accessing }
TLPolygonMorph >> polygon [
	^ polygon
]

{ #category : #accessing }
TLPolygonMorph >> polygon: anObject [
	polygon := anObject
]

{ #category : #private }
TLPolygonMorph >> privateMoveBy: delta [
	super privateMoveBy: delta.
	self polygon moveBy: delta
]

{ #category : #athens }
TLPolygonMorph >> setDashOnStroke: anAthensStrokePaint [
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
TLPolygonMorph >> setVertices: newVertices [
	newVertices size <= 2 ifTrue: [ self error: 'We need at least 3 points for a polygon.' ].
	self vertices: newVertices.
	self computeBounds
]

{ #category : #TODO }
TLPolygonMorph >> todo [
	self flag: #todo. 
	
	"- There is some code to manage dash borders but we do not want to use it like that. We want to directly use the border style. So we will need to review everything related to the dashing and add dot border and double border to match cytoscape features"
]

{ #category : #accessing }
TLPolygonMorph >> vertices [
	^ self polygon vertices
]

{ #category : #accessing }
TLPolygonMorph >> vertices: anObject [
	self polygon initializeVertices: anObject
]
