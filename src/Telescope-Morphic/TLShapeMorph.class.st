Class {
	#name : #TLShapeMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'shape'
	],
	#category : #'Telescope-Morphic-Morphs'
}

{ #category : #accessing }
TLShapeMorph >> couldHaveRoundedCorners [
	^ false
]

{ #category : #accessing }
TLShapeMorph >> shape [
	^ shape
]

{ #category : #accessing }
TLShapeMorph >> shape: aGShape [
	shape = aGShape ifTrue: [ ^ self ].
	
	shape := aGShape.
	self computeBounds
]

{ #category : #TODO }
TLShapeMorph >> todo [
	self flag: #todo.
	"
	Later most of the logic of my subclasses should be here. 
	
	To do that I need to refactor the EllipseMorph to be based on a GEllipse and to work in the same way than the PolygonMorph.
	
	Then we can ask the athens shape path to the GElement and have a common API. 
	
	In the long terme it would be really cool if this morph and its subclasses could become only one morph and we could merge it with TLMorphSimpleNode.
	
	"
]
