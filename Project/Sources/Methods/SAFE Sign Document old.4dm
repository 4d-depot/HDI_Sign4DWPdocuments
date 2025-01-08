//%attributes = {}
#DECLARE($file : 4D:C1709.File; $privateKey : Text)->$result : Integer

var $fileHandle : 4D:C1709.FileHandle
var $key : 4D:C1709.CryptoKey

var $documentAsBlob; $blobSignature : Blob
var $documentSize : Integer
var $digest; $signature : Text

var $keyOptions; $signOptions : Object

If (Count parameters:C259<2)  // if no private key provided
	
	If (ds:C1482.CryptoKey.all().length>0)
		$privateKey:=ds:C1482.CryptoKey.all().first().privateKey
		ok:=1
	Else 
		ALERT:C41("You must create crypto keys first!")
		ok:=0
	End if 
	
Else 
	ok:=1
End if 


If (ok=1)
	
	// opens the document in write mode (in order to add the signature at the end)
	$fileHandle:=$file.open("write")  // offset = 0
	$documentSize:=$fileHandle.getSize()
	
	// create a new key based on private key
	$keyOptions:={type: "PEM"; pem: $privateKey}
	$key:=4D:C1709.CryptoKey.new($keyOptions)
	
	// calculate the digest to create the signature
	$documentAsBlob:=$fileHandle.readBlob($documentSize)
	$digest:=Generate digest:C1147($documentAsBlob; SHA512 digest:K66:5)
	
	// create the signature using the .sign() function
	$signOptions:={hash: "SHA512"; encodingEncrypted: "Base64URL"}
	$signature:=$key.sign($digest; $signOptions)
	
	// alter signature with LENGTH +"SIGN" at the END
	$signature:=$signature+String:C10(Length:C16($signature); "000000")+"SIGN"  // 10 last chars of the signature are "000789SIGN"
	
	// append signature as a BLOB at the end of the document
	CONVERT FROM TEXT:C1011($signature; "UTF-8"; $blobSignature)
	
	$fileHandle.offset:=$documentSize
	$fileHandle.writeBlob($blobSignature)
	$fileHandle:=Null:C1517
	
End if 

$result:=ok