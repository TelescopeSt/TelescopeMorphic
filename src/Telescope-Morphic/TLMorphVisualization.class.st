Class {
	#name : #TLMorphVisualization,
	#superclass : #Morph,
	#category : #'Telescope-Morphic'
}

{ #category : #initialization }
TLMorphVisualization >> initialize [
	super initialize.
	self color: Smalltalk ui theme backgroundColor
]
