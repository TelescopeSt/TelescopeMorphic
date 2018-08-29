Class {
	#name : #TLMorphSimpleNode,
	#superclass : #Morph,
	#category : #'Telescope-Morphic'
}

{ #category : #'instance creation' }
TLMorphSimpleNode class >> fromSimpleNode: aTLSimpleNode [
	^ self new
		adaptToStylesheet: aTLSimpleNode effectiveStyleSheet;
		yourself
]

{ #category : #adapting }
TLMorphSimpleNode >> adaptToStylesheet: aTLStylesheet [
	self flag: 'Delegate to shapeMorph';
		color: aTLStylesheet backgroundColor;
		borderColor: aTLStylesheet borderColor;
		borderWidth: aTLStylesheet borderWidth;
		width: aTLStylesheet width;
		height: aTLStylesheet height
		
]

{ #category : #testing }
TLMorphSimpleNode >> occupyMaxSpace [
	^ false
]
