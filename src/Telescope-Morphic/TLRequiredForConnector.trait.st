Trait {
	#name : #TLRequiredForConnector,
	#category : #'Telescope-Morphic'
}

{ #category : #testing }
TLRequiredForConnector >> isNode [
	^ true
]

{ #category : #testing }
TLRequiredForConnector >> occupyMaxSpace [
	^ false
]

{ #category : #accessing }
TLRequiredForConnector >> position: aPoint [
	super position: self owner position + aPoint
]
