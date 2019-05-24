Extension { #name : #SQLite3PreparedStatement }

{ #category : #'*SQLite3-Deprecated' }
SQLite3PreparedStatement >> at: aColumn putObject: anObject [
	self deprecated: 'Do not use, will be removed soon to avoid dependency on Fuel.'.
	^ self library with: handle at: aColumn putBlob: (FLSerializer serializeToByteArray: anObject)
]

{ #category : #'*SQLite3-Deprecated' }
SQLite3PreparedStatement >> objectAt: aColumn [
	self deprecated: 'Should not be used anymore. We remove dependency on Fuel.'.
	^ FLMaterializer materializeFromByteArray: (self library blobFrom: handle at: aColumn)  
]