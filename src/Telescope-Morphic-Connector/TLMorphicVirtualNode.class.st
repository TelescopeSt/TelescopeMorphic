Class {
	#name : #TLMorphicVirtualNode,
	#superclass : #TLVirtualNode,
	#instVars : [
		'morph'
	],
	#category : #'Telescope-Morphic-Connector'
}

{ #category : #accessing }
TLMorphicVirtualNode >> dimensionChangedHook [
	morph extent: self dimension
]

{ #category : #accessing }
TLMorphicVirtualNode >> morph [
	^ morph
]

{ #category : #accessing }
TLMorphicVirtualNode >> morph: anObject [
	morph := anObject
]

{ #category : #accessing }
TLMorphicVirtualNode >> position: anObject [
	morph position: anObject.
	^ super position: anObject
]
