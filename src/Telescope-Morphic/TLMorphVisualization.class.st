Class {
	#name : #TLMorphVisualization,
	#superclass : #TransformMorph,
	#category : #'Telescope-Morphic'
}

{ #category : #'geometry testing' }
TLMorphVisualization >> containsPoint: aPoint [
	^ self bounds containsPoint: aPoint
]

{ #category : #'events-processing' }
TLMorphVisualization >> handlesMouseWheel: evt [
	^ true
]

{ #category : #initialization }
TLMorphVisualization >> initialize [
	super initialize.
	self color: self theme backgroundColor
]

{ #category : #'events-processing' }
TLMorphVisualization >> mouseWheel: evt [
	self flag: #todo.	"Maybe we should not hardcode the min and max"
	evt isUp
		ifTrue: [ self scale: (self scale + 1 min: 500) ].
	evt isDown
		ifTrue: [ self
				scale:
					(self scale
						-
							(self scale - 1 < 1
								ifTrue: [ 0.1 ]
								ifFalse: [ 1 ]) max: 0.1) ]
]

{ #category : #accessing }
TLMorphVisualization >> wantsToBeTopmost [ 
	^true
]
