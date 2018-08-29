Class {
	#name : #TLMorphicConnector,
	#superclass : #TLViewConnector,
	#category : #'Telescope-Morphic'
}

{ #category : #accessing }
TLMorphicConnector class >> priority [
	^ 1000
]

{ #category : #layout }
TLMorphicConnector >> applyLayoutOf: aTLVisualization on: aCollection [ 
	aTLVisualization layout on: aCollection
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
	 Still need to return aCollection."
	
	^ aCollection
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
