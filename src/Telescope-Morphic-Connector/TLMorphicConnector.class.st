Class {
	#name : #TLMorphicConnector,
	#superclass : #TLViewConnector,
	#category : #'Telescope-Morphic-Connector'
}

{ #category : #accessing }
TLMorphicConnector class >> priority [
	^ 1000
]

{ #category : #view }
TLMorphicConnector >> addElementConnectionInView: aTLMorphConnection [ 
	self view addMorph: aTLMorphConnection
]

{ #category : #view }
TLMorphicConnector >> addElementLegendInView: aTLMorphicConnector [
	Halt if: [ aTLMorphicConnector ~= self ].
	self flag: 'TODO'
]

{ #category : #view }
TLMorphicConnector >> addElementNodeInView: element [
	self view addMorph: element morph
]

{ #category : #layout }
TLMorphicConnector >> applyLayoutOf: aTLVisualization on: aCollection [ 
	aTLVisualization layout on: aCollection
]

{ #category : #'generation - connection' }
TLMorphicConnector >> createElementConnection: aTLConnection From: aTLSimpleNode to: anotherTLSimpleNode [
	| morphicConnection |
	self flag: #todo.	"Later we should have virtual connections"
	morphicConnection := aTLConnection asMorphicConnection.
	morphicConnection connect: (self shapeByDrawable at: aTLSimpleNode) morph to: (self shapeByDrawable at: anotherTLSimpleNode) morph.
	^ morphicConnection
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

{ #category : #'generation - node' }
TLMorphicConnector >> newVirtualNodeFor: aTLNode [
	^ (super newVirtualNodeFor: aTLNode)
		morph: aTLNode asMorphicNode;
		yourself
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

{ #category : #dependencies }
TLMorphicConnector >> virtualNodeClass [
	^ TLMorphicVirtualNode
]
