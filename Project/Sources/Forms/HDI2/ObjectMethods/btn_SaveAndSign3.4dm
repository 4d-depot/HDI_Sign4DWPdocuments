var $file : 4D:C1709.File
var $filePath : Text

If (Form:C1466.trace)
	TRACE:C157
End if 

$file:=File:C1566("/DATA/signedDocument.4wp")
$filePath:=$file.platformPath
WP EXPORT DOCUMENT:C1337(Form:C1466.wp2; $filePath; wk 4wp:K81:4)