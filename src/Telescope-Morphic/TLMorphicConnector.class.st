Class {
	#name : #TLMorphicConnector,
	#superclass : #TLViewConnector,
	#category : #'Telescope-Morphic'
}

{ #category : #accessing }
TLMorphicConnector class >> priority [
	^ 1000
]

{ #category : #opening }
TLMorphicConnector >> open: aTLVisualization inWindowSized: aPoint titled: aString [ 
	| morph |
	morph := TLMorphVisualization new.
	morph extent: aPoint.
	morph openInWindowLabeled: aString.
	^ morph
]
