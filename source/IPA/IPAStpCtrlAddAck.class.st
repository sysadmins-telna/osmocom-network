Class {
	#name : #IPAStpCtrlAddAck,
	#superclass : #IPAStpCtrl,
	#category : #'IPA-Osmo EXT'
}

{ #category : #access }
IPAStpCtrlAddAck class >> mt [
	^ IPAConstants idTagOsmoExtMTTidAddAck
]

{ #category : #parsing }
IPAStpCtrlAddAck class >> parseFromByteArray: aByteArray [
	| seq |
	seq := aByteArray unsignedLongAt: 1 bigEndian: true.
	^ self new
		seq: seq;
		yourself
]

{ #category : #access }
IPAStpCtrlAddAck class >> size [
	"common fields(5) + seq(4)"

	^ self sizeCommonFields + 4
]

{ #category : #testing }
IPAStpCtrlAddAck >> isAck [
	^ true
]

{ #category : #writing }
IPAStpCtrlAddAck >> writeOn: aMessageBuffer [
	self writeCommonFieldsOn: aMessageBuffer.
	aMessageBuffer putLen32: seq
]
