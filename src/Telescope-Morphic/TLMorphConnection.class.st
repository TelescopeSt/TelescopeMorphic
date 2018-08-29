Class {
	#name : #TLMorphConnection,
	#superclass : #Morph,
	#instVars : [
		'fromMorph',
		'toMorph'
	],
	#category : #'Telescope-Morphic'
}

{ #category : #'instance creation' }
TLMorphConnection class >> fromConnection: aTLConnection [
	^ self new
		adaptToStylesheet: aTLConnection effectiveStyleSheet;
		yourself
]

{ #category : #adapting }
TLMorphConnection >> adaptToStylesheet: aTLStylesheet [
	self flag: 'TODO: manage width, etc...';
		color: aTLStylesheet color
]

{ #category : #connecting }
TLMorphConnection >> connect: aTLMorphSimpleNode to: aTLMorphSimpleNode2 [ 
	self
		fromMorph: aTLMorphSimpleNode;
		toMorph: aTLMorphSimpleNode2
]

{ #category : #drawing }
TLMorphConnection >> drawOn: aCanvas [
	aCanvas
		line: self fromMorph center to: self toMorph center color: self color
]

{ #category : #accessing }
TLMorphConnection >> fromMorph [
	^ fromMorph
]

{ #category : #accessing }
TLMorphConnection >> fromMorph: anObject [
	fromMorph := anObject
]

{ #category : #accessing }
TLMorphConnection >> toMorph [
	^ toMorph
]

{ #category : #accessing }
TLMorphConnection >> toMorph: anObject [
	toMorph := anObject
]
