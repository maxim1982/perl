#!C:/Perl2/bin/perl
use encoding 'cp1251';
use DBI; 
use DBD::ODBC;
use locale;
use strict;

my %userdata;

print "Content-Type: text/html; charset=windows-1251\n\n";
&recvquery_get();
print " версия 1.02 <br>";
#ВРЕМ215434  
#ВРЕМ1558745
#$sqlText="select lpu.lpu_print_name from people join lpu on people.id_lpu = lpu.id_lpu where people.birthday ='".$userdata{'DR'}."'  and people.surname = '".$userdata{'SURNAME'}."' and people.name = '" .$userdata{'NAME1'}."' and people.second_name = '".$userdata{'NAME2'}."'" ;
#&connect_fb('D:/Apache/shttps/ARM/DBMU/DBMU.FDB',$sqlText,"<b>Прикреп ОМС:</b> ");
#$sqlText= "select listd.gz from listd  where  listd.dr= '".$userdata{'DR'}."' and listd.surname = '".$userdata{'SURNAME'}."' and listd.name1 = '" .$userdata{'NAME1'}."' and  listd.name2 = '".$userdata{'NAME2'}."'" ;
#&connect_fb('c:/shttps/arm/dopbase/listdisp.GDB',$sqlText,"<b> Диспансеризация: </b> ");

#ВРЕМ643264
#$sqlText="select first 1  atrpatient.free2,bmp.datlastrec from atrpatient join bmp on atrpatient.idpat=bmp.idpat where atrpatient.datebirth= '".$userdata{'DR'}."' and atrpatient.firstname= '".$userdata{'SURNAME'}."' order by bmp.datlastrec desc"; #."' and atrpatient.secondname = '" .$userdata{'NAME1'}."' and atrpatient.treename = '".$userdata{'NAME2'}."'";
#&connect_fb('D:/1000.GDB',$sqlText,"<b> Обследование ФЛГ: </b> ");

#Сабитова Жанна Умаровна 
my $sqlText="select medserv.result from patient, medserv where patient.idpatient = medserv.idpatient and patient.dtbirth = '05.12.1978' and patient.lastname = 'Сабитова' and patient.firstname = 'Жанна' and patient.middlename = 'Умаровна' ";
#my $sqlText= "select first 1 medserv.result from patient join medserv on patient.idpatient = medserv.idpatient where patient.dtbirth = '".$userdata{'DR'}."' and patient.lastname = '".$userdata{'SURNAME'}."' and patient.firstname = '" .$userdata{'NAME1'}."' and  patient.middlename = '".$userdata{'NAME2'}."'  order by medserv.dtserv desc" ;
&connect_fb('D:/VALDT.GDB',$sqlText,"<b> Обследование Valenta: </b> ");


#-------------------------------------------module---------------------------------------------------------------------------------------------------- 
sub connect_fb
{
	my($driver) = "Firebird/InterBase(r) driver"; # имя ODBC драйвера, скачан с официального сайта Firebird 
	my($server) = "localhost"; # имя сервера localhost:D:\VALDT.GDB
	my($user) = "SYSDBA"; # логин 
	my($password) = "masterkey"; # пароль 
	my($connexion) = "ODBC"; 
	my($database) ='' ;# путь к базе данных
	my($sql)='';
	my($msg)='';
	
	($database,$sql,$msg)= @_;   
	#print @_;
	
	my(%DSN) = 
	( 
		ODBC => { 
			dsn => "Driver={$driver};Server=$server;Database=$database;uid=$user;pwd=$password;", 
			heading => 'Using ODBC Driver Manager via DBI::ODBC', 
			mode => 'ODBC', 
		} 
	); 
	my $connect = "dbi:$DSN{$connexion}{'mode'}(RaiseError=>0, PrintError=>1, Taint=>0):$DSN{$connexion}{'dsn'}"; 
	my $dbh = DBI->connect($connect, { PrintError => 0, AutoCommit => 0 })  or  die("1Can't connect: $DBI::errstr"); 

   
	my $res = $dbh->prepare($sql) or die(" 2Can't connect: $DBI::errstr");

	$res->execute ;
	print $sql;
	
	while (my @row1 = $res->fetchrow_array) {
      print "<big>". $msg . $row1[0]." , ".$row1[1]."</big>";	 
	}
	
	$res->finish();
	$dbh->disconnect();
	
	#print $sql;
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
 print "</br>";
}

sub decode1
{
  my $string = shift(@_);
  $string =~ s/\+/ /g;
  $string =~ s/%([0-9A-F]{2})/pack('C',hex($1))/eg;
  return $string ;  
}

#$cmd="http://127.0.0.1:82/cgi-bin/dispcgi.exe?$ENV{'QUERY_STRING'}";
#system($cmd);
#print $cmd;
#print "2222";
#return 1;