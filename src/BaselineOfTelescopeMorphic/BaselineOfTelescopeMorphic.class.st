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
			self 
				geometry: spec;
				telescope: spec.
			
			"Packages"
			spec package: 'Telescope-Morphic' with: [ spec requires: #('Telescope' 'Geometry') ] ]
]

{ #category : #dependencies }
BaselineOfTelescopeMorphic >> geometry: spec [
	spec
		baseline: 'Geometry'
		with: [ spec
				loads: #('Core');
				repository: 'github://TelescopeSt/Geometry:v1.x.x/src' ]
]

{ #category : #dependencies }
BaselineOfTelescopeMorphic >> telescope: spec [
	spec baseline: 'Telescope' with: [ spec repository: 'github://TelescopeSt/Telescope:v2.x.x/src' ]
]
