Class {
	#name : #IPAExtensionSimpleTest,
	#superclass : #TestCase,
	#category : #'IPA-Tests'
}

{ #category : #frames }
IPAExtensionSimpleTest class >> stpCtrlAddAckStream [
	^ (ByteArray
		readHexFrom: '0006ee090200000002')
		readStream
]

{ #category : #frames }
IPAExtensionSimpleTest class >> stpCtrlAddNackStream [
	^ (ByteArray
		readHexFrom: '0007ee09030000000372')
		readStream
]

{ #category : #frames }
IPAExtensionSimpleTest class >> stpCtrlAddRangeStream [
	^ (ByteArray
		readHexFrom: '0013ee0901000000020000000000000063ffffffff00')
		readStream
]

{ #category : #frames }
IPAExtensionSimpleTest class >> stpCtrlAddRangeStream2 [
	^ (ByteArray
		readHexFrom: '0013ee0901000000030000006400000096ffffffff00')
		readStream
]

{ #category : #tests }
IPAExtensionSimpleTest >> testParsingAndWriting [
	| stpCtrlAddRange stpCtrlAddAck stpCtrlAddNack stpCtrlAddRange2 msg |
	
	"parsing first stpCtrlAddRange"
	stpCtrlAddRange := IPAStpCtrl parse: self class stpCtrlAddRangeStream.
	self assert: stpCtrlAddRange notNil.
	self assert: stpCtrlAddRange seq equals: 2.
	self assert: stpCtrlAddRange tidStart equals: 0.
	self assert: stpCtrlAddRange tidEnd equals: 99.
	self assert: stpCtrlAddRange pc equals: 4294967295.
	self assert: stpCtrlAddRange pc hex equals: '16rFFFFFFFF'.
	self assert: stpCtrlAddRange ssn equals: 0.

	"parsing second stpCtrlAddRange"
	stpCtrlAddRange2 := IPAStpCtrl parse: self class stpCtrlAddRangeStream2.
	self assert: stpCtrlAddRange2 notNil.
	self assert: stpCtrlAddRange2 seq equals: 3.
	self assert: stpCtrlAddRange2 tidStart equals: 100.
	self assert: stpCtrlAddRange2 tidEnd equals: 150.
	self assert: stpCtrlAddRange2 pc equals: 4294967295.
	self assert: stpCtrlAddRange2 pc hex equals: '16rFFFFFFFF'.
	self assert: stpCtrlAddRange2 ssn equals: 0.

	"parsing stpCtrlAddAck"
	stpCtrlAddAck := IPAStpCtrl parse: self class stpCtrlAddAckStream.
	self assert: stpCtrlAddAck notNil.
	self assert: stpCtrlAddAck seq equals: 2.

	"parsing stpCtrlAddNack"
	stpCtrlAddNack := IPAStpCtrl parse: self class stpCtrlAddNackStream.
	self assert: stpCtrlAddNack notNil.
	self assert: stpCtrlAddNack seq equals: 3.
	self assert: stpCtrlAddNack errno equals: 114.
	self assert: stpCtrlAddNack errno hex equals: '16r72'.

	"writing first stpCtrlAddRange"
	msg := MessageBuffer new.
	stpCtrlAddRange writeSizeAndProtocolOn: msg.
	stpCtrlAddRange	writeOn: msg.
	self assert: msg asArray equals: self class stpCtrlAddRangeStream contents asArray.

	"writing second stpCtrlAddRange"
	msg := MessageBuffer new.
	stpCtrlAddRange2 writeSizeAndProtocolOn: msg.
	stpCtrlAddRange2 writeOn: msg.
	self assert: msg asArray equals: self class stpCtrlAddRangeStream2 contents asArray.

	"writing stpCtrlAddAck"
	msg := MessageBuffer new.
	stpCtrlAddAck writeSizeAndProtocolOn: msg.
	stpCtrlAddAck writeOn: msg.
	self assert: msg asArray equals: self class stpCtrlAddAckStream contents asArray.

	"writing stpCtrlAddNack"
	msg := MessageBuffer new.
	stpCtrlAddNack writeSizeAndProtocolOn: msg.
	stpCtrlAddNack writeOn: msg.
	self assert: msg asArray equals: self class stpCtrlAddNackStream contents asArray.

]
