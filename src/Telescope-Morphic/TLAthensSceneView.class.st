"
Description
--------------------

I am a scene specific for Telescope Morphic visualizations. 

I exists for three reasons:
- To correct bugs present in my superclass and in AthensInteractiveScene (This should be later moved in Pharo directly)
- To add new features such as rotations
- To pass events to the morphs I contains (Because AthensInteractiveScene does not work well...)

As new feature I add the possibility to rotate the scene by pressing shift + mouse wheel scrolling.

Examples
--------------------

	TLAthensSceneView new
		scene: (AthensMorphScene new morph: aTLMorphicVisualization);
		openInWindowLabeled: 'MyTitle'.	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	shiftPressed:		<aBoolean> 	I store informations about the shift key. I am true if it is pressed, else I am false.

"
Class {
	#name : #TLAthensSceneView,
	#superclass : #AthensSceneView,
	#instVars : [
		'shiftPressed'
	],
	#category : #'Telescope-Morphic'
}

{ #category : #initialization }
TLAthensSceneView >> addResetButton [
	self
		addMorph:
			(PluggableButtonMorph
				newButtonFor: self
				action: #resetTransformations
				label: 'Reset'
				help: 'Reset the transfomations of the visu')
]

{ #category : #accessing }
TLAthensSceneView >> athensSceneView [
	^ self
]

{ #category : #colors }
TLAthensSceneView >> backgroundColor [
	^ Smalltalk ui theme backgroundColor
]

{ #category : #colors }
TLAthensSceneView >> debugTextColor [
	^ Smalltalk ui theme textColor
]

{ #category : #drawing }
TLAthensSceneView >> drawDebugInfosOn: canvas [
	| px py shx shy sx |
	self flag: #todo.	"We should refactor the superclass in Pharo."
	self showDebugInfo ifFalse: [ ^ self ].
	
	px := transform x printShowingDecimalPlaces: 3.
	py := transform y printShowingDecimalPlaces: 3.
	shx := transform shx printShowingDecimalPlaces: 3.
	shy := transform shy printShowingDecimalPlaces: 3.
	sx := transform sx printShowingDecimalPlaces: 3.
	
	canvas
		drawString: 'zoom: ' , sx , ' pan: ' , px , ' @ ' , py , ' shx: ' , shx , ' shy: ' , shy
		at: bounds origin
		font: nil
		color: self debugTextColor
]

{ #category : #drawing }
TLAthensSceneView >> drawOn: canvas [
	canvas fillRectangle: bounds color: self backgroundColor.
	self renderScene.
	surface displayOnMorphicCanvas: canvas at: bounds origin.
	self drawDebugInfosOn: canvas
]

{ #category : #'event handling' }
TLAthensSceneView >> eventHandledByScene: evt [
	^ scene handleEvent: evt in: self
]

{ #category : #'event handling' }
TLAthensSceneView >> handlesKeyboard: evt [
	"I need to handles focus to know when the user will press shift"
	
	^ true
]

{ #category : #'event handling' }
TLAthensSceneView >> handlesMouseMove: evt [
	^ true
]

{ #category : #initialization }
TLAthensSceneView >> initialize [
	super initialize.
	keepRefreshing := true.	"If I do not set this to true, the events are messed up when I move the window. The events going to the old bounds works, but not the ones from the new bounds. Maybe there is a bug somewhere?"
	shiftPressed := false.
	self addResetButton
]

{ #category : #testing }
TLAthensSceneView >> isInTransformationState [
	^ #(#panning #zooming #rotating) anySatisfy: [ :transformationState | self inState: transformationState ]
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
	self takeKeyboardFocus. "I need to take keyboard focus in order to get event on keystrokes"
	self isInTransformationState ifFalse: [ (self eventHandledByScene: evt) ifTrue: [ ^ self ] ].
	^ super mouseDown: evt
]

{ #category : #'event handling' }
TLAthensSceneView >> mouseMove: evt [
	self isInTransformationState ifFalse: [ (self eventHandledByScene: evt) ifTrue: [ ^ self ] ].
	^ super mouseMove: evt
]

{ #category : #'event handling' }
TLAthensSceneView >> mouseUp: evt [
	self isInTransformationState ifFalse: [ (self eventHandledByScene: evt) ifTrue: [ ^ self ] ].
	^ super mouseUp: evt
]

{ #category : #'event handling' }
TLAthensSceneView >> mouseWheel: event [
	"If shift is pressed, we enter a rotation state."

	^ shiftPressed
		ifTrue: [ | rotation |
			event isDown ifTrue: [ ^ false ]. "For now I allow only rotation in one direction because I use a factor to smooth animation and it does not yet handle negative degree of rotation. Later we should rotate in the other way and improve the smoothing."

			rotation := 5.
			(self inState: #rotating)
				ifTrue: [ self updateRotation: rotation cursor: event cursorPoint ]
				ifFalse: [ | center |
					center := transform inverseTransform: event cursorPoint - bounds origin.
					self startRotating: rotation center: center ] ]
		ifFalse: [ super mouseWheel: event ]
]

{ #category : #'event handling' }
TLAthensSceneView >> pointPositionInScene: pt [
	^ transform inverseTransform: (pt - self topLeft)
]

{ #category : #initialization }
TLAthensSceneView >> resetTransformations [
	transform loadIdentity
]

{ #category : #accessing }
TLAthensSceneView >> scene: aScene [
	aScene morph privateOwner: self.
	^ super scene: aScene
]

{ #category : #drawing }
TLAthensSceneView >> showDebugInfo [
	^ TLMorphic development
]

{ #category : #'rotation animation' }
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
		| now start end center targetRotationDegree factor |

		now := Time millisecondClockValue.
		start := rotationState at: 4.
		end := rotationState at: 5.
		
		(now between: start and:end) ifFalse: [ now := end.
			self resetState: #rotating.
			self stopStepping ].
		
		transform := (rotationState at: 2) copy.
		center := rotationState at: 1.
		
		factor :=  (now-start)/(end - start ).
		targetRotationDegree := rotationState at: 3.
		targetRotationDegree := 1* (1-factor) + (targetRotationDegree * factor).
		
		transform
			translateBy: center;
			rotateByDegrees: targetRotationDegree;
			translateBy: center negated.
		
	].
	super step
]

{ #category : #'rotation animation' }
TLAthensSceneView >> updateRotation: rotation cursor: cursorPoint [

	| rotationState targetRotationDegree start end now fraction newCenter |
	rotationState := state at: #rotating.
		
	"change the target zoom and increase time a bit"
	targetRotationDegree := rotationState at: 3.
	
	start := rotationState at: 4.
	end := rotationState at: 5.
		
	now := Time millisecondClockValue.
	
	now := now min: end.
	
	 "interpolate linearly the target rotation factor over time start ... end"
	fraction := (now - start) / (end - start).
	
	"rotation goes from 1..target rotation"
	targetRotationDegree := 1*(1-fraction) + (targetRotationDegree * fraction).

	self step. "to update transform"
	rotationState at: 3 put: targetRotationDegree * rotation.
	newCenter :=   transform inverseTransform: (cursorPoint - bounds origin).
	rotationState at: 1 put: newCenter.
	rotationState at: 2 put: transform copy.
	rotationState at: 4 put: now.
	rotationState at: 5 put: now + 250

]
