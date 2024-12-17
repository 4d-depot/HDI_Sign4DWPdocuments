var $file : 4D:C1709.File
var $filePath : Text

$file:=File:C1566("/DATA/signedDocument.4wp")
$filePath:=$file.platformPath

If (Form:C1466.trace)
	TRACE:C157
End if 

Form:C1466.wp2:=WP Import document:C1318($filePath)

