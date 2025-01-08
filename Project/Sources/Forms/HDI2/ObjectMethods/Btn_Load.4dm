var $file : 4D:C1709.File
var $result : Integer

$file:=File:C1566("/DATA/signedDocument.4wp")

If (Form:C1466.trace)
	TRACE:C157
End if 

//$result:=SAFE Check signature two($file)  // available only staring with 4D 20 R8
$result:=SAFE Check signature($file)

Case of 
	: ($result=1)
		ALERT:C41("GOOD: The document is signed and OK!\r\rIt can be loaded safely.")
	: ($result=0)
		ALERT:C41("Warning! The document is NOT signed!\r\rIt may not be safe.")
	: ($result=-1)
		ALERT:C41("DANGER! The document is signed but NOT OK!\r\rIt has been modified.")
	: ($result=-2)
		ALERT:C41("You must create crypto keys first!")
End case 