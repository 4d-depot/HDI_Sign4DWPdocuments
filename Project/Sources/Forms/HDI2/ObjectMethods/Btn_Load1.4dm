var $file : 4D:C1709.File
var $result : Integer

If (Form:C1466.trace)
	TRACE:C157
End if 

$file:=File:C1566("/DATA/signedDocument.4wp")
$result:=SAFE Unsign document($file)

Case of 
	: ($result=1)
		ALERT:C41("The document is not signed anymore.")
	: ($result=0)
		ALERT:C41("The document was NOT signed")
End case 
