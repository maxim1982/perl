#!C:/Perl2/bin/perl
#use encoding 'cp1251';
use Win32::ODBC;
use locale;
use strict;

my %userdata;
print "Content-Type: text/html; charset=windows-1251\n\n";
&recvquery_get();

my $usr ='SYSDBA';
my $pass ='masterkey';
my $sqlText ='';

my @disp_stand =(1998,1995,1992,1989,1986,1983,1980,1977,1974,1971,1968,1965,1962,1959,1956,1953,1950,1947,1944,1941,1938,1935,1932,1929,1926,1923,1920,1917);
#print check_disp("01/01/1998");

print check_disp($userdata{'DR'});

$sqlText="select first 1  atrpatient.free2,bmp.datlastrec from atrpatient join bmp on atrpatient.idpat=bmp.idpat where atrpatient.datebirth= '".$userdata{'DR'}."' and atrpatient.firstname= '".$userdata{'SURNAME'}."' order by bmp.datlastrec desc"; 
connect_base('1000',$usr,$pass,$sqlText,"<span style=\"color:blue;font-family:arial;font-size:20px\" >Обследование ФЛГ</span>");

#Сабитова Жанна Умаровна 
$sqlText="select medserv.result from patient, medserv where patient.idpatient = medserv.idpatient and patient.dtbirth = '".$userdata{'DR'}."' and patient.lastname = '".$userdata{'SURNAME'}."' and patient.firstname = '".$userdata{'NAME1'}."' and patient.middlename = '".$userdata{'NAME2'}."' ";
connect_base('valdt',$usr,$pass,$sqlText,"<span style=\"color:Teal;font-family:arial;font-size:20px\" >Обследование Valenta</span>");

#-------------------------------------------module---------------------------------------------------------------------------------------------------- 
sub connect_base
{  
   my($dsn,$user,$pwd,$sql,$msg) ='';
     ($dsn,$user,$pwd,$sql,$msg)= @_;    
### Connect to a data source
  my $db = new Win32::ODBC("DSN=$dsn;UID=$user;PWD=$pwd") or die Win32::ODBC::Error();

### Prepare and Execute a statement
   if ($db->Sql($sql)) 
   {
        print "SQL Error: " . $db->Error() . "";
        $db->Close();
        exit;
   }
my $data ='';
### Fetch row from data source
    while ($db->FetchRow) {
        $data = $data . $db->Data();  ### Get data values from the row
        print "<big>$msg:$data </big><br>";
   }

### Disconnect
    $db->Close();
	#print "<small>$sql</small>"
}
sub check_disp {
 
 my $dr =shift(@_);  
 $dr =substr($dr,6);
 
 my $d_txt ="<span style=\"color:red;font-family:arial;font-size:20px\" >НЕ подлежит Диспансеризации в 2016 году</span>, &nbsp;&nbsp;" ;
 my $d_txt2="<span style=\"color:green;font-family:arial;font-size:20px\" >Подлежит Диспансеризации в 2016 году</span>, &nbsp;&nbsp;" ;
 
 for (my $i = 0; $i<scalar(@disp_stand) ; $i++ ){
    if( $disp_stand[$i] == $dr ) { $d_txt =$d_txt2; }
 }
  return '<b>'.$d_txt.'</b>';
}

#------------------------------------------------------------------------------------------------------------
sub recvquery_get
{
  my $query = $ENV{'QUERY_STRING'};
  if($query ne ''){ &parse_query($query) ;}  
}

sub parse_query
{ my $element;
  my $string = shift(@_);
  my @query = split('&',$string);
  
  
  foreach $element(@query)
  {
    my @fields = split('=',$element);
     $fields[0]= decode1($fields[0]);
     $fields[1]= decode1($fields[1]);
     $userdata{$fields[0]}=$fields[1];
	# print $fields[0]."=".$fields[1]." ; ";
  }
 
 # конвертируем данные для firebird 
 
 $userdata{'SURNAME'} = ucfirst(lc($userdata{'SURNAME'}));
 $userdata{'NAME1'} = ucfirst(lc($userdata{'NAME1'}));
 $userdata{'NAME2'} = ucfirst(lc($userdata{'NAME2'}));
 $userdata{'DR'} =~ s/\//\./g;
 #print $userdata{'SURNAME'}."  ".$userdata{'NAME1'}."  ".$userdata{'NAME2'}."  ".$userdata{'DR'} ;
 #print "</br>";
}

sub decode1
{
  my $string = shift(@_);
  $string =~ s/\+/ /g;
  $string =~ s/%([0-9A-F]{2})/pack('C',hex($1))/eg;
  return $string ;  
}

