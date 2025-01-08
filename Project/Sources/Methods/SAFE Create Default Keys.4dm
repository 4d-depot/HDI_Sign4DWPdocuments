//%attributes = {}
var $key : 4D:C1709.CryptoKey
var $file : 4D:C1709.File
var $keyOptions : Object
var $cryptoKey : cs:C1710.CryptoKeyEntity
var $n : Integer

$n:=ds:C1482.CryptoKey.all().length
If ($n=0)
	$cryptoKey:=ds:C1482.CryptoKey.new()
	ok:=1
Else 
	CONFIRM:C162("Are you sure you want to replace the existing key ?")
	If (ok=1)
		$cryptoKey:=ds:C1482.CryptoKey.all().first()
	End if 
End if 

If (ok=1)
	
	$keyOptions:={type: "RSA"; size: 2048}
	$key:=4D:C1709.CryptoKey.new($keyOptions)
	
	$cryptoKey.privateKey:=$key.getPrivateKey()
	$cryptoKey.publicKey:=$key.getPublicKey()
	
	$cryptoKey.save()
End if 






