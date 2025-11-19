Class {
	#name : #OsmoWithExtensionMessageReadDelegate,
	#superclass : #OsmoMessageIPAReadDelegate,
	#instVars : [
		'networkService'
	],
	#category : #'OsmoSocket-Osmo EXT'
}

{ #category : #accessing }
OsmoWithExtensionMessageReadDelegate >> networkService [
	^ networkService
]

{ #category : #accessing }
OsmoWithExtensionMessageReadDelegate >> networkService: anObject [
	networkService := anObject
]

{ #category : #connect }
OsmoWithExtensionMessageReadDelegate >> onNewConnection: aSocket [
	| ipa |
	ipa := super onNewConnection: aSocket.
	ipa networkService: networkService.
	^ ipa
]

{ #category : #access }
OsmoWithExtensionMessageReadDelegate >> protoHandlerClass [
	^ OsmoWithExtensionProtoHandler
]
