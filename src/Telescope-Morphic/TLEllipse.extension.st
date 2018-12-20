Extension { #name : #TLEllipse }

{ #category : #'*Telescope-Morphic' }
TLEllipse class >> asGShape [
	^ GEllipse center: 0 , 0 vertex: 1 , 0 coVertex: 0 , 1
]
