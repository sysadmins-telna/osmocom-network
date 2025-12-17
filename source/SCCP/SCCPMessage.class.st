"
I extended this class for Roaminghub to add instance variable connectionName. All subclasses (Messages) needs to keep OSMO STP connection identification - where it came from, so that the response goes to the same osmo stp server.

I am the generic base class for all defined
    SCCP messages. You should only deal with me to decode
    data.
"
Class {
	#name : 'SCCPMessage',
	#superclass : 'Object',
	#instVars : [
		'connectionName'
	],
	#category : 'RoamingHub',
	#package : 'RoamingHub'
}

{ #category : 'parsing' }
SCCPMessage class >> decode: aByteArray [
	| type |
	type := aByteArray at: 1.
	SCCPMessage 
	    allSubclassesDo: [:each | each msgType = type ifTrue: [^each parseFrom: aByteArray]].

	"raise exception"
	^Error signal: ('No handler for: <1p>' expandMacrosWith: type)

]

{ #category : 'as yet unclassified' }
SCCPMessage >> connectionName [
	"originated connection name 'host:port'. Informated needs to be transfered to when the repsonse needs to be sent back to the same connection"

	^ connectionName
]

{ #category : 'as yet unclassified' }
SCCPMessage >> connectionName: aConnectionName [

	connectionName := aConnectionName 
]

{ #category : 'as yet unclassified' }
SCCPMessage >> rhSccpDispatch: aRouter [ 
	aRouter unhandledSCCP: self
]

{ #category : 'as yet unclassified' }
SCCPMessage >> tcapNetworkServiceDispatch: aService [
	^ self shouldNotImplement
]
