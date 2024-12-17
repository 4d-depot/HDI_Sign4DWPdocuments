//%attributes = {}
var $key : 4D:C1709.CryptoKey
var $file : 4D:C1709.File
var $keyOptions : Object

$file:=File:C1566("/RESOURCES/privateKey.pem")
If ($file.exists)
	CONFIRM:C162("Are you sure you want to create / modify the existing keys ?")
Else 
	ok:=1
End if 

If (ok=1)
	
	$keyOptions:={type: "RSA"; size: 2048}
	$key:=4D:C1709.CryptoKey.new($keyOptions)
	
	$file:=File:C1566("/RESOURCES/privateKey.pem")
	$file.setText($key.getPrivateKey())
	
	$file:=File:C1566("/RESOURCES/publicKey.pem")
	$file.setText($key.getPublicKey())
	
End if 