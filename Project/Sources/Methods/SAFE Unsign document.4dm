//%attributes = {}
#DECLARE($file : 4D:C1709.File)->$result : Integer

var $fileHandle : 4D:C1709.FileHandle

var $documentSize : Integer
var $blobSignature : Blob
var $textSignature : Text
var $length : Integer

$fileHandle:=$file.open("write")  // offset = 0
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
	
	
	// truncate the endof the document by setting the size minus (the lentgh of the signature + 10)
	$fileHandle.setSize($documentSize-10-$length)
	
	$result:=1
	
Else 
	$result:=0  // not signed
End if 
