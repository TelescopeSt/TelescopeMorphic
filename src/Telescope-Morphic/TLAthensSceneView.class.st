Class {
	#name : #TLAthensSceneView,
	#superclass : #AthensInteractiveScene,
	#category : #'Telescope-Morphic'
}

{ #category : #colors }
TLAthensSceneView >> backgroundColor [
	^ Smalltalk ui theme backgroundColor
]

{ #category : #drawing }
TLAthensSceneView >> drawOn: canvas [
	| px py |
	canvas fillRectangle: bounds color: self backgroundColor.
	self renderScene.

	surface displayOnMorphicCanvas: canvas at: bounds origin.

"	 translucentImage: surface asForm at: bounds origin."
	self flag: #todo. "Make version in Pharo more customable"
	self showDebugInfo
		ifTrue: [ 
			px := transform x printShowingDecimalPlaces: 3.
			py := transform y printShowingDecimalPlaces: 3.
			canvas
				drawString: 'zoom: ' , (transform sx printShowingDecimalPlaces: 3) , ' pan: ' , px , ' @ ' , py
				at: bounds origin
				font: nil
				color: Smalltalk ui theme textColor ]
]

{ #category : #drawing }
TLAthensSceneView >> showDebugInfo [
	^ TLMorphic development
]
