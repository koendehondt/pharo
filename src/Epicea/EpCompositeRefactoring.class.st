"
I represent a refactoring that is composed of other refactorings.
"
Class {
	#name : 'EpCompositeRefactoring',
	#superclass : 'EpRefactoring',
	#instVars : [
		'childrenRefactorings'
	],
	#category : 'Epicea-Model',
	#package : 'Epicea',
	#tag : 'Model'
}

{ #category : 'instance creation' }
EpCompositeRefactoring class >> withAll: someRefactorings [
	^ self basicNew
		initializeWith: someRefactorings;
		yourself
]

{ #category : 'converting' }
EpCompositeRefactoring >> asRBRefactoring [
	^ RBCompositeRefactoryChange new
		changes: (childrenRefactorings collect: [:each | each asRBRefactoring]);
		yourself
]

{ #category : 'accessing' }
EpCompositeRefactoring >> childrenRefactorings [
	^ childrenRefactorings
]

{ #category : 'initialization' }
EpCompositeRefactoring >> initializeWith: someRefactorings [
	self initialize.
	childrenRefactorings := someRefactorings collect: [:each | each asEpiceaEvent]
]
