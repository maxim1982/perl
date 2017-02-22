use strict;
use XBase;
use DBI;
use Encode qw(encode decode);

sub write_consol(){
my ($cp_from,$str) = @_;
print Encode::encode('cp866',Encode::decode($cp_from, $str))."\n";
}

&write_consol('utf8',"Утилита выгрузки dbf в SQL .Версия 1.12.(maxim_7\@mail.ru).");

if (!$ARGV[0]) {
 &write_consol('utf8',"Введите строку : <Утилита.exe> <файл_источник.dbf> <целевой_файл_ODBC> <user> <passwrd> <ключ 'del'-удаление таблицы (либо пусто)>");
 exit;
}

my $file_dbf = $ARGV[0];
my $ind=0; #count for 

my $usr = $ARGV[2]; #$usr $pwd
my $pwd = $ARGV[3];

my $tab_dbf = new XBase $file_dbf or die XBase->errstr;

my @name_dbf = split ("[.]", $ARGV[0]);

&write_consol('utf8',"\nЧитаем структуру таблицы: $file_dbf ");

my @type_field = split("[,]",join(",",$tab_dbf->field_types));
my @name_field = split("[,]",join(",",$tab_dbf->field_names));

my $create_tab = "CREATE TABLE $name_dbf[0] ( " ;# .join(",",$tab_dbf->field_names).')';

#my @byte = split( ",",join(",",$tab_dbf->field_lengths) );
my @byte = $tab_dbf->field_lengths;

my $count_field = 0;

for (my $t=0 ; $t<@type_field ; $t++)
{  
   if ( length($name_field[$t])>9 ){ $name_field[$t] = $name_field[$t].'_'.$t ;} # важно ,если у Васи в названии поля более 9 символов , 
                                                                                  #то есть вероятность что появится дубль поля по названию                                                                                   # тк утилита dbatodbf32 отрезает название до 10 символов.    
   if ($type_field[$t]  eq 'N') { $create_tab.=$name_field[$t] ." INT," ; }
   if ($type_field[$t]  eq 'L') { $create_tab.=$name_field[$t] ." INT,";}
   if ($type_field[$t]  eq 'O') {  $create_tab.=$name_field[$t] ." CHAR($byte[$t]),";}
   if ($type_field[$t]  eq 'C') {  $create_tab.=$name_field[$t] ." CHAR($byte[$t]),";}
   if ($type_field[$t]  eq 'D') { $create_tab.=$name_field[$t] ." DATE,";}
 
   $count_field=$t;
   last if ($t > 125) # прерываем цикл  тк ограничение (библиотеки)на БД Аксеса по кол-ву полей 125 ?!.
 }

chop($create_tab);
$create_tab.= " );";

my $export_db= $ARGV[1]; #'db'; #access odbc

my $r = 0;
my $str_insert ='';
my $dbexp =''; 

if ( $ARGV[4] eq 'del' ){  
    &write_consol('utf8',"\nУдаляем таблицу ".$name_dbf[0]." в базе $export_db ");   
    &create_mdb($export_db,'drop table '.$name_dbf[0]);
	exit;
}
elsif($ARGV[4] eq '' ) {
   &write_consol('utf8',"\nСоздаем таблицу ".$name_dbf[0]." в базе $export_db ");   
   &create_mdb($export_db,$create_tab);

   &write_consol('utf8',"\nЗаписываем данные в  $name_dbf[0]:");   

   my $conn_mdb = "DBI:ODBC:".$export_db;  	
   $dbexp=DBI->connect($conn_mdb,$usr, $pwd) or ('ОШИБКА ПОДКЛЮЧЕНИЯ :'.$dbexp->errstr());
   $dbexp->{LongTruncOk} = 0; 
   $dbexp->{RaiseError} =0;	
   my $exp_res ='';

   for (0 .. $tab_dbf->last_record){
     my ($delete, @nom_row) = $tab_dbf->get_record($_);
     $r = $r+1;
     my $param = "'";
   
     for ( my $i=0; $i <= $count_field ;$i++ ){
       $nom_row[$i] =~ s/'/-/ig; 
       if ($type_field[$i]  eq 'D') 	{
	     if( $nom_row[$i] eq '')
		  { 
		   $param .='1900-01-01';
		   #$param .='NULL';
		 }
		else
		 {
          $param .= substr ($nom_row[$i],0,4).'-'.substr ($nom_row[$i],4,2).'-'.substr ($nom_row[$i],6,2);
		 }
	   } 
	  else{ $param .= $nom_row[$i];}
	 
	  if( $i < ($count_field) ) { $param .= "','" ;}
	  else {$param .= "'" ;}
    }
    my $s='*';
	for ( my $r = 0 ; $r < 61 ; $r++ ) { 
		 $s  = $s . '*';
		 print("\t\r".$s); 
		}
	
	$str_insert = Encode::encode('cp1251',Encode::decode('cp866', "insert into $name_dbf[0]  values ($param);"));
  	$exp_res = $dbexp->prepare($str_insert) or &write_consol('cp1251',"ОШИБКА В ЗАПРОСЕ (\nNstr=$r):".$exp_res->errstr());
	$exp_res->execute() or &write_consol('cp1251',"\nNstr=$r : $str_insert : ".$exp_res->errstr());
	
	$exp_res->finish();
 }
  $tab_dbf->close;
  $dbexp->disconnect();	
  &write_consol('utf8',"\nКол-во записей-$r \n");   
  
}

sleep(3);

#--------------------------------------------------------------------------
sub create_mdb(){
    
	my($mdb,$SQL_text) =@_;
	my $conn_mdb1 = "DBI:ODBC:$mdb";  
	my $exp_res1 ='';
	my $dbexp1 ='';
	$dbexp1=DBI->connect($conn_mdb1,$usr, $pwd) or &write_consol('cp1251','ОШИБКА ПОДКЛЮЧЕНИЯ :'.$dbexp1->errstr());
    
	$dbexp1->{LongTruncOk} = 1; 
	$exp_res1 = $dbexp1->prepare($SQL_text) or &write_consol('cp1251','ОШИБКА В ЗАПРОСЕ '.$exp_res1->errstr());
	
	$exp_res1->execute() or &write_consol('cp1251',"\nN=$r : $SQL_text : ".$exp_res1->errstr());
	
	$exp_res1->finish();
	$dbexp1->disconnect();	
 }