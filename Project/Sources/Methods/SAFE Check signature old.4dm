//%attributes = {}
#DECLARE($file : 4D:C1709.File; $publicKey : Text)->$result : Integer

var $fileHandle : 4D:C1709.FileHandle
var $key : 4D:C1709.CryptoKey
var $documentSize : Integer
var $blobSignature; $documentAsBlob : Blob
var $textSignature; $digest : Text
var $length : Integer
var $signOptions; $keyOptions; $check : Object

If (Count parameters:C259<2)  // if no private key provided
	
	If (ds:C1482.CryptoKey.all().length>0)
		$publicKey:=ds:C1482.CryptoKey.all().first().publicKey
		ok:=1
	Else 
		ALERT:C41("You must create crypto keys first!")
		ok:=0
	End if 
	
Else 
	ok:=1
End if 

If (ok=1)
	
	$fileHandle:=$file.open("read")  // offset = 0
	$documentSize:=$fileHandle.getSize()
	
	// read the FOUR last bytes
	$fileHandle.offset:=$documentSize-4  // is it "SIGN" ???
	$blobSignature:=$fileHandle.readBlob(4)
	$textSignature:=Convert to text:C1012($blobSignature; "UTF-8")
	
	If ($textSignature="SIGN")
		
		// read the SIX previous bytes
		$fileHandle.offset:=$documentSize-10  // "000999SIGN"
		$blobSignature:=$fileHandle.readBlob(6)
		$textSignature:=Convert to text:C1012($blobSignature; "UTF-8")
		$length:=Num:C11($textSignature)
		
		// read the real signature 
		$fileHandle.offset:=$documentSize-10-$length
		$blobSignature:=$fileHandle.readBlob($length)
		$textSignature:=Convert to text:C1012($blobSignature; "UTF-8")
		
		// regenarate digest to be checked
		$fileHandle.offset:=0
		$documentAsBlob:=$fileHandle.readBlob($documentSize-10-$length)
		$digest:=Generate digest:C1147($documentAsBlob; SHA512 digest:K66:5)
		
		// create a new key based on public key
		$keyOptions:={type: "PEM"; pem: $publicKey}
		$key:=4D:C1709.CryptoKey.new($keyOptions)
		
		// check the signature using the .verify() function
		$signOptions:={hash: "SHA512"; encodingEncrypted: "Base64URL"}
		$check:=$key.verify($digest; $textSignature; $signOptions)
		
		If ($check.success)
			$result:=1
		Else 
			$result:=-1
		End if 
	Else 
		$result:=0  // not signed
	End if 
	
Else 
	$result:=-2  // no key for encryption
End if 