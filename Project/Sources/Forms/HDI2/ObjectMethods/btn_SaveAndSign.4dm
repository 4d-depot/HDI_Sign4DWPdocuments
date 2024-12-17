var $file : 4D:C1709.File
var $filePath : Text

$file:=File:C1566("/DATA/signedDocument.4wp")
$filePath:=$file.platformPath
WP EXPORT DOCUMENT:C1337(Form:C1466.wp2; $filePath; wk 4wp:K81:4)  // $file supported only by 20R8 and above

If (Form:C1466.trace)
	TRACE:C157
End if 

//SAFE Sign Document two($file)  // available only staring with 4D 20 R8
SAFE Sign Document($file)

ALERT:C41("The document has been saved and signed!")