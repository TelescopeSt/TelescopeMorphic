Extension { #name : #TLStyleSheet }

{ #category : #'*Telescope-Morphic' }
TLStyleSheet >> applyMorphicNodeStyleFor: aNode on: aMorph [ 
	| nodeLabelPosition shape |
	self flag: #todo. "Not finished"
	aMorph
		color: (self obtainValue: #backgroundColor forEntity: aNode  inNode: aNode);
		borderColor: (self obtainValue: #borderColor forEntity: aNode  inNode: aNode);
		borderWidth: (self obtainValue: #borderWidth forEntity: aNode  inNode: aNode);
		width: (self obtainValue: #width forEntity: aNode  inNode: aNode);
		height: (self obtainValue: #height forEntity: aNode  inNode: aNode).
	"nodeLabelPosition := TLPosition for: (self obtainValue: #nodeLabelPosition forEntity: aNode  inNode: aNode)."

			
			"(#'border-opacity' -> [ :t | [ :e :n | (t obtainValue: #borderColor forEntity: e inNode: n) alpha ] ]).
			(#'border-style' -> #borderStyle).
			(#'background-image' -> #backgroundImageUrl).
			(#'background-image-opacity' -> #backgroundImageOpacity).
			(#'background-opacity' -> [ :t | [ :e :n | (t obtainValue: #backgroundColor forEntity: e inNode: n) alpha ] ]).
			(#label -> #nodeLabel).
			(#color -> #textColor).
			(#'font-size' -> #labelSize).
			(#'text-wrap' -> #nodeLabelWrap).
			(#'text-max-width' -> #nodeLabelMaxWidth)"
	

		"at: 'text-halign' put: nodeLabelPosition horizontal;
		at: 'text-valign' put: nodeLabelPosition vertical."
"	shape := self obtainValue: #shape forEntity: aNode entity inNode: aNode.
	styleDictionary at: shape cytoscapeAttribute put: shape forCytoscapeNode.
	styleDictionary
		at: #shape
		ifPresent: [ :s | 
			s = ''
				ifTrue: [" "This is a 'TLNoShape'"
					"styleDictionary
						at: #shape put: TLRectangle forCytoscapeNode;
						at: #'border-opacity' put: 0 forCytoscapeNode ] ].
	shape cytoscapeAttribute = #shape
		ifFalse: [ styleDictionary at: #shape put: #polygon ].
	(aNode isComposite and: [ aNode hasChildrenToDisplay ])
		ifTrue: [ self adaptStyleForComposite: styleDictionary ].
	""If we do not give an empty label to cytoscape when there is no label, it zill not remove a potential current label.""
	styleDictionary at: 'label' ifAbsentPut: [ '' ].
	^ styleDictionary"
]
