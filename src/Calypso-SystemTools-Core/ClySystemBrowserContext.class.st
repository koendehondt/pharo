"
I am a root of contexts hierarchy which represent the state of any kind of system browsers.

I define main interface to check the browser state:  

- For packages: 
	
	- selectedPackages 
	- lastSelectedPackage
	- isPackageSelected
	
- For classes 

	- selectedClasses 
	- lastSelectedClass
	- isClassSelected

- For methods 

	- selectedMethods 
	- lastSelectedMethod
	- isMethodSelected

- For messages 

	- selectedMessages 
	- lastSelectedMessage
	- isMessageSelected

Message is a selector+arguments. Any method defines correspondant message. So it allows to have polymorphic interface to work with messages like in the source code editor. 

In addition I provide tool controlling methods: 

- showClass: aClass
- showMethod: aMethod 
- showMessage: aMessage renamedTo: newSelector 

And I implement simplified search requests: 

- requestSinglePackage: 'Choose a package'
- requestSingleClass: 'Choose a class'
- requestSingleMethodTag: 'Choose a protocol'

"
Class {
	#name : 'ClySystemBrowserContext',
	#superclass : 'ClyBrowserContext',
	#classVars : [
		'RememberedPackage'
	],
	#category : 'Calypso-SystemTools-Core-Contexts',
	#package : 'Calypso-SystemTools-Core',
	#tag : 'Contexts'
}

{ #category : 'accessing - packages' }
ClySystemBrowserContext class >> rememberedPackage [

	^ RememberedPackage ifNil: [ RememberedPackage := nil ]
]

{ #category : 'accessing - packages' }
ClySystemBrowserContext class >> rememberedPackage: aPackage [

	RememberedPackage := aPackage
]

{ #category : 'user requests' }
ClySystemBrowserContext >> confirmUnusedVariablesInDefiningClass: variables [
	^tool confirmUnusedVariablesInDefiningClass: variables
]

{ #category : 'command execution' }
ClySystemBrowserContext >> executeCommand: aCommand by: aCommandActivator [

	aCommand isComplexRefactoring ifTrue: [
		aCommand confirmRefactoringInContext: self by: aCommandActivator].

	aCommand execute
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> firstSelectedMethod [
	^self firstSelectedObjectIn: self selectedMethods
]

{ #category : 'selection-classes' }
ClySystemBrowserContext >> isClassSelected [
	^self selectedClassItems notEmpty
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> isClassSideMethodSelected [

	self isMethodSelected ifFalse: [ ^false].

	^self selectedMethodItems anySatisfy: [ :each |
		each systemDefinition isInstanceSide not]
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> isExtensionMethodSelected [

	self isMethodSelected ifFalse: [ ^false].

	^self selectedMethodItems anySatisfy: [ :each |
		each systemDefinition isExtension]
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> isInstanceSideMethodSelected [

	self isMethodSelected ifFalse: [ ^false].

	^self selectedMethodItems anySatisfy: [ :each |
		each systemDefinition isInstanceSide ]
]

{ #category : 'selection-messages' }
ClySystemBrowserContext >> isMessageSelected [
	^self isMethodSelected
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> isMethodSelected [
	^self selectedMethodItems notEmpty
]

{ #category : 'selection-packages' }
ClySystemBrowserContext >> isPackageSelected [
	^self selectedPackageItems notEmpty
]

{ #category : 'selection-classes' }
ClySystemBrowserContext >> lastSelectedClass [
	^self lastSelectedObjectIn: self selectedClasses
]

{ #category : 'selection-messages' }
ClySystemBrowserContext >> lastSelectedMessage [
	^SycMessageDescription ofMethod: self lastSelectedMethod
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> lastSelectedMethod [
	^self lastSelectedObjectIn: self selectedMethods
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> lastSelectedMethodClass [
	| lastMethodItem |
	lastMethodItem := self lastSelectedObjectIn: self selectedMethodItems.
	^lastMethodItem systemDefinition definingClass
]

{ #category : 'selection-packages' }
ClySystemBrowserContext >> lastSelectedPackage [
	^self lastSelectedObjectIn: self selectedPackages
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> lastSelectedSourceNode [

	^self lastSelectedMethod astForStylingInCalypso
]

{ #category : 'accessing' }
ClySystemBrowserContext >> metaLevelScope [

	^ nil
]

{ #category : 'refactoring support' }
ClySystemBrowserContext >> refactoringScopes [
	"It returns default browser scope as first one which makes it default for users"
	| allScopes defaultScope |
	allScopes := tool allNavigationScopes.
	defaultScope := tool defaultNavigationScope.
	^(allScopes copyWithout: defaultScope) copyWithFirst: defaultScope
]

{ #category : 'user requests' }
ClySystemBrowserContext >> requestSingleClass: queryTitle [

	^ StBrowserSearchPresenter searchConfiguring: [ :presenter :dialog |
		  dialog title: queryTitle.
		  presenter items: (self browser itemsForQuery: ClyAllClassesQuery sorted) ]
]

{ #category : 'user requests' }
ClySystemBrowserContext >> requestSingleClass: queryTitle from: classCollection [

	^ StBrowserSearchPresenter searchConfiguring: [ :presenter :dialog |
		  dialog title: queryTitle.
		  presenter items:
			  ((self browser itemsForQuery: ClyAllClassesQuery hierarchical inScope: (ClyClassScope ofAll: classCollection)) collect: [ :item | item actualObject ]) ]
]

{ #category : 'user requests' }
ClySystemBrowserContext >> requestSinglePackage: queryTitle [

	^ StBrowserSearchPresenter searchConfiguring: [ :presenter :dialog |
		  dialog title: queryTitle.
		  presenter items:
			  (self browser itemsForQuery: ClyAllPackagesQuery sorted).
		  self class rememberedPackage ifNotNil: [
			  presenter searchWithItem: self class rememberedPackage ].
		  dialog okAction: [
			  self class rememberedPackage: presenter selectedItem
			  "Mémorise la sélection ici" ] ]
]

{ #category : 'selection-classes' }
ClySystemBrowserContext >> selectedClassItems [
	self subclassResponsibility
]

{ #category : 'selection-classes' }
ClySystemBrowserContext >> selectedClasses [
	^self actualSelectionFrom: self selectedClassItems
]

{ #category : 'selection-messages' }
ClySystemBrowserContext >> selectedMessages [
	^self selectedMethods collect: [ :each | SycMessageDescription ofMethod: each ]
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> selectedMethodItems [
	self subclassResponsibility
]

{ #category : 'selection-methods' }
ClySystemBrowserContext >> selectedMethods [
	^self actualSelectionFrom: self selectedMethodItems
]

{ #category : 'selection-packages' }
ClySystemBrowserContext >> selectedPackageItems [
	self subclassResponsibility
]

{ #category : 'selection-packages' }
ClySystemBrowserContext >> selectedPackages [
	^self actualSelectionFrom: self selectedPackageItems
]

{ #category : 'tool controlling' }
ClySystemBrowserContext >> showClass: aClass [
	tool selectClass: aClass
]

{ #category : 'tool controlling' }
ClySystemBrowserContext >> showMessage: aMessageDescription renamedTo: newSelector [
	| method newMethod |
	method := aMessageDescription contextUser.
	newMethod := method origin >> newSelector.
	self showMethod: newMethod
]

{ #category : 'tool controlling' }
ClySystemBrowserContext >> showMethod: aMethod [
	tool selectMethod: aMethod
]

{ #category : 'accessing' }
ClySystemBrowserContext >> systemEnvironment [
	^self system
]
