//%attributes = {}
var $file : 4D:C1709.File

ds:C1482.CryptoKey.all().drop()

$file:=File:C1566("/DATA/signedDocument.4wp")
If ($file.exists)
	$file.delete()
End if 