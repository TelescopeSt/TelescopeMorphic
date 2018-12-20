Extension { #name : #GEllipse }

{ #category : #'*Telescope-Morphic' }
GEllipse >> asAthensPathOn: anAthensCanvas [
	| halfWidth halfHeight |
	halfWidth := self semiMajorAxisLength asFloat.
	halfHeight := self semiMinorAxisLength asFloat.
	^ anAthensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: (self center x @ self center y);
				relative;
				moveTo: halfWidth negated @ 0;
				curveVia: 0 @ (halfHeight negated * 0.55) and: (0.45 * halfWidth) @ halfHeight negated to: halfWidth @ halfHeight negated;
				curveVia: (halfWidth * 0.55) @ 0 and: halfWidth @ (0.45 * halfHeight) to: halfWidth @ halfHeight;
				curveVia: 0 @ (halfHeight * 0.55) and: (0.45 * halfWidth negated) @ halfHeight to: halfWidth negated @ halfHeight;
				curveVia: (halfWidth negated * 0.55) @ 0 and: halfWidth negated @ (halfHeight negated * 0.45) to: halfWidth negated @ halfHeight negated ]
]
