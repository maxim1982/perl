
use XBase;
use DBI;
use Encode qw(encode decode);

sub write_consol(){
my ($cp_from,$str) = @_;
print Encode::encode('cp866',Encode::decode($cp_from, $str))."\n";
}

&write_consol('utf8',"Утилита выгрузки из .dbf в Access .Версия 1.03 .\nАвтор:Лютов М.А. (maxim_7\@mail.ru) ).");

if (!$ARGV[0]) {
 &write_consol('utf8',"Введите файл dbf : <Утилита.exe> <файл_dbf.dbf> ");
 exit;
}

my $file_dbf = $ARGV[0];
my $ind=0; #count for 

my $tab_dbf = new XBase $file_dbf or die XBase->errstr;

@name_dbf = split ("[.]", $ARGV[0]);

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

&write_consol('utf8',"\nСоздаем таблицу в Access :".$name_dbf[0]);   
#print  $create_tab;

&create_mdb('db_report',$create_tab);

&write_consol('utf8',"\nЗаписываем данные в Access...");   

my $str_insert ='';
my $r =0;

for (0 .. $tab_dbf->last_record){
   my ($delete, @nom_row) = $tab_dbf->get_record($_);
   $r = $r+1;
   my $param = "'";
   
   for ($i=0;$i<=$count_field ;$i++){
     
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
   
   #print "$r";
   #print  $str_insert."\n" ;

   $str_insert = Encode::encode('cp1251',Encode::decode('cp866', "insert into $name_dbf[0]  values ($param);"));
   create_mdb('db_report',$str_insert);   
}

#print $name_dbf[0] ."\n";
#print join(",",$tab_dbf->field_types) ;print "\n";
#print join(",",$tab_dbf->field_lengths) ;print "\n";
#print join(",",$tab_dbf->field_decimals) ;print "\n";
#print scalar(@type_field) .'-'.scalar(@name_field);

$tab_dbf->close;
&write_consol('utf8',"\nКол-во записей-$r \nЗавершение выгрузки !");   
sleep(1);

#--------------------------------------------------------------------------
sub create_mdb(){
    
	my($mdb,$SQL_text) =@_;
	my $conn_mdb = "DBI:ODBC:$mdb";  
	
	my $dbexp=DBI->connect($conn_mdb,'','') or ('conn db:'.$dbexp->errstr());
    
	#$dbexp->{LongTruncOk} = 1; 
	my $create_db = $dbexp->prepare($SQL_text) or ('prepare db:'.$create_db->errstr());
	
	$create_db -> execute() or &write_consol('cp1251',"\nN=$r : $SQL_text");#('err db:'.$create_db->errstr());# $dbexp->do("drop table $name_dbf[0]");
	$create_db->finish();
 }