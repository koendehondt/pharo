"
I'm a visitor that generates code whose execution will recreate the visited node (similarly to storeOn: protocol).
This is handy because we can simply serialize the object in a textual form without requiring a separate parser.

I'm used by reflexivity.

try me! 
(ASTDumpVisitor >> #stream) ast dump

Instance Variables
	stream:		<Object>		The stream holding the output. Filled up throughout the visit.


"
Class {
	#name : 'ASTDumpVisitor',
	#superclass : 'ASTProgramNodeVisitor',
	#instVars : [
		'stream'
	],
	#category : 'AST-Core-Visitors',
	#package : 'AST-Core',
	#tag : 'Visitors'
}

{ #category : 'accessing' }
ASTDumpVisitor >> contents [
	^ stream contents
]

{ #category : 'initialization' }
ASTDumpVisitor >> initialize [

	super initialize.
	stream := String new writeStream
]

{ #category : 'initialization' }
ASTDumpVisitor >> stream [
	^ stream
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitAnnotationMarkNode: aRBAnnotationValueNode [
	stream
		nextPutAll: aRBAnnotationValueNode class name;
		nextPutAll: ' new'
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitArrayNode: anArrayNode [
	stream
		nextPutAll: anArrayNode class name;
		nextPutAll: ' statements: { '.
	anArrayNode statements
		do: [ :each |
			each acceptVisitor: self.
			stream nextPutAll: '. ' ].
	stream nextPut: $}
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitAssignmentNode: anAssignmentNode [
	stream
		nextPutAll: anAssignmentNode class name;
		nextPutAll: ' variable: ('.
	anAssignmentNode variable acceptVisitor: self.
	stream nextPutAll: ') value: ('.
	anAssignmentNode value acceptVisitor: self.
	stream nextPut: $)
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitBlockNode: aBlockNode [
	stream nextPutAll: aBlockNode class name.
	aBlockNode arguments
		ifNotEmpty: [ stream nextPutAll: ' arguments: {'.
			aBlockNode arguments
				do: [ :each |
					each acceptVisitor: self.
					stream nextPutAll: '. ' ].
			stream nextPutAll: '}' ].
	stream nextPutAll: ' body: ('.
	aBlockNode body acceptVisitor: self.
	stream nextPut: $)
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitCascadeNode:aCascadeNode [
	stream
		nextPutAll: aCascadeNode class name;
		nextPutAll: ' messages: {'.
	aCascadeNode messages
		do: [ :each |
			each acceptVisitor: self.
			stream nextPutAll: '. ' ].
	stream nextPut: $}
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitEnglobingErrorNode: anEnglobingErrorNode [

	stream
		nextPutAll: '(';
		nextPutAll: anEnglobingErrorNode class name;
		nextPutAll: ' new contents: {'.
	anEnglobingErrorNode contents do: [ :each |
		each acceptVisitor: self.
		stream nextPutAll: '. ' ].
	stream
		nextPutAll: '}; start: ';
		print: anEnglobingErrorNode start;
		nextPutAll: '; stop: ';
		print: anEnglobingErrorNode stop;
		nextPutAll: '; errorPosition: ';
		print: anEnglobingErrorNode errorPosition;
		nextPutAll: '; errorMessage: ';
		print: anEnglobingErrorNode errorMessage;
		nextPutAll: '; value: ';
		print: anEnglobingErrorNode value;
		nextPutAll: '; valueAfter: ';
		print: anEnglobingErrorNode valueAfter;
		nextPutAll: '; yourself)'
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitLiteralArrayNode: aLiteralArrayNode [

	stream nextPutAll: aLiteralArrayNode class name;
		nextPutAll: ' value: ';
		nextPutAll: (
	aLiteralArrayNode isForByteArray
		ifTrue: [ '#['  ]
		ifFalse: [ '#(' ]).
	(aLiteralArrayNode contents collect: [ :each | each value ])
		printOn: stream
		delimiter: ' '.
	stream nextPutAll: (aLiteralArrayNode isForByteArray
			 ifTrue: [ ']' ]
			 ifFalse: [ ')' ])
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitLiteralNode: aLiteralNode [
	self visitLiteralValueNode: aLiteralNode
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitLiteralValueNode: aLiteralValueNode [
	stream
		nextPutAll: aLiteralValueNode class name;
		nextPutAll: ' value: '.
	aLiteralValueNode value printOn: stream
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitMessageNode: aMessageNode [
	stream
		nextPutAll: aMessageNode class name;
		nextPutAll: ' receiver: ('.
	aMessageNode receiver acceptVisitor: self.
	stream nextPutAll: ') selector: '.
	aMessageNode selector printOn: stream.
	aMessageNode arguments
		ifNotEmpty: [ stream nextPutAll: ' arguments: {'.
			aMessageNode arguments
				do: [ :each |
					each acceptVisitor: self.
					stream nextPutAll: '. ' ].
			stream nextPut: $} ]
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitMethodNode: aMethodNode [
	| hasPragmas |
	hasPragmas := aMethodNode pragmas isNotEmpty.
	hasPragmas
		ifTrue: [ stream nextPut: $( ].
	stream
		nextPutAll: aMethodNode class name;
		nextPutAll: ' selector: '.
	aMethodNode selector printOn: stream.
	aMethodNode arguments
		ifNotEmpty: [ stream nextPutAll: ' arguments: {'.
			aMethodNode arguments
				do: [ :each |
					each acceptVisitor:self.
					stream nextPutAll: '. ' ].
			stream nextPut: $} ].
	aMethodNode body
		ifNotNil: [ stream nextPutAll: ' body: ('.
			aMethodNode body acceptVisitor:self.
			stream nextPut: $) ].
	hasPragmas
		ifFalse: [ ^ aMethodNode ].
	stream nextPutAll: ') pragmas: {'.
	aMethodNode pragmas
		do: [ :each |
			each acceptVisitor: self.
			stream nextPutAll: '. ' ].
	stream nextPut: $}
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitParseErrorNode: aParseErrorNode [
	stream
		nextPutAll: aParseErrorNode class name;
		nextPutAll: ' new errorMessage: ';
		print: aParseErrorNode errorMessage;
		nextPutAll: '; value: ';
		print: aParseErrorNode value;
		nextPutAll: '; start: ';
		print: aParseErrorNode start;
		nextPutAll: '; stop: ';
		print: aParseErrorNode stop;
		nextPutAll: '; errorPosition: ';
		print: aParseErrorNode errorPosition
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitPragmaNode: aPragmaNode [
	stream
		nextPutAll: aPragmaNode class name;
		nextPutAll: ' selector: '.
	aPragmaNode selector printOn: stream.
	stream nextPutAll: ' arguments: {'.
	aPragmaNode arguments
		do: [ :each |
			each acceptVisitor: self.
			stream nextPutAll: '. ' ].
	stream nextPut: $}
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitReturnNode: aReturnNode [
	stream
		nextPutAll: aReturnNode class name;
		nextPutAll: ' value: ('.
	aReturnNode value acceptVisitor:self.
	stream nextPut: $)
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitSequenceNode: aSequenceNode [
	stream nextPutAll: aSequenceNode class name.
	aSequenceNode temporaries
		ifNotEmpty: [ stream nextPutAll: ' temporaries: {'.
			aSequenceNode temporaries
				do: [ :each |
					each acceptVisitor: self.
					stream nextPutAll: '. ' ].
			stream nextPut: $} ].
	stream nextPutAll: ' statements: {'.
	aSequenceNode statements
		do: [ :each |
			each acceptVisitor: self.
			stream nextPutAll: '. ' ].
	stream nextPut: $}
]

{ #category : 'visiting' }
ASTDumpVisitor >> visitVariableNode: aVariableNode [
	stream
		nextPutAll: aVariableNode class name;
		nextPutAll: ' named: '.
	aVariableNode name printOn: stream
]
