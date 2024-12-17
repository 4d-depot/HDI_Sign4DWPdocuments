//%attributes = {}





#DECLARE($file : 4D:C1709.File; $privateKey : Text)

var $fileHandle : 4D:C1709.FileHandle
var $key : 4D:C1709.CryptoKey

var $documentAsBlob; $blobSignature : Blob
var $documentSize : Integer
var $digest; $signature : Text

var $keyOptions; $signOptions : Object

If (Count parameters:C259<2)  // if no private key provided
	$privateKey:=File:C1566("/RESOURCES/privateKey.pem").getText()  // use the default one in the RESOURCES
End if 

// opens the document in write mode (in order to add the signature at the end)
$fileHandle:=$file.open("write")  // offset = 0
$documentSize:=$fileHandle.getSize()

// calculated the digest to create the signature
$documentAsBlob:=$fileHandle.readBlob($documentSize)
$digest:=Generate digest:C1147($documentAsBlob; SHA512 digest:K66:5)


// create a new key based on private key
$keyOptions:={type: "PEM"; pem: $privateKey}
$key:=4D:C1709.CryptoKey.new($keyOptions)

// create the signature using the .sign() function
$signOptions:={hash: "SHA512"; encodingEncrypted: "Base64URL"}
$signature:=$key.sign($digest; $signOptions)

// 🔺🔺🔺 // TEST 2> // Modify signature
$signature[[1]]:="x"
$signature[[2]]:="x"
$signature[[3]]:="x"
// 🔺🔺🔺 //

// alter signature with LENGTH +"SIGN" at the END
$signature:=$signature+String:C10(Length:C16($signature); "000000")+"SIGN"  // 10 last chars of the signature are "000789SIGN"

// append signature as a BLOB at the end of the document
TEXT TO BLOB:C554($signature; $blobSignature; UTF8 text without length:K22:17)

$fileHandle.offset:=$documentSize
$fileHandle.writeBlob($blobSignature)
$fileHandle:=Null:C1517
