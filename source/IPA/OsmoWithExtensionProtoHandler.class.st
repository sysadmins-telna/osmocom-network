Class {
	#name : #OsmoWithExtensionProtoHandler,
	#superclass : #IPAProtoHandler,
	#instVars : [
		'networkService'
	],
	#category : #'IPA-Osmo EXT'
}

{ #category : #handling }
OsmoWithExtensionProtoHandler >> handleIdAck: aMsg [
	| ns |
	super handleIdAck: aMsg.
	
	((ns := self networkService) notNil
		and: [ ns respondsTo: #sendNewAddRangeMessage ])
		ifTrue: [ ns sendNewAddRangeMessage ]
]

{ #category : #accessing }
OsmoWithExtensionProtoHandler >> networkService [
	^ networkService
]

{ #category : #accessing }
OsmoWithExtensionProtoHandler >> networkService: anObject [
	networkService := anObject
]
