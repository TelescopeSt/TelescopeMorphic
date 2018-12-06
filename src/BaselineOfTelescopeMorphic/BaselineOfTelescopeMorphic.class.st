Class {
	#name : #BaselineOfTelescopeMorphic,
	#superclass : #BaselineOf,
	#category : #BaselineOfTelescopeMorphic
}

{ #category : #baselines }
BaselineOfTelescopeMorphic >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"Dependencies"
			self telescope: spec.
			
			"Packages"
			spec package: 'Telescope-Morphic' with: [ spec requires: 'Telescope' ] ]
]

{ #category : #dependencies }
BaselineOfTelescopeMorphic >> telescope: spec [
	spec baseline: 'Telescope' with: [ spec repository: 'github://TelescopeSt/Telescope:v2.x.x/src' ]
]
