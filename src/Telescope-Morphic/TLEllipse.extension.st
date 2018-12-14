Extension { #name : #TLEllipse }

{ #category : #'*Telescope-Morphic' }
TLEllipse class >> asGShape [
	TLNotSupportedFunctionalityException signal.
	^ GEllipse center: 0 @ 0 xRadius: 1 yRadius: 1
]
