Class {
	#name : #IPAStpCtrlAddNack,
	#superclass : #IPAStpCtrl,
	#instVars : [
		'errno'
	],
	#category : #'IPA-Osmo EXT'
}

{ #category : #access }
IPAStpCtrlAddNack class >> mt [
	^ IPAConstants idTagOsmoExtMTTidAddNack
]

{ #category : #parsing }
IPAStpCtrlAddNack class >> parseFromByteArray: aByteArray [
	| seq errno |
	seq := aByteArray unsignedLongAt: 1 bigEndian: true.
	errno := aByteArray at: 5.
	^ self new
		seq: seq;
		errno: errno;
		yourself
]

{ #category : #access }
IPAStpCtrlAddNack class >> size [
	"common fields(5) + seq(4) + errno(1)"

	^ self sizeCommonFields + 5
]

{ #category : #accessing }
IPAStpCtrlAddNack >> errno [
	^ errno
]

{ #category : #accessing }
IPAStpCtrlAddNack >> errno: anObject [
	errno := anObject
]

{ #category : #testing }
IPAStpCtrlAddNack >> isAck [
	^ false
]

{ #category : #writing }
IPAStpCtrlAddNack >> writeOn: aMessageBuffer [
	self writeCommonFieldsOn: aMessageBuffer.
	aMessageBuffer putLen32: seq.
	aMessageBuffer putByte: errno
]
