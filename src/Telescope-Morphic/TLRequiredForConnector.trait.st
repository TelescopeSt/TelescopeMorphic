Trait {
	#name : #TLRequiredForConnector,
	#instVars : [
		'modelNode'
	],
	#category : #'Telescope-Morphic'
}

{ #category : #testing }
TLRequiredForConnector >> isNode [
	^ true
]

{ #category : #accessing }
TLRequiredForConnector >> modelNode [
	self flag: #TODO. "Should not need to hold this node. Issue in Telescope connector."
	^ modelNode
]

{ #category : #accessing }
TLRequiredForConnector >> modelNode: aTLNode [
	self flag: #TODO. "Should not need to hold this node. Issue in Telescope connector."
	modelNode := aTLNode
]

{ #category : #testing }
TLRequiredForConnector >> occupyMaxSpace [
	^ false
]

{ #category : #accessing }
TLRequiredForConnector >> position: aPoint [
	super position: self owner position + aPoint
]
