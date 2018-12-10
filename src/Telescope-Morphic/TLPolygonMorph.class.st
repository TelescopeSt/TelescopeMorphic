Class {
	#name : #TLPolygonMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'baseVertices',
		'vertices',
		'borderDashSpec',
		'borderForm'
	],
	#category : #'Telescope-Morphic-Morphs'
}

{ #category : #initialization }
TLPolygonMorph class >> initializeVertices: aCollection [
	^ self new
		initializeVertices: aCollection;
		yourself
]

{ #category : #athens }
TLPolygonMorph >> asAthensPathOn: anAthensCanvas [
	^ anAthensCanvas
		createPath: [ :builder | 
			builder absolute.
			builder moveTo: vertices first.
			vertices allButFirstDo: [ :p | builder lineTo: p ].
			builder close.
			builder ]
]

{ #category : #dashes }
TLPolygonMorph >> borderDashOffset [
	borderDashSpec size < 4 ifTrue: [^0.0].
	^ (borderDashSpec fourth) asFloat
]

{ #category : #accessing }
TLPolygonMorph >> borderWidth: anInteger [
	borderWidth := anInteger max: 0.
	self computeBounds
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
	self changed.
	oldBounds := bounds.
	self releaseCachedState.
	bounds := ((Rectangle encompassing: self vertices) expandBy: borderWidth * 0.5) expanded.

	"since we are directly updating bounds, see if any ordinary submorphs exist and move them accordingly"
	(oldBounds notNil and: [(delta := bounds origin - oldBounds origin) ~= (0@0)]) ifTrue: [
		self submorphsDo: [ :each | each position: each position + delta ].
	].
	self layoutChanged.
	self changed.

]

{ #category : #accessing }
TLPolygonMorph >> containsPoint: aPoint [
	(super containsPoint: aPoint) ifFalse: [^ false].

	^ (Polygon vertices: vertices) containsPoint: aPoint 
]

{ #category : #accessing }
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

{ #category : #drawing }
TLPolygonMorph >> drawClippedBorderOn: aCanvas [
	aCanvas clipBy: self bounds during: [ :cc | self drawDashedBorderOn: cc ]
]

{ #category : #drawing }
TLPolygonMorph >> drawDashedBorderOn: aCanvas [
	"Display my border on the canvas. NOTE: mostly copied from  
	drawBorderOn:"

	| bevel topLeftColor bottomRightColor lineColor segmentOffset |
	(borderColor isColor and: [ borderColor isTransparent ])
		ifTrue: [ ^ self ].
	lineColor := borderColor.
	bevel := false.
	"Border colors for bevelled effects depend on CW ordering of  
	vertices"
	borderColor == #raised
		ifTrue: [ topLeftColor := color lighter.
			bottomRightColor := color darker.
			bevel := true ].
	borderColor == #inset
		ifTrue: [ topLeftColor := owner colorForInsets darker.
			bottomRightColor := owner colorForInsets lighter.
			bevel := true ].
	segmentOffset := self borderDashOffset.
	self
		lineSegmentsDo: [ :p1 :p2 | 
			| p2i p1i |
			p1i := p1 asIntegerPoint.
			p2i := p2 asIntegerPoint.
			bevel
				ifTrue: [ lineColor := (p1i quadrantOf: p2i) > 2
						ifTrue: [ topLeftColor ]
						ifFalse: [ bottomRightColor ].
					segmentOffset := aCanvas
						line: p1i
						to: p2i
						width: borderWidth
						color: lineColor
						dashLength: borderDashSpec first
						secondColor: borderDashSpec third
						secondDashLength: borderDashSpec second
						startingOffset: segmentOffset ] ]
]

{ #category : #drawing }
TLPolygonMorph >> drawDropShadowOn: aCanvas [ 
	"Display the receiver, a spline curve, approximated by straight line segments."
	
	aCanvas drawPolygon: self vertices fillStyle: self shadowColor.
]

{ #category : #drawing }
TLPolygonMorph >> drawOn: aCanvas [
	"Display the receiver, a spline curve, approximated by straight 
	line segments."
	borderDashSpec
		ifNotNil: [ aCanvas drawPolygon: self vertices fillStyle: self fillStyle.
			self drawClippedBorderOn: aCanvas ]
		ifNil: [aCanvas
				drawPolygon: self vertices
				fillStyle: self fillStyle
				borderWidth: self borderWidth
				borderColor: self borderColor ]
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
	"The vertices will be always be in a encompassing square from -1@-1 to 1@1. 
	The extent will be computed from the vertices. To get the wanted extent we need to multiply it by the size and dive it by two. 
	
	For example the base vertices of a square will be: {(-1 @ -1). (1 @ -1). (1 @ 1). (-1 @ 1)}
	
	To get a width and height of 40 we first need to multiply the vertices by 40.
	
	We will obtain {(-40 @ -40). (40 @ -40). (40 @ 40). (-40 @ 40)}
	
	Then we need to divide by two because if we do not do that, we will have a width and height that is the double of the expected size."

	self setVertices: (baseVertices collect: [ :point | point * newExtent / 2 ])
]

{ #category : #initialization }
TLPolygonMorph >> initialize [
	super initialize.
	baseVertices := vertices := (Array with: 5 @ 0 with: 20 @ 10 with: 0 @ 20).
	self computeBounds
]

{ #category : #initialization }
TLPolygonMorph >> initializeVertices: aCollection [
	baseVertices := aCollection.
	self setVertices: aCollection
]

{ #category : #testing }
TLPolygonMorph >> isAnimated [

	borderDashSpec ifNil: [^false].
	^ borderDashSpec size = 5 and: [(borderDashSpec fifth) > 0]
]

{ #category : #smoothing }
TLPolygonMorph >> lineSegmentsDo: endPointsBlock [
	"Emit a sequence of segment endpoints into endPointsBlock."

	| beginPoint |
	beginPoint := nil.
	self vertices
		do: [ :vert | 
			beginPoint ifNotNil: [ endPointsBlock value: beginPoint value: vert ].
			beginPoint := vert ].
	endPointsBlock value: beginPoint value: self vertices first
]

{ #category : #private }
TLPolygonMorph >> privateMoveBy: delta [
	super privateMoveBy: delta.
	vertices := self vertices collect: [:p | p + delta].
	(self valueOfProperty: #referencePosition) ifNotNil:
		[:oldPos | self setProperty: #referencePosition toValue: oldPos + delta]
]

{ #category : #geometry }
TLPolygonMorph >> referencePosition [ 
	"Return the current reference position of the receiver"
	^ self valueOfProperty: #referencePosition ifAbsent: [super referencePosition]

]

{ #category : #geometry }
TLPolygonMorph >> rotationCenter [
	"Return the rotation center of the receiver. The rotation center defines the relative offset inside the receiver's bounds for locating the reference position."
	| refPos |
	refPos := self valueOfProperty: #referencePosition ifAbsent: [^ 0.5@0.5].
	^ (refPos - self bounds origin) / self bounds extent asFloatPoint
]

{ #category : #geometry }
TLPolygonMorph >> rotationCenter: aPointOrNil [
	"Set the new rotation center of the receiver. The rotation center defines the relative offset inside the receiver's bounds for locating the reference position."
	| box |
	aPointOrNil isNil
		ifTrue: [self removeProperty: #referencePosition]
		ifFalse: [box := self bounds.
				self setProperty: #referencePosition toValue: box origin + (aPointOrNil * box extent)]

]

{ #category : #geometry }
TLPolygonMorph >> scale: scaleFactor [ 
	| flex center ratio |
	ratio := self scaleFactor / scaleFactor.
	self borderWidth: ((self borderWidth / ratio) rounded max: 0).
	center := self referencePosition.
	flex := (MorphicTransform offset: center negated) withScale: ratio.
	self setVertices: (self vertices collect: [:v | (flex transform: v) - flex offset]).
	super scale: scaleFactor.
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

{ #category : #menu }
TLPolygonMorph >> setRotationCenterFrom: aPoint [
	"Polygons store their referencePosition."
	self setProperty: #referencePosition toValue: aPoint
]

{ #category : #private }
TLPolygonMorph >> setVertices: newVertices [
	newVertices size <= 2 ifTrue: [ self error: 'We need at least 3 points for a polygon.' ].
	vertices := newVertices.
	self computeBounds
]

{ #category : #smoothing }
TLPolygonMorph >> slopes: knots [
	"For a collection of floats. Returns the slopes for straight 
	segments between vertices."
	"last slope closes the polygon. Always return same size as 
	self. "
	
	^ knots collectWithIndex: [:x :i | (knots atWrap: i + 1) - x]
]

{ #category : #accessing }
TLPolygonMorph >> step [
	borderDashSpec ifNil: [^super step].
	borderDashSpec size < 5 ifTrue: [^super step].

	"Only for dashed lines with creep"
	borderDashSpec at: 4 put: (borderDashSpec fourth) + borderDashSpec fifth.
	self changed.
	^ super step
]

{ #category : #testing }
TLPolygonMorph >> stepTime [
	^ 100
]

{ #category : #TODO }
TLPolygonMorph >> todo [
	self flag: #todo. 
	
	"- There is some code to manage dash borders but we do not want to use it like that. We want to directly use the border style. So we will need to review everything related to the dashing and add dot border and double border to match cytoscape features.
	- The containsPoints: method does not take curvy shapes into account. Maybe we should have another class for curvy shapes?
	- See if we can simplify the implementation using the Polygon class."
]

{ #category : #'cubic support' }
TLPolygonMorph >> transform: coefficients toCubicPointPolynomialAt: vIndex [
	"From curve information assemble a 4-array of points representing the coefficents for curve segment between to points. Beginning point is first point in array endpoint is the pointSum of the array. Meant to be sent to newcurves idea of curve coefficents."

	| transformed |
	transformed := (1 to: 4) collect: [ :i | ((coefficients at: i) at: vIndex) @ ((coefficients at: 4 + i) at: vIndex) ].
	^ Cubic withAll: transformed
]

{ #category : #geometry }
TLPolygonMorph >> transformedBy: aTransform [
	self setVertices: (self vertices collect: [ :v | aTransform localPointToGlobal: v ])
]

{ #category : #accessing }
TLPolygonMorph >> vertices [
	^ vertices
]

{ #category : #testing }
TLPolygonMorph >> wantsSteps [
	super wantsSteps ifTrue: [^true].

	"For crawling ants effect of dashed line."
	^ self isAnimated
]
