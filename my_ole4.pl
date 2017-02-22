use strict;

use Cwd;
use Win32::OLE;
Win32::OLE->Option(Warn => 1); 

use Encode qw(encode decode);

sub txt_consol(){
  my $s1 = shift();
  return  Encode::encode('cp866',Encode::decode('cp1251', $s1)) ;
  # return  Encode::encode('cp866',Encode::decode('utf8', $s1)) ;
 
  }

sub Main()
{
  Win32::OLE->Initialize(Win32::OLE::COINIT_APARTMENTTHREADED);
  
  my $cn = Win32::OLE->new("ADODB.Connection");
  my $db = 'SMO.DBF';
  my $path = cwd;# 'D:\work\Project\db_ole';  
  
  #Initalize ADO
  $cn=Win32::OLE->new('ADODB.Connection');
  die "Cannot to create ADO.Connection\n" unless defined($cn);

  $cn->{ConnectionString}='Provider=Microsoft.Jet.OLEDB.4.0;Extended Properties=dBASE IV;User ID=Admin;Password=;Data Source='.$path.';';  
  $cn->{ConnectionTimeout}=0;
  $cn->open;
  $cn->{CursorLocation}=3; #UseClient
  
  my $cmd=Win32::OLE->new('ADODB.Command');
  die "Cannot create ADO Command!\n" unless defined($cmd);

  $cmd->{ActiveConnection}=$cn;
  $cmd->{CommandTimeout}=0;
  $cmd->{CommandText}='insert into '.$db." values ('111','SMO','LONG_NAME');";
  $cmd->{CommandText}='select * from '.$db;
  $cmd->{CommandType}=1; #Command Text
  
  my $rs=Win32::OLE->new('ADODB.Recordset');
  die "Cannot create ADO recordset!\n" unless defined($rs);

  $rs->open($cmd, undef, 3, 1);
  die "+Cannot open ADO recordset\n" if Win32::OLE::LastError();
  
  my $str ='';
  my $i=1;
  
  while(!$rs->{EOF})
  { 
	$str = $rs->Fields->Item('ID_SMO')->{Value}.' : '.$rs->Fields->Item('SMO_NAME')->{Value}."\n" ;
	print $i++ .' - '; 
	print &txt_consol($str);
	$rs->MoveNext();
  }
  $rs->Close();

  undef $rs;
  undef $cmd;
 }

Main();
