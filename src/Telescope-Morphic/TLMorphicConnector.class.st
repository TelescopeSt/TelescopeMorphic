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
	
	morphicNode modelNode: aTLNode. self flag: #TODO. "This is a hack."
	
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
	aCollection ifNotEmpty: [ self flag: #todo ]
]

{ #category : #'generation - interaction' }
TLMorphicConnector >> generateClickInteraction: aTLClickInteraction onDrawable: aTLSimpleNode targetingDrawable: aTLSimpleNode3 [ 
	self flag: #todo
]

{ #category : #'generation - interaction' }
TLMorphicConnector >> generateMouseOverInteraction: aTLMouseOverInteraction onDrawable: aTLSimpleNode targetingDrawable: aTLSimpleNode3 [ 
	self flag: #todo
]

{ #category : #'generation-legendEntry' }
TLMorphicConnector >> generateNodeShapeLegendEntry: aTLNodeShapeLegendEntry [ 
	self flag: #todo
]

{ #category : #accessing }
TLMorphicConnector >> nodesShapesAvailableForConnector [
	^ TLSimpleShape allSubclasses select: [ :class | [ class asMorphNode. true ] on: TLNotSupportedFunctionalityException do: [ false ] ]
]

{ #category : #opening }
TLMorphicConnector >> open: aTLVisualization inWindowSized: aPoint titled: aString [ 
	| morph window |
	morph := TLMorphVisualization new.
	
	self view: morph.
	self generateVisualization: aTLVisualization.
	
	window := TLAthensSceneView new
		scene: (AthensMorphScene new morph: morph);
		openInWindowLabeled: aString.
		
	window extent: aPoint.
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
