Class {
	#name : #TLMorphic,
	#superclass : #Object,
	#classInstVars : [
		'development'
	],
	#category : #'Telescope-Morphic'
}

{ #category : #'accessing-convenience' }
TLMorphic class >> beDeployment [
	<script>
	self development: false
]

{ #category : #'accessing-convenience' }
TLMorphic class >> beDevelopment [
	<script>
	self development: true
]

{ #category : #'accessing-convenience' }
TLMorphic class >> development [
	^ development ifNil: [ development := false ]
]

{ #category : #accessing }
TLMorphic class >> development: anObject [
	development := anObject
]

{ #category : #'accessing-convenience' }
TLMorphic class >> menuCommandOn: aBuilder [
	"Add a custom menu item to the world menu"

	<worldMenu>
	(aBuilder item: #'Development mode')
		order: 10;
		iconName: #smallDebug;
		parent: #Telescope;
		action: [ self beDevelopment ].
	(aBuilder item: #'Deployment mode')
		order: 20;
		iconName: #smallOk;
		parent: #Telescope;
		action: [ self beDeployment ].
]
