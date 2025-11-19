Class {
	#name : #IPAStpCtrl,
	#superclass : #Object,
	#instVars : [
		'seq'
	],
	#category : #'IPA-Osmo EXT'
}

{ #category : #parsing }
IPAStpCtrl class >> fromMT: anInteger [
	anInteger = IPAConstants idTagOsmoExtMTTidAddRange ifTrue: [ ^ IPAStpCtrlAddRange ].
	anInteger = IPAConstants idTagOsmoExtMTTidAddAck ifTrue: [ ^ IPAStpCtrlAddAck ].
	anInteger = IPAConstants idTagOsmoExtMTTidAddNack ifTrue: [ ^ IPAStpCtrlAddNack ].
	^ self
		error: 'Unknown type for IPA STP CTRL : ' , anInteger printString
]

{ #category : #access }
IPAStpCtrl class >> mt [
	^ self subclassResponsibility
]

{ #category : #tests }
IPAStpCtrl class >> parse: aStream [
	^ self parseByteArray: aStream contents
]

{ #category : #tests }
IPAStpCtrl class >> parseByteArray: aByteArray [
	| length mt |
	(length := self parseSizeAndProtocol: aByteArray) = -1
		ifTrue: [ ^ nil ].
	mt := aByteArray at: 5.
	^ (self fromMT: mt)
		parseFromByteArray: (aByteArray copyFrom: 6 to: length + 3)
]

{ #category : #parsing }
IPAStpCtrl class >> parseByteArrayWithoutSizeAndProtocol: aByteArray [
	"This is the parsing to be done after receiving a frame form a IPADispatcher.
	Size, protocol and protocol extension have been already removed"

	| mt |
	aByteArray size < 3
		ifTrue: [ ^ nil ].
	mt := aByteArray at: 1.
	^ (self fromMT: mt)
		parseFromByteArray: (aByteArray copyFrom: 2 to: aByteArray size)
]

{ #category : #tests }
IPAStpCtrl class >> parseSizeAndProtocol: aByteArray [
	| length protocol extensionProtocol |
	aByteArray size < 3
		ifTrue: [ ^ -1 ].
		
	"length : 2 octets big-endian"
	length := aByteArray unsignedShortAt: 1 bigEndian: true.
	protocol := aByteArray at: 3.
	protocol = IPAConstants protocolOSMO
		ifFalse: [ ^ -1 ].

	"length starts here"
	length < 3
		ifTrue: [ ^ -1 ].
	aByteArray size < (length + 3)
		ifTrue: [ ^ -1 ].
	extensionProtocol := aByteArray at: 4.
	extensionProtocol = IPAConstants msgIdOsmoExtStpCtrl
		ifFalse: [ ^ -1 ].
	^ length
]

{ #category : #access }
IPAStpCtrl class >> sizeCommonFields [
	"length(2) + protocol(1) + protocolEXT(1) + MT(1)"

	^ 5
]

{ #category : #accessing }
IPAStpCtrl >> seq [
	^ seq
]

{ #category : #accessing }
IPAStpCtrl >> seq: anObject [
	seq := anObject
]

{ #category : #writing }
IPAStpCtrl >> writeCommonFieldsOn: aMessageBuffer [
	"Warning : 
	this method is used when preparing to send an IPA extension through a delegate,
	which will use itself an IPAMuxer, which will add the size and the IPAConstants protocolOSMO
	(method prepareNext:with:).
	So we don't need to add them on our side"

	"aMessageBuffer putLen16ForIPA: (self class size - 3).
	aMessageBuffer putByte: IPAConstants protocolOSMO."
	aMessageBuffer putByte: IPAConstants msgIdOsmoExtStpCtrl.
	aMessageBuffer putByte: self class mt
]

{ #category : #writing }
IPAStpCtrl >> writeOn: aMessageBuffer [
	"See comment in method writeCommonFieldsOn:"

	self subclassResponsibility
]

{ #category : #writing }
IPAStpCtrl >> writeSizeAndProtocolOn: aMessageBuffer [
	"For tests purpose"

	aMessageBuffer putLen16: self class size - 3.
	aMessageBuffer putByte: IPAConstants protocolOSMO
]
