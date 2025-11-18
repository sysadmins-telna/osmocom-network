Class {
	#name : #IPAStpCtrlAddRange,
	#superclass : #IPAStpCtrl,
	#instVars : [
		'tidStart',
		'tidEnd',
		'pc',
		'ssn'
	],
	#category : #'IPA-Osmo EXT'
}

{ #category : #access }
IPAStpCtrlAddRange class >> mt [
	^ IPAConstants idTagOsmoExtMTTidAddRange
]

{ #category : #parsing }
IPAStpCtrlAddRange class >> parseFromByteArray: aByteArray [
	| seq tidStart tidEnd pc ssn |
	seq := aByteArray unsignedLongAt: 1 bigEndian: true.
	tidStart := aByteArray unsignedLongAt: 5 bigEndian: true.
	tidEnd := aByteArray unsignedLongAt: 9 bigEndian: true.
	pc := aByteArray unsignedLongAt: 13 bigEndian: true.
	ssn := aByteArray at: 17.
	^ self new
		seq: seq;
		tidStart: tidStart;
		tidEnd: tidEnd;
		pc: pc;
		ssn: ssn;
		yourself
]

{ #category : #access }
IPAStpCtrlAddRange class >> size [
	"common fields(5) + seq(4) + tidStart(4) + tidEnd(4) + pc(4) + ssn(1)"

	^ self sizeCommonFields + 17
]

{ #category : #accessing }
IPAStpCtrlAddRange >> pc [
	^ pc
]

{ #category : #accessing }
IPAStpCtrlAddRange >> pc: anObject [
	pc := anObject
]

{ #category : #accessing }
IPAStpCtrlAddRange >> ssn [
	^ ssn
]

{ #category : #accessing }
IPAStpCtrlAddRange >> ssn: anObject [
	ssn := anObject
]

{ #category : #accessing }
IPAStpCtrlAddRange >> tidEnd [
	^ tidEnd
]

{ #category : #accessing }
IPAStpCtrlAddRange >> tidEnd: anObject [
	tidEnd := anObject
]

{ #category : #accessing }
IPAStpCtrlAddRange >> tidStart [
	^ tidStart
]

{ #category : #accessing }
IPAStpCtrlAddRange >> tidStart: anObject [
	tidStart := anObject
]

{ #category : #writing }
IPAStpCtrlAddRange >> writeOn: aMessageBuffer [
	self writeCommonFieldsOn: aMessageBuffer.
	aMessageBuffer putLen32: seq.
	aMessageBuffer putLen32: tidStart.
	aMessageBuffer putLen32: tidEnd.
	aMessageBuffer putLen32: pc.
	aMessageBuffer putByte: ssn
]
