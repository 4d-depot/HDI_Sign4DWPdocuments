//%attributes = {}
#DECLARE($file : 4D:C1709.File; $publicKey : Text)->$result : Integer

var $fileHandle : 4D:C1709.FileHandle
var $key : 4D:C1709.CryptoKey
var $documentSize : Integer
var $blobSignature; $documentAsBlob : Blob
var $textSignature; $digest : Text
var $length : Integer
var $signOptions; $keyOptions; $check : Object


$fileHandle:=$file.open("read")  // offset = 0
$documentSize:=$fileHandle.getSize()

// read the FOUR last bytes
$fileHandle.offset:=$documentSize-4  // is it "SIGN" ???
$blobSignature:=$fileHandle.readBlob(4)
$textSignature:=Convert to text:C1012($blobSignature; "UTF-8")

If ($textSignature="SIGN")
	
	If (Count parameters:C259<2)  // if no private key provided
		
		If (ds:C1482.CryptoKey.all().length>0)
			$publicKey:=ds:C1482.CryptoKey.all().first().publicKey
			ok:=1
		Else 
			ok:=0
		End if 
		
	Else 
		ok:=1
	End if 
	
	
	If (ok=1)
		
		// read the SIX previous bytes
		$fileHandle.offset:=$documentSize-10  // "000999SIGN"
		$blobSignature:=$fileHandle.readBlob(6)
		$textSignature:=Convert to text:C1012($blobSignature; "UTF-8")
		$length:=Num:C11($textSignature)
		
		// read the real signature 
		$fileHandle.offset:=$documentSize-10-$length
		$blobSignature:=$fileHandle.readBlob($length)
		$textSignature:=Convert to text:C1012($blobSignature; "UTF-8")
		
		// create a new key based on public key
		$keyOptions:={type: "PEM"; pem: $publicKey}
		$key:=4D:C1709.CryptoKey.new($keyOptions)
		
		// Load the whole document (except ending signature)
		$fileHandle.offset:=0
		$documentAsBlob:=$fileHandle.readBlob($documentSize-10-$length)
		
		// check the signature using the .verify() function
		$signOptions:={hash: "SHA512"; encodingEncrypted: "Base64URL"}
		$check:=$key.verify($documentAsBlob; $textSignature; $signOptions)  // BLOB can be used with verify() since 20R8
		
		
		If ($check.success)
			$result:=1
		Else 
			$result:=-1  // corrupted document
		End if 
		
	Else 
		$result:=-2  // no key to check encryption
	End if 
	
Else 
	$result:=0  // not signed
End if 