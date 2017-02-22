use Win32::ODBC;
use locale;
use strict;
use Encode qw(encode decode);

my $usr ='SYSDBA';
my $pass ='masterkey';
my $sqlText ='select id_sprav,sprav_name,sprav_q,remark from vmu_exp_sprav order by id_sprav';
my $nom=0; 
my $dbconn; # connect DB

my @row ; # ==> @sprav_eis
my @text ;

my @sprav_eis = (
    { 
		"id" => "_id",
		"code" => "_code", 
		"sqltext" => "_sqltext", 
		"namespr" => "_namespr"
	},
);

print &txt_consol("Утилита для выгрузки справочников из ЕИСОМС(1.03) \nПомощь по командам - введите 'h' \n");

print &txt_consol("Введите имя ODBC-соединения : ");
my $name_odbc = <STDIN>; 
chomp($name_odbc);

while( 1==1 ){
  #print txt_consol("подключаемся к базе - ".$name_odbc)."\n";
  print &txt_consol("введите параметр :");
  
  my $param = <STDIN>; 
  chomp($param);

  my $i=0;
  my $exit ='no';
  
  if ( $param eq 'd') {
	$dbconn= &Connect_fb($name_odbc,$usr,$pass,$sqlText);
	
	&Fetch_fb($dbconn,$sqlText,'-') ;
 
	for($i=1;$i<=$nom;$i++){
	  
	    @row = split (/;/, $text[$i]) ; 
		 
	      push( @sprav_eis,
		    {
              "id" => $row[0],
		      "code" => $row[1], 
		      "sqltext" => $row[2], 
		      "namespr" => $row[3] 
		    }
		 );
	  	
	  print &txt_consol( $sprav_eis[$i]->{"id"}.':'.$sprav_eis[$i]->{"namespr"} )."\n";
	}
	
	&Disconn_fb($dbconn);
		
	while($exit eq 'no'){
	   $param ='';
	   print &txt_consol("\nдля выгрузки выберите справочник по номеру( 1-$nom ):");
	   $param = <STDIN>; 
       chomp($param);
	   
       $dbconn= &Connect_fb( $name_odbc,$usr,$pass,$sprav_eis[$param]->{"sqltext"} );
	   &Fetch_fb( $dbconn,$sprav_eis[$param]->{"sqltext"}, $sprav_eis[$param]->{"namespr"}.'.csv' );
	   
	   print &txt_consol('выбрали '. $sprav_eis[$param]->{"id"}.' '.$sprav_eis[$param]->{"namespr"} )."\n";
	   
	   &Disconn_fb($dbconn);
	   $exit ='yes'; 
	}
	
  }
  elsif($param eq 'h'){
	 print &txt_consol("ключи:\n d-Список справочников ЕИСОМС\n h-помощь по командам(почта:maxim_7\@mail.ru)\n q-выход из программы \n\n");
  }
  elsif($param eq 'q') { 
     print &txt_consol("выход.\n"); 
     exit ;}
  else { 
    print &txt_consol("не верный параметр.\n"); 
	}
}
#-------------------------------------------module---------------------------------------------------------------------------------------------------- 
sub Connect_fb
{  
   my($dsn,$user,$pwd,$sql) ='';
     ($dsn,$user,$pwd,$sql)= @_;    
   
   my $db = new Win32::ODBC("DSN=$dsn;UID=$user;PWD=$pwd") or die Win32::ODBC::Error();### Connect to a data source

   if ($db->Sql($sql)) ### Prepare and Execute a statement
   {
        print &txt_consol("SQL Error:  $db->Error() ");
        $db->Close();
        exit;
   }
   return $db;  
}
	
sub Fetch_fb{
    my ($db,$sql,$file)='' ;
	   ($db,$sql,$file)= @_ ;
	
	open (FILE,'>load.csv') or die ("Error write mode file $! ");
    
	my @row1 ;
	
	my @tmp = split (/from/, $sql ) ; 
	my @tmp = split (/when/, $tmp[0] ) ; 
	$sql = $tmp[0];
	
	$sql =~ s/,/;/g ;
	$sql =~ s/select//g ;
	$sql =~ s/as/-/g ;
	
	print FILE $sql."\n" ;
	
### Fetch row from text source
    my $i=1;
    while ($db->FetchRow) {
        @row1 =  $db->Data();  ### Get data values from the row
		chomp(@row1);
		$text[$i] = join(";",@row1);
    	$text[$i] =~ s/\r//g; 
	    print FILE $text[$i]."\n" ;	
		$i++;
   }
   $nom=$row1[0];# ! index mass
   close(FILE);
   
   if ($file ne '-') {
     rename('load.csv',$file);
   }  
}
	 
sub Disconn_fb{
### Disconnect
    my $db = shift();
    $db->Close();
	#print "end\n";
}
#------------------------------------------------------------------------------------------------------------
sub txt_consol(){
  my $s1 = shift();
  return  Encode::encode('cp866',Encode::decode('cp1251', $s1)) ;
};