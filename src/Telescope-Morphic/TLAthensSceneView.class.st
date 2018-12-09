Class {
	#name : #TLAthensSceneView,
	#superclass : #AthensInteractiveScene,
	#instVars : [
		'shiftPressed'
	],
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
				drawString: 'zoom: ' , (transform sx printShowingDecimalPlaces: 3) , ' pan: ' , px , ' @ ' , py , ' shx: ' , transform shx asString , ' shy: ' , transform shy asString
				at: bounds origin
				font: nil
				color: Smalltalk ui theme textColor ]
]

{ #category : #'event handling' }
TLAthensSceneView >> eventPositionInScene: evt [
	| pt |
	pt := evt position - self topLeft.
	^ transform inverseTransform: pt
]

{ #category : #'event handling' }
TLAthensSceneView >> handlesKeyboard: evt [
	^ true
]

{ #category : #'initialize-release' }
TLAthensSceneView >> initialize [ 
	super initialize.
	shiftPressed := false
]

{ #category : #'event handling' }
TLAthensSceneView >> keyDown: evt [
	evt keyValue = 16 ifTrue: [ shiftPressed := true ].
	^ super keyDown: evt
]

{ #category : #'event handling' }
TLAthensSceneView >> keyUp: evt [
	evt keyValue = 16 ifTrue: [ shiftPressed := false ].
	^ super keyUp: evt
]

{ #category : #'event handling' }
TLAthensSceneView >> mouseDown: evt [
	self takeKeyboardFocus.
	super mouseDown: evt
]

{ #category : #'event handling' }
TLAthensSceneView >> mouseWheel: event [
	"Handle a mouseWheel event."

	^ shiftPressed
		ifTrue: [ | rotation |
			event isDown
				ifTrue: [ ^ false ].
			rotation := 5.
			(self inState: #rotating)
				ifTrue: [ self updateRotation: rotation cursor: event cursorPoint ]
				ifFalse: [ | center |
					center := transform inverseTransform: event cursorPoint - bounds origin.
					self startRotating: rotation center: center ] ]
		ifFalse: [ super mouseWheel: event ]
]

{ #category : #drawing }
TLAthensSceneView >> showDebugInfo [
	^ TLMorphic development
]

{ #category : #'as yet unclassified' }
TLAthensSceneView >> startRotating: rotation center: center [
	| start end |

		
	start := Time millisecondClockValue.
	end := start + 250.

	self setState: #rotating value: {  center. transform copy. rotation. start. end}.

	self startStepping
]

{ #category : #'zoom animation' }
TLAthensSceneView >> step [

	self inState: #rotating do: [ :rotationState |
		| now start end center targetZoom factor |

		now := Time millisecondClockValue.
		start := rotationState at: 4.
		end := rotationState at: 5.
		
		(now between: start and:end) ifFalse: [ now := end.
			self resetState: #rotating.
			self stopStepping ].
		
		transform := (rotationState at: 2) copy.
		center := rotationState at: 1.
		
		factor :=  (now-start)/(end - start ).
		targetZoom := rotationState at: 3.
		targetZoom := 1* (1-factor) + (targetZoom * factor).
		
		transform
			translateBy: center;
			rotateByDegrees: targetZoom;
			translateBy: center negated.
		
	].
	super step
]

{ #category : #'as yet unclassified' }
TLAthensSceneView >> updateRotation: rotation cursor: cursorPoint [

	| rotationState targetZoom start end now fraction newCenter |
	rotationState := state at:#rotating.
		
	"change the target zoom and increase time a bit"
	targetZoom := rotationState at: 3.
	
	start := rotationState at: 4.
	end := rotationState at: 5.
		
	now := Time millisecondClockValue.
	
	now := now min: end.
	
	 "interpolate linearly the target zoom factor over time start ... end"
	fraction := (now - start) / (end - start).
	
	"zoom goes from 1..target zoom"
	targetZoom := 1*(1-fraction) + (targetZoom * fraction).

	self step. "to update transform"
	rotationState at: 3 put: targetZoom * rotation.
	newCenter :=   transform inverseTransform: (cursorPoint - bounds origin).
	rotationState at: 1 put: newCenter.
	rotationState at: 2 put: transform copy.
	rotationState at: 4 put: now.
	rotationState at: 5 put: now + 250

]
