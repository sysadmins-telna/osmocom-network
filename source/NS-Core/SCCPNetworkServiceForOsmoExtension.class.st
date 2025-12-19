Class {
	#name : 'SCCPNetworkServiceForOsmoExtension',
	#superclass : 'SCCPNetworkServiceOsmoDirect',
	#instVars : [
		'isIPARegistrationOk',
		'ipaSeq'
	],
	#category : 'NS-Core-Osmo EXT',
	#package : 'NS-Core',
	#tag : 'Osmo EXT'
}

{ #category : 'access' }
SCCPNetworkServiceForOsmoExtension >> delegateClass [
	^ OsmoWithExtensionMessageReadDelegate
]

{ #category : 'receiving' }
SCCPNetworkServiceForOsmoExtension >> doIpaRecv: aMsg [
	| message |
	self isIPARegistrationOk
		ifFalse:
			[ message := 'Could not handle traffic, Osma Extension Add Range not ACKED'.
			self logError: message area: #ipa.
			^ Error signal: message ].
	super doIpaRecv: aMsg
]

{ #category : 'sending' }
SCCPNetworkServiceForOsmoExtension >> doSendIPA: aMessage to: aToPoc from: aFromPoc [
	delegate nextPut: aMessage with: IPAConstants protocolOSMO
]

{ #category : 'add range' }
SCCPNetworkServiceForOsmoExtension >> endTidRange [
	^ self subclassResponsibility 
]

{ #category : 'private' }
SCCPNetworkServiceForOsmoExtension >> incrementeIpaSequence [
	ipaSeq := ipaSeq + 1
]

{ #category : 'initialization' }
SCCPNetworkServiceForOsmoExtension >> initialize [
	super initialize.
	delegate networkService: self.
	isIPARegistrationOk := false.
	ipaSeq := 0
]

{ #category : 'receiving' }
SCCPNetworkServiceForOsmoExtension >> ipaRecvExtensionOsmo: aMsg [
	| ackOrNack ok |
	ackOrNack := IPAStpCtrl parseByteArrayWithoutSizeAndProtocol: aMsg contents.
	(ok := ackOrNack isAck)
		ifTrue: [ self logDebug: 'ADD RANGE EXTENSION ACK RECEIVED' area: #ipa ]
		ifFalse: [ self
				logDebug:
					'ADD RANGE EXTENSION NACK RECEIVED with error '
						, ackOrNack errno printString
				area: #ipa ].
	self isIPARegistrationOk: ok
]

{ #category : 'accessing' }
SCCPNetworkServiceForOsmoExtension >> isIPARegistrationOk [
	^ isIPARegistrationOk
]

{ #category : 'accessing' }
SCCPNetworkServiceForOsmoExtension >> isIPARegistrationOk: anObject [
	isIPARegistrationOk := anObject
]

{ #category : 'add range' }
SCCPNetworkServiceForOsmoExtension >> newAddRAnge [
	| addRange |
	self incrementeIpaSequence.
	addRange := IPAStpCtrlAddRange new.
	addRange seq: ipaSeq.
	addRange tidStart: self startTidRange.
	addRange tidEnd: self endTidRange.
	addRange pc: 16rFFFFFFFF.
	addRange ssn: 0.
	^ addRange
]

{ #category : 'registering' }
SCCPNetworkServiceForOsmoExtension >> registerOn: aDispatcher [
	super registerOn: aDispatcher.
	aDispatcher
		addHandler:
			(Array
				with: IPAConstants protocolOSMO
				with: IPAConstants msgIdOsmoExtStpCtrl)
		on: [ :msg | self ipaRecvExtensionOsmo: msg ]
]

{ #category : 'sending' }
SCCPNetworkServiceForOsmoExtension >> sendNewAddRangeMessage [
	| msg |
	msg := MessageBuffer new.
	self newAddRAnge writeOn: msg.
	self logDebug: 'EXT ADD RANGE sent' area: #ipa.
	self
		logDebug:
			'ADD RANGE = '
				, (msg asArray collect: [ :b | b printStringBase: 16 ]) printString
		area: #ipa.
	self doSendIPA: msg to: nil from: nil
]

{ #category : 'add range' }
SCCPNetworkServiceForOsmoExtension >> startTidRange [
	^ self subclassResponsibility 
]
