//%attributes = {}
#DECLARE($file : 4D:C1709.File; $publicKey : Text)->$result : Integer

var $fileHandle : 4D:C1709.FileHandle
var $key : 4D:C1709.CryptoKey
var $documentSize : Integer
var $blobSignature; $documentAsBlob : Blob
var $textSignature; $digest : Text
var $length : Integer
var $signOptions; $keyOptions; $check : Object

If (Count parameters:C259<2)  // if no public key provided
	$publicKey:=File:C1566("/RESOURCES/publicKey.pem").getText()  // use the default one in the RESOURCES
End if 

$fileHandle:=$file.open("read")  // offset = 0
$documentSize:=$fileHandle.getSize()

// read the FOUR last bytes
$fileHandle.offset:=$documentSize-4  // is it "SIGN" ???
$blobSignature:=$fileHandle.readBlob(4)
$textSignature:=BLOB to text:C555($blobSignature; UTF8 text without length:K22:17)

If ($textSignature="SIGN")
	
	// read the SIX previous bytes
	$fileHandle.offset:=$documentSize-10  // "000999SIGN"
	$blobSignature:=$fileHandle.readBlob(6)
	$textSignature:=BLOB to text:C555($blobSignature; UTF8 text without length:K22:17)
	$length:=Num:C11($textSignature)
	
	// read the real signature 
	$fileHandle.offset:=$documentSize-10-$length
	$blobSignature:=$fileHandle.readBlob($length)
	$textSignature:=BLOB to text:C555($blobSignature; UTF8 text without length:K22:17)
	
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
		$result:=-1
	End if 
Else 
	$result:=0  // not signed
End if 
