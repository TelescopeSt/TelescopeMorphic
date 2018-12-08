Class {
	#name : #TLPolygonMorph,
	#superclass : #BorderedMorph,
	#traits : 'TAbleToRotate',
	#classTraits : 'TAbleToRotate classTrait',
	#instVars : [
		'baseVertices',
		'vertices',
		'smoothCurve',
		'curveState',
		'borderDashSpec',
		'borderForm'
	],
	#category : #'Telescope-Morphic'
}

{ #category : #initialization }
TLPolygonMorph class >> initializeVertices: aCollection [
	^ self new
		initializeVertices: aCollection;
		yourself
]

{ #category : #drawing }
TLPolygonMorph >> asAthensCurvedPathOn: anAthensCanvas [
	| points |
	points := self computeCurvedSegmentCtrlPoints.
	^ anAthensCanvas
		createPath: [ :builder | 
			self vertices notEmpty
				ifTrue: [ 
					| prior | "points contains {ctrl1 vertice ctrl2}"
					prior := points first.
					builder absolute.
					builder moveTo: prior second.
					points allButFirst
						do: [ :p | 
							builder curveVia: prior third and: p first to: p second.
							prior := p ].
					
							builder curveVia: prior third and: points first first to: points first second.
							builder close ].
			builder ]
]

{ #category : #drawing }
TLPolygonMorph >> asAthensLinePathOn: anAthensCanvas [
	^ anAthensCanvas
		createPath: [ :builder | 
			vertices notEmpty
				ifTrue: [ 
					builder absolute.
					builder moveTo: vertices first.
					vertices allButFirstDo: [ :p | builder lineTo: p ] ].
			builder close.
			builder ]
]

{ #category : #drawing }
TLPolygonMorph >> asAthensPathOn: anAthensCanvas [
	^ self isCurve
		ifTrue: [ self asAthensCurvedPathOn: anAthensCanvas ]
		ifFalse: [ self asAthensLinePathOn: anAthensCanvas ]
]

{ #category : #initialization }
TLPolygonMorph >> beSmoothCurve [
	smoothCurve ifTrue: [ ^ self ].

	smoothCurve := true.
	self computeBounds
]

{ #category : #initialization }
TLPolygonMorph >> beStraightSegments [
	smoothCurve ifTrue: [ ^ self ].

	smoothCurve := false.
	self computeBounds
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

{ #category : #'cubic support' }
TLPolygonMorph >> changeInSlopes: slopes of: verts [ 
	"A message to knots of a spline. Returns an array with the 3rd cubic coeff."
	"The last nth item is correct iff this is a closed cubic.
	Presumably that is the only time we care.
	We always return the same sized array as self."
	| n slopeChanges |
	n := verts size.
	n = slopes size ifFalse: [^ self error: 'vertices and slopes differ in number'].
	slopeChanges := Array new: n.
	1 to: n do: [:i | slopeChanges at: i put: (verts atWrap: i + 1)
					- (verts at: i) * 3 - ((slopes at: i) * 2)
					- (slopes atWrap: i + 1)].
	^ slopeChanges
]

{ #category : #'cubic support' }
TLPolygonMorph >> changeOfChangesInSlopes: slopes of: verts [
	"A message to knots of a spline. Returns an array with the 4rd 
	cubic coeff."
	"The last nth item is correct iff this is a closed cubic. 
	Presumably that is the only time we care. 
	We always return the same sized array as self."
	| n changes |
	n := verts size.
	n = slopes size ifFalse: [^ self error: 'vertices and slopes differ in number'].
	changes := Array new: n.
	1 to: n do: [:i | changes at: i put: (verts at: i)
					- (verts atWrap: i + 1) * 2
					+ (slopes at: i)
					+ (slopes atWrap: i + 1)].
	^ changes
]

{ #category : #'cubic support' }
TLPolygonMorph >> closedCubicSlopesOf: knots [ 
	"Sent to knots returns the slopes of a closed cubic spline.
	From the same set of java sources as naturalCubic. This is a smalltalk  
	transliteration of the java code."
	"from java code NatCubicClosed extends NatCubic  
	solves for the set of equations for all knots: 
	b1+4*b2+b3=3*(a3-a1)
	where a1 is (knots atWrap: index + 1) etc.
	and the b's are the slopes .
	by decomposing the matrix into upper triangular and lower matrices  
	and then back sustitution. See Spath 'Spline Algorithms for Curves  
	and Surfaces' pp 19--21. The D[i] are the derivatives at the knots.  
	"
	
	| v w x y z n1  D F G H |
	n1 := knots size.
	n1 < 3
		ifTrue: [self error: 'Less than 3 points makes a poor curve'].
	v := Array new: n1.
	w := Array new: n1.
	y := Array new: n1.
	
	D := Array new: n1.
	x := knots.
	z := 1.0 / 4.0.
	v at: 2 put: z.
	w at: 2 put: z.
	y at: 1 put: z * 3.0 * ((x at: 2) - (x at: n1)).
	H := 4.0.
	F := 3 * ((x at: 1) - (x at: n1 - 1)).
	G := 1.
	2 to: n1 - 1 do: [:k | 
			z := 1.0 / (4.0 - (v at: k)).
			v at: k + 1 put: z.
			w at: k + 1 put: z negated
					* (w at: k).
			y at: k put: z * (3.0 * ((x at: k + 1) - (x at: k - 1)) - (y at: k - 1)).
			H := H - (G * (w at: k)).
			F := F - (G * (y at: k - 1)).
			G := (v at: k) negated * G].
	H := H - (G + 1 * ((v at: n1) + (w at: n1))).
	y at: n1 put: F - (G + 1 * (y at: n1 - 1)).
	D at: n1 put: (y at: n1) / H.
	D at: n1 - 1 put: (y at: n1 - 1) - ((v at: n1) + (w at: n1) * (D at: n1)).
	(1 to: n1 - 2)
		reverseDo: [:k | D at: k put: (y at: k)
					- ((v at: k + 1) * (D at: k + 1)) - ((w at: k + 1) * (D at: n1))].
	^ D 


]

{ #category : #smoothing }
TLPolygonMorph >> coefficients [
	| verts coefficients vertXs slopeXs vertYs slopeYs bestSegments |
	curveState ifNotNil: [ ^ curveState at: 1 ].
	verts := self vertices.
	coefficients := {(vertXs := verts collect: [ :p | p x asFloat ]).
	(slopeXs := self slopes: vertXs).
	(self changeInSlopes: slopeXs of: vertXs).
	(self changeOfChangesInSlopes: slopeXs of: vertXs).
	(vertYs := verts collect: [ :p | p y asFloat ]).
	(slopeYs := self slopes: vertYs).
	(self changeInSlopes: slopeYs of: vertYs).
	(self changeOfChangesInSlopes: slopeYs of: vertYs).
	(Array new: verts size withAll: 12)}.
	bestSegments := (1 to: verts size) collect: [ :i | (self transform: coefficients toCubicPointPolynomialAt: i) bestSegments ].
	coefficients at: 9 put: bestSegments.
	curveState := {coefficients.
	nil.
	nil}.
	self computeNextToEndPoints.
	^ coefficients
]

{ #category : #private }
TLPolygonMorph >> computeBounds [
	| oldBounds delta |
	self changed.
	oldBounds := bounds.
	self releaseCachedState.
	bounds := self curveBounds expanded.

	"since we are directly updating bounds, see if any ordinary submorphs exist and move them accordingly"
	(oldBounds notNil and: [(delta := bounds origin - oldBounds origin) ~= (0@0)]) ifTrue: [
		self submorphsDo: [ :each | each position: each position + delta ].
	].
	self layoutChanged.
	self changed.

]

{ #category : #drawing }
TLPolygonMorph >> computeCurvedSegmentCtrlPoints [
	"compute control points for the curved polygon.
For every vertice C take the two edges L and R. Compute the line T between the midpoints of L and R.
Use T is the tangent on the C. T is divided by the C with the same ration as L/R.
The start and end point of T defines the controlpoint c1 and c2
for the current vertice C.
"

	| ctrls |
	ctrls := (1 to: vertices size)
		collect: [ :i | 
			| prior current next lenpc lencn ctrl1 ctrl2 tangent |
			prior := vertices atWrap: i - 1.
			current := vertices atWrap: i.
			next := vertices atWrap: i + 1.
			tangent := (next - prior) / 2.
			lenpc := current distanceTo: prior.
			lencn := next dist: current.
			lenpc = 0 ifTrue:[
				ctrl1 := prior]
			ifFalse:[	ctrl1 := current - (tangent / (1 + (lencn / lenpc)))].
				lencn = 0 ifTrue:[
					ctrl2 := next]
				ifFalse:[
			ctrl2 := current + (tangent / (1 + (lenpc / lencn)))].
		"collect ctrl1 current and ctrl2"
			{(ctrl1 asFloatPoint).
			current.
			(ctrl2 asFloatPoint)} ].
	^ ctrls
]

{ #category : #smoothing }
TLPolygonMorph >> computeNextToEndPoints [
	| pointAfterFirst pointBeforeLast |
	pointAfterFirst := nil.
	self lineSegmentsDo: 
			[:p1 :p2 | 
			pointAfterFirst ifNil: [pointAfterFirst := p2 asIntegerPoint].
			pointBeforeLast := p1 asIntegerPoint].
	curveState at: 2 put: pointAfterFirst.
	curveState at: 3 put: pointBeforeLast
]

{ #category : #accessing }
TLPolygonMorph >> couldHaveRoundedCorners [
	^ false
]

{ #category : #private }
TLPolygonMorph >> curveBounds [
	"Compute the bounds from actual curve traversal, with 
	leeway for borderWidth. 
	Also note the next-to-first and next-to-last points for arrow 
	directions."
	"wiz - to avoid roundoff errors we return unrounded curvebounds."
	"we expect our receiver to take responsibility for approriate rounding adjustment."
	"hint: this is most likely 'self curveBounds expanded' "
	| pointAfterFirst pointBeforeLast  oX oY cX cY |
	self isCurve
		ifFalse: [^ (Rectangle encompassing: self vertices)
				expandBy: borderWidth * 0.5 ].
	curveState := nil.
	"Force recomputation"
	"curveBounds := vertices first corner: vertices last."
	pointAfterFirst := nil.
	self
		lineSegmentsDo: [:p1 :p2 | 
			pointAfterFirst isNil
				ifTrue: [pointAfterFirst := p2 floor .
					oX := cX := p1 x.
					oY := cY := p1 y. ].
			"curveBounds := curveBounds encompass: p2 ."
			oX:= oX min: p2 x.
			cX := cX max: p2 x.
			oY := oY min: p2 y.
			cY := cY max: p2 y.
			pointBeforeLast := p1 floor ].
	curveState at: 2 put: pointAfterFirst.
	curveState at: 3 put: pointBeforeLast.
	^ ( oX @ oY corner: cX @ cY )  expandBy: borderWidth * 0.5 
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
	
	aCanvas drawPolygon: self getVertices fillStyle: self shadowColor.
]

{ #category : #drawing }
TLPolygonMorph >> drawOn: aCanvas [
	"Display the receiver, a spline curve, approximated by straight 
	line segments."
	borderDashSpec
		ifNotNil: [ aCanvas drawPolygon: self getVertices fillStyle: self fillStyle.
			self drawClippedBorderOn: aCanvas ]
		ifNil: [aCanvas
				drawPolygon: self getVertices
				fillStyle: self fillStyle
				borderWidth: self borderWidth
				borderColor: self borderColor ]
]

{ #category : #drawing }
TLPolygonMorph >> drawOnAthensCanvas: anAthensCanvas [
	| border shape stroke |
	border := self borderStyle.
	shape := self asAthensPathOn: anAthensCanvas.
	anAthensCanvas setPaint: self fillStyle.
	anAthensCanvas drawShape: shape.
	stroke := anAthensCanvas setStrokePaint: border color.
	stroke width: border width.
	self dashedBorder notNil
		ifTrue: [ self setDashOnStroke: stroke ].
	anAthensCanvas drawShape: shape.
	self hasTwoColorDash
		ifTrue: [ self setSecondColorDashOnStroke: stroke.
			anAthensCanvas drawShape: shape ].
]

{ #category : #geometry }
TLPolygonMorph >> extent: newExtent [
	self setVertices: (baseVertices collect: [ :point | point * newExtent ])
]

{ #category : #private }
TLPolygonMorph >> getVertices [

	smoothCurve ifFalse: [^ self vertices].

	"For curves, enumerate the full set of interpolated points"
	^ Array streamContents:
		[:s | self lineSegmentsDo: [:pt1 :pt2 | s nextPut: pt1]]
]

{ #category : #drawing }
TLPolygonMorph >> hasTwoColorDash [
	" return true if the dash spec has another color"

	^ self dashedBorder notNil and: [ self dashedBorder size > 2 ]
]

{ #category : #initialization }
TLPolygonMorph >> initialize [
	super initialize.
	baseVertices := vertices := (Array with: 5 @ 0 with: 20 @ 10 with: 0 @ 20).
	smoothCurve := false.
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

{ #category : #testing }
TLPolygonMorph >> isCurve [
	^ smoothCurve
]

{ #category : #smoothing }
TLPolygonMorph >> lineSegmentsDo: endPointsBlock [ 
	"Emit a sequence of segment endpoints into endPointsBlock."
	"Unlike the method this one replaces we expect the curve 
	coefficents not the dirivatives"
	"Also unlike the replaced method the smooth closed curve
	does 
	not need an extra vertex. 
	We take care of the extra endpoint here. Just like for 
	segmented curves."
	| cs x y beginPoint |
	self isCurve
		ifFalse: [beginPoint := nil.
			self vertices
				do: [:vert | 
					beginPoint
						ifNotNil: [endPointsBlock value: beginPoint value: vert].
					beginPoint := vert].
			endPointsBlock value: beginPoint value: self vertices first.
			^ self].
	"For curves we include all the interpolated sub segments."
	"self assert: [(vertices size > 2 )].	"
	cs := self coefficients.
	beginPoint := (x := cs first first) @ (y := cs fifth first).
	1 to: cs first size do: [:i | | t n x3 y3 x1 endPoint x2 y1 y2 | 
			"taylor series coefficients"
			x1 := cs second at: i.
			y1 := cs sixth at: i.
			x2 := cs third at: i.
			y2 := cs seventh at: i.
			x3 := cs fourth at: i.
			y3 := cs eighth at: i.
			n := cs ninth at: i.
		
			1
				to: n - 1
				do: [:j | 
					t := j asFloat / n asFloat.
					endPoint := x3 * t + x2 * t + x1 * t + x @ (y3 * t + y2 * t + y1 * t + y).
					endPointsBlock value: beginPoint value: endPoint.
					beginPoint := endPoint].
			endPoint := (x := cs first atWrap: i + 1) @ (y := cs fifth atWrap: i + 1).
			endPointsBlock value: beginPoint value: endPoint.
			beginPoint := endPoint]
]

{ #category : #private }
TLPolygonMorph >> privateMoveBy: delta [
	super privateMoveBy: delta.
	vertices := self vertices collect: [:p | p + delta].
	curveState := nil.  "Force recomputation"
	(self valueOfProperty: #referencePosition) ifNotNil:
		[:oldPos | self setProperty: #referencePosition toValue: oldPos + delta]
]

{ #category : #geometry }
TLPolygonMorph >> referencePosition [ 
	"Return the current reference position of the receiver"
	^ self valueOfProperty: #referencePosition ifAbsent: [super referencePosition]

]

{ #category : #caching }
TLPolygonMorph >> releaseCachedState [

	super releaseCachedState.
	curveState := nil
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

{ #category : #'cubic support' }
TLPolygonMorph >> segmentedSlopesOf: knots [ 
	"For a collection of floats. Returns the slopes for straight 
	segments between vertices."
	"last slope closes the polygon. Always return same size as 
	self. "
	^ knots collectWithIndex: [:x :i | (knots atWrap: i + 1) - x]
]

{ #category : #drawing }
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

{ #category : #drawing }
TLPolygonMorph >> setSecondColorDashOnStroke: anAthensStrokePaint [
	| d c commonOffset |
	d := self dashedBorder.
	c := d third.
	commonOffset := d size > 3
		ifTrue: [ d fourth ]
		ifFalse: [ 0 ].
	anAthensStrokePaint fillPaint: c.
	anAthensStrokePaint
		dashes:
			{(d second).
			(d first)}
		offset: commonOffset + d second
]

{ #category : #private }
TLPolygonMorph >> setVertices: newVertices [
	newVertices size <= 2 ifTrue: [ self error: 'We need at least 3 points for a polygon.' ].
	vertices := newVertices.
	self computeBounds
]

{ #category : #smoothing }
TLPolygonMorph >> slopes: knots [
	"Choose slopes according to state of polygon"

	^ self isCurve
		ifTrue: [ self closedCubicSlopesOf: knots ]
		ifFalse: [ self segmentedSlopesOf: knots ]
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
