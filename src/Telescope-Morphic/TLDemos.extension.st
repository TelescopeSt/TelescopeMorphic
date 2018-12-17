Extension { #name : #TLDemos }

{ #category : #'*Telescope-Morphic' }
TLDemos class >> exampleAAAMorphic [
	<script: 'self exampleAAAMorphic open'>
	<tlFilter: #style>
	| visualization |
	self flag: #todo. "This is a temporary demo to dev Monphic connector"
	visualization := TLVisualization new.
	visualization styleSheet
		width: 40;
		height: 40;
		nodeLabel: #displayName;
		shape: #yourself.
	visualization layout: TLCircularLayout.
	visualization legend nodeShapeDescription: #displayName forNodes: [ visualization obtain recursively nodes ].
	visualization addNodesFromEntities: visualization generator nodesShapesAvailableForConnector.
	30 timesRepeat: [ visualization nodes atRandom connectIfNotTo: visualization nodes atRandom ].
	^ visualization
]
