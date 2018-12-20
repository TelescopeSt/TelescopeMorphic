Class {
	#name : #TLLabelMorph,
	#superclass : #Morph,
	#instVars : [
		'contents',
		'tlPosition'
	],
	#category : #'Telescope-Morphic-Morphs'
}

{ #category : #'instance creation' }
TLLabelMorph class >> contents: aString position: aTLPosition [
	^ self new
		contents: aString;
		tlPosition: aTLPosition;
		yourself
]

{ #category : #drawing }
TLLabelMorph >> areasRemainingToFill: aRectangle [
	^ Array with: aRectangle
]

{ #category : #'geometry testing' }
TLLabelMorph >> containsPoint: aPoint [
	"Labels should not catch any event"

	^ false
]

{ #category : #accessing }
TLLabelMorph >> contents [

	^ contents
]

{ #category : #accessing }
TLLabelMorph >> contents: newContents [
	contents := newContents.
	self fitContents
]

{ #category : #initialization }
TLLabelMorph >> defaultColor [
	"answer the default color/fill style for the receiver"
	^ self theme textColor
]

{ #category : #drawing }
TLLabelMorph >> drawOnAthensCanvas: canvas [
	| bnd font|
	
	bnd := self bounds topLeft.
	font := StandardFonts defaultFont.

	canvas pathTransform
		restoreAfter: [ canvas pathTransform translateBy: bnd.
			canvas pathTransform translateX: 0 Y: font getPreciseAscent.

			canvas
				setPaint: color;
				setFont: font;
				drawString: contents ]
]

{ #category : #accessing }
TLLabelMorph >> fitContents [

	| newBounds boundsChanged |
	newBounds := self measureContents.
	boundsChanged := bounds extent ~= newBounds.
	self extent: newBounds.		"default short-circuits if bounds not changed"
	boundsChanged ifFalse: [self changed]
]

{ #category : #accessing }
TLLabelMorph >> measureContents [
	"Round up in case fractional."

	| f |
	f := StandardFonts defaultFont.
	^ (((f widthOfString: contents) max: self minimumWidth) @ f height + (self layoutInset * 2)) ceiling
]

{ #category : #accessing }
TLLabelMorph >> minHeight [
	"Answer the minimum height of the receiver."
	
	^self fontToUse height max: super minHeight
]

{ #category : #accessing }
TLLabelMorph >> minimumWidth [
	"Answer the minimum width that the receiver can have.  A nonzero value here keeps the receiver from degenerating into something that cannot ever be seen or touched again!  Obeyed by fitContents."

	^ 3
]

{ #category : #printing }
TLLabelMorph >> printOn: aStream [
	super printOn: aStream.
	aStream print: contents
]

{ #category : #initialization }
TLLabelMorph >> themeChanged [
	self color: self defaultColor.
	super themeChanged
]

{ #category : #accessing }
TLLabelMorph >> tlPosition: aTLPosition [ 
	tlPosition := aTLPosition
]

{ #category : #geometry }
TLLabelMorph >> updatePositionFollowing: aMorph [
	"Maybe we can think of a better way to handle that later but for now it will do."

	| x y |
	tlPosition horizontal = #center ifTrue: [ x := aMorph center x - (self width / 2) asFloat ].
	tlPosition vertical = #center ifTrue: [ y := aMorph center y - (self height / 2) asFloat ].

	tlPosition horizontal = #right ifTrue: [ x := aMorph right ].
	tlPosition vertical = #top ifTrue: [ y := aMorph top - ((self height / 2) asFloat + 10) ].	"We add some margin to not make the label stick the node"

	tlPosition horizontal = #left ifTrue: [ x := aMorph left - self width asFloat ].
	tlPosition vertical = #bottom ifTrue: [ y := aMorph bottom - ((self height / 2) asFloat - 10) ].	"We add some margin to not make the label stick the node"

	self position: x @ y
]
