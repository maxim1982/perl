#!c:/perl/bin/perl.exe
#use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);

use Win32::OLE;
#use Win32::OLE::Const 'Microsoft ActiveX Data Objects';
use Win32::OLE::Const ;

$table    = "addresstable";
$conn = Win32::OLE->new("ADODB.Connection");
$rs   = Win32::OLE->new("ADODB.Recordset");
$conn->Open("address");

print "Content-Type:text/html\n\n";
print "Address Book<br>";
print "<table><tr><th>First Name</th>";
print "<th>Last Name</th><th>Address</th></tr>";

$sql = "SELECT * FROM $table";
$rs->Open($sql, $conn, 1, 1);
while(!$rs->EOF){
   $firstname = $rs->Fields('firstname')->value;
   $lastname  = $rs->Fields('lastname')->value;
   $address   = $rs->Fields('address')->value;
   print "<tr><td>$firstname</td><td>$lastname</td><td>$address</td></tr>";
   $rs->MoveNext;
  }
print "</table></div>";
$rs->Close;
$conn->Close;
