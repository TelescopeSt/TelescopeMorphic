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
			spec
				package: 'Telescope-Morphic' with: [ spec requires: #('Telescope' 'Geometry') ];
				package: 'Telescope-Morphic-Connector' with: [ spec requires: #('Telescope-Morphic') ] ]
]

{ #category : #dependencies }
BaselineOfTelescopeMorphic >> geometry: spec [
	spec
		baseline: 'Geometry'
		with: [ spec
				loads: #('Core');
				repository: 'github://TelescopeSt/Geometry:master/src' ]
]

{ #category : #dependencies }
BaselineOfTelescopeMorphic >> telescope: spec [
	spec baseline: 'Telescope' with: [ spec repository: 'github://TelescopeSt/Telescope:development/src' ]
]
