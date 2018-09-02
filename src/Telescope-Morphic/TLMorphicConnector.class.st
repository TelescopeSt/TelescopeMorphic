Class {
	#name : #TLMorphicConnector,
	#superclass : #TLViewConnector,
	#category : #'Telescope-Morphic'
}

{ #category : #accessing }
TLMorphicConnector class >> priority [
	^ 1000
]

{ #category : #view }
TLMorphicConnector >> addElementConnectionInView: aTLMorphConnection [ 
	self view
		addMorph: aTLMorphConnection
]

{ #category : #view }
TLMorphicConnector >> addElementLegendInView: aTLMorphicConnector [
	Halt if: [ aTLMorphicConnector ~= self ].
	self flag: 'TODO'
]

{ #category : #view }
TLMorphicConnector >> addElementNodeInView: element [
	self view
		addMorph: element
]

{ #category : #layout }
TLMorphicConnector >> applyLayoutOf: aTLVisualization on: aCollection [ 
	aTLVisualization layout on: aCollection
]

{ #category : #'generation - connection' }
TLMorphicConnector >> createElementConnection: aTLConnection From: aTLSimpleNode to: anotherTLSimpleNode [
	| morphicConnection |
	morphicConnection := aTLConnection asMorphicConnection.
	morphicConnection
		connect: (self shapeByDrawable at: aTLSimpleNode) to: (self shapeByDrawable at: anotherTLSimpleNode).
	
	self registerShape: morphicConnection forDrawable: aTLConnection.
	
	^ morphicConnection
]

{ #category : #'generation - node' }
TLMorphicConnector >> createElementNodeFromNode: aTLNode [
	| morphicNode |
	morphicNode := aTLNode asMorphicNode.
	
	self registerShape: morphicNode forDrawable: aTLNode.
	
	^ morphicNode
]

{ #category : #'generation - group' }
TLMorphicConnector >> createGroup: aTLGroup with: aCollection [ 
	"Not needed here because a group is not displayed in the visu.
	 Still need to return a collection."
	^ aCollection
]

{ #category : #'generation - legend' }
TLMorphicConnector >> createLegendFrom: aCollection [ 
	aCollection ifNotEmpty: [ 
		self halt: 'TODO' ]
]

{ #category : #opening }
TLMorphicConnector >> open: aTLVisualization inWindowSized: aPoint titled: aString [ 
	| morph |
	morph := TLMorphVisualization new.
	morph extent: aPoint.
	
	self view: morph.
	self generateVisualization: aTLVisualization.
	
	morph openInWindowLabeled: aString.
	^ morph
]

{ #category : #'updating - legend' }
TLMorphicConnector >> updateLegend: aTLLegend [ 
	self flag: 'TODO'
]

{ #category : #view }
TLMorphicConnector >> updateViewForVisualization: aTLVisualization [ 
	self flag: 'TODO'
]
