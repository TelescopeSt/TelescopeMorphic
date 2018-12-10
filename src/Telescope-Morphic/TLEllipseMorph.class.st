Class {
	#name : #TLEllipseMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'ellipse'
	],
	#category : #'Telescope-Morphic-Morphs'
}

{ #category : #athens }
TLEllipseMorph >> asAthensShapeOn: anAthensCanvas [
	| halfWidth halfHeight |
	self bounds area > 0
		ifFalse: [ ^ self ].
	halfWidth := self bounds width / 2 asFloat.
	halfHeight := self bounds height / 2 asFloat.
	^ anAthensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: self bounds center;
				relative;
				moveTo: halfWidth negated @ 0;
				curveVia: 0 @ (halfHeight negated * 0.55)
					and: (0.45 * halfWidth) @ halfHeight negated
					to: halfWidth @ halfHeight negated;
				curveVia: (halfWidth * 0.55) @ 0 and: halfWidth @ (0.45 * halfHeight) to: halfWidth @ halfHeight;
				curveVia: 0 @ (halfHeight * 0.55) and: (0.45 * halfWidth negated) @ halfHeight to: halfWidth negated @ halfHeight;
				curveVia: (halfWidth negated * 0.55) @ 0
					and: halfWidth negated @ (halfHeight negated * 0.45)
					to: halfWidth negated @ halfHeight negated ]
]

{ #category : #'geometry testing' }
TLEllipseMorph >> containsPoint: aPoint [

	| radius other delta xOverY |
	(bounds containsPoint: aPoint) ifFalse: [^ false].  "quick elimination"
	(bounds width = 1 or: [bounds height = 1])
		ifTrue: [^ true].  "Degenerate case -- code below fails by a bit"

	radius := bounds height asFloat / 2.
	other := bounds width asFloat / 2.
	delta := aPoint - bounds topLeft - (other@radius).
	xOverY := bounds width asFloat / bounds height asFloat.
	^ (delta x asFloat / xOverY) squared + delta y squared <= radius squared
]

{ #category : #accessing }
TLEllipseMorph >> couldHaveRoundedCorners [
	^ false
]

{ #category : #athens }
TLEllipseMorph >> drawOnAthensCanvas: anAthensCanvas [
	| border shape |
	self bounds area > 0
		ifFalse: [ ^ self ].
	border := self borderStyle.
	shape := self asAthensShapeOn: anAthensCanvas.
	anAthensCanvas setPaint: self fillStyle.
	anAthensCanvas setShape: shape.
	anAthensCanvas draw.
	(anAthensCanvas setStrokePaint: border color) width: border width.
	anAthensCanvas draw
]

{ #category : #accessing }
TLEllipseMorph >> ellipse [
	^ ellipse
]

{ #category : #accessing }
TLEllipseMorph >> ellipse: anObject [
	ellipse := anObject
]
