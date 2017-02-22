#!C:/Perl/bin/perl
use LWP::Simple ;
#use CGI::Carp qw(fatalsToBrowser);
#use CGI qw( :standard); 
use Encode qw(encode decode);
use DBI;

my $version = $ARGV[0] ;
my $load = $ARGV[1];
my $log_base = $ARGV[1];
my $log_tabl ='';
my $timer = $ARGV[2];
my $index=0;
my $db ='';
my $day_send ='99';
#print "Content-Type: text/html\n\n";
my $break_for='false';

print txt_consol("Мониторинг работы REST-сервиса [версия 1.012 beta]\nВходные параметры:<модуль.exe> <номер_версии> <имя_лог_базы.db> <запуск цикла в сек> \n\n\n") ;

for ( ;$break_for ne 'true' ; ) {
if (defined($version)) {
	@mTime= localtime(time()); # определяем системное время
	$start_script = "Время начала : ".$mTime[2].":".$mTime[1].":".$mTime[0]." , ".$mTime[3]."/".($mTime[4]+1)."/".($mTime[5]+1900)."\n" ;
    
	if ( defined($log_base) and ($index == 0) ){
	   $index = $index + 1; 
	   $db = DBI->connect("dbi:SQLite:$log_base", "", "",{RaiseError => 1, AutoCommit => 1})  ;
	   $log_tabl=$log_base;
	   $log_tabl =~ s/.db//g ;
	   $db->do("CREATE TABLE $log_tabl (nom INTEGER,name_area TEXT (50),name_lpu TEXT (50),name_error TEXT (50),time_post TIME,date_post DATE); ") or die 'Error create dbase ...' ;
	}
	else { $db = DBI->connect("dbi:SQLite:$log_base", "", "",{RaiseError => 1, AutoCommit => 1}) ; ++$index ; } 
 	
	#---------------------------------------------------------------------------------	
	#my $file_csv = 'orgs.csv'; 
	my $file_csv ='orgs_my.csv';
	open (FILE2,$file_csv) or die ("ошибка в работе с файлом orgs_csv : $!");
	#---------------------------------------------------------------------------------	
	my @lpu_rest = (
		{ 
		"name" => "test",
		"info" => "test", 
		"url" => "test", 
		"area" => "test",
		"show" => "+"	 
		},
	);
	#---------------------------------------------------------------------------------	
	my $i=0; # кол-во rest-запросов 
	while (<FILE2>)
	{
		my $url ="";
		my $lpu ="";
		my $area ="";
		my $show="";
	
		($lpu,$url,$area,$show)= split(/;/);	     
		push( @lpu_rest,
			{ "name" => $lpu,
			"info" => "", 
			"url" => $url, 
			"area" => $area,
			"show" => $show  		  
			}
		);
	
		$i=$i+1;
	}
	close(FILE2);  
	@mTime= localtime(time()); # определяем системное время
	$load_file = "Обработан файл ORGS.csv : ".$mTime[2].":".$mTime[1].":".$mTime[0]."\n" ;
	
	#---------------------------------------------------------------------------------
	
	open (LOG1,'>log.csv') or die ("ошибка в работе с файлом log_csv : $!");
	print LOG1 "Название_ЛПУ ;Ответ_Rest ; URL_Rest-Сервиса; Район_ЛПУ \n";
	#---------------------------------------------------------------------------------  
	my $i_err=0; # ошибки
    my $old_ver=0; # старые версии	
	my $nom_ver='/GETVERSION';
	my $nom=0; # счетчик 
	my $red_status='';
	my $write_resault="";
	my $ver ="";
	my $find_error1='0';
    #----------------------------------------------------------------------------------	
	
	for (my $k=1;$k<=$i; $k++ ){
	  if ( $lpu_rest[$k]->{"show"} eq '+' ){  
		my $res=get($lpu_rest[$k]->{"url"}.$nom_ver);
	
		if ( defined($res) ) 
			{  $ver= decode_char($res) ; 
				$lpu_rest[$k]->{"info"} = ParsXML2($ver);	
			}
		else { $lpu_rest[$k]->{"info"} ='no data'; 
				$i_err++; }
	    #------------------------------------------------------------------------------ 		
		$red_status= '+' ; # Устанавливаем статус и проверяем его
		
		if ( $lpu_rest[$k]->{"info"}  ne 'no data'){ # исключаем ЛПУ из не отвеченных...  
		
		   if ( $version ne $lpu_rest[$k]->{"info"} ){ 
			  $old_ver= $old_ver+1;	
			  $red_status= '?'  ;  # и не та версия . ставим статус ?
			}
        }
		else {
		      $red_status= '-' ; # не отвеченная ЛПУ .ставим статус -
		      print LOG1 (" $lpu_rest[$k]->{\"name\"} ; $lpu_rest[$k]->{\"info\"} ; $lpu_rest[$k]->{\"url\"} ; $lpu_rest[$k]->{\"area\"} \n"); 
              $find_error1 ='1'; 			  
		
		}
		
		$nom=$nom+1;
	    @mTime= localtime(time()); # определяем системное время
		$time_post = "".$mTime[2].":".$mTime[1].":".$mTime[0] ; 
        
		$write_resault=" $nom $lpu_rest[$k]->{\"area\"}  $lpu_rest[$k]->{\"name\"}  $lpu_rest[$k]->{\"info\"}  $red_status \n" ;
		print txt_consol($write_resault );
		
		#  логирование в базу sqllite 
		$s_date="".$mTime[3].'/'.($mTime[4]+1).'/'.($mTime[5]+1900) ;
		$sql_param = decode('cp1251',"('$nom', '$lpu_rest[$k]->{\"area\"}', '$lpu_rest[$k]->{\"name\"}' ,'$lpu_rest[$k]->{\"info\"}', '$time_post' , '$s_date' )" ); 
		
		$db->do("INSERT INTO $log_tabl VALUES $sql_param");
        
		
	   }
	}
    
	
	close(LOG1);
	
	ParsHTML('log.csv');
	
	if ( $day_send ne  $mTime[3] ){
	    print txt_consol("\n---log.pdf---\n");
        print `wkhtmltopdf.exe log.htm log.pdf`;
		print txt_consol("---log.pdf---\n");
		sleep(2);
			
		if ($find_error1=='1'){  
		#	print `SendMail.exe sv-med\@mail.ru Лог_rest_сервисов  Лог_файл_прикреплен log.pdf`;
		#	print `SendMail.exe amax_l\@mail.ru Лог_rest_сервисов  Лог_файл_прикреплен log.pdf`;
	   } 
	   $day_send = $mTime[3];
	}
	
	$find_error1 ='0';
	 
	#--------------------------------------------------------------------------------	
	print txt_consol("Итог:\nНет ответа от ЛПУ:".$i_err ."\n");
	print txt_consol("Другие версий в ЛПУ:".$old_ver ."\n");
	print txt_consol("Заданной версий в ЛПУ:".($nom-$old_ver) ."\n");
	print txt_consol("Опрошено ЛПУ :".$nom."\n\n");
	#print txt_consol("Всего модулей :".$i."\n");
	
	print txt_consol($load_file);
	#-------------------------------------------------------------------------------	
	@mTime= localtime(time()); # определяем системное время
	$end_script = "Время окончания : ".$mTime[2].":".$mTime[1].":".$mTime[0]." , ".$mTime[3]."/".($mTime[4]+1)."/".($mTime[5]+1900)."\n" ;
	print txt_consol($start_script);
	print txt_consol($end_script);
	print "-----------------------------------------------------------------------------\n"; 
 }
 
 if ( $timer != '-1' ) { sleep ($timer);}
 else { $break_for ='true'; }

}
#----------------------------------------------------------------------------------
sub ParsHTML(){
  my ($file1) = @_;
  
  open (LOG6,$file1) or die ("ошибка в работе с файлом log_csv : $!");
  open (LOG7,'>log.htm') or die ("ошибка в работе с файлом log_htm : $!");
  print LOG7 "<html><head> <meta charset=\"windows-1251\"></head><body> <p>Лог проверки REST-сервиса СВ-Мед </p>";
  
  print LOG7 "<table border=\"1\" cellspacing=\"0\"  cellpadding=\"0\"><tr> <td>";
  
  while (<LOG6>)
  {   my $tag_txt = $_  ;
	  $tag_txt =~ s/;/<\/td><td>/g ;
	  $tag_txt =~ s/\n/<\/tr><tr><td>/g ;
	  print LOG7 $tag_txt;	   
  }
  close(LOG6);
  
  
  @mTime= localtime(time()); # определяем системное время
  print LOG7 "<p>Дата лога : ".$mTime[2].":".$mTime[1].":".$mTime[0]." , ".$mTime[3]."/".($mTime[4]+1)."/".($mTime[5]+1900)."</p>";
  print LOG7 "</tr></table>";
  print LOG7 "</body></html>";
  close(LOG7);
 
}	
 sub ParsXML2($){
   my ($xml_data)=@_;
   
   $xml_data =~ s/\n//g;
   $xml_data =~ s/\r//g;
   
   
   $xml_data =~ s/<XML>//g;
   $xml_data =~ s/<GETVERSION>//g;
   $xml_data =~ s/<VERSION>//g;
   
   $xml_data =~ s/<\/XML>//g;
   $xml_data =~ s/<\/GETVERSION>//g;
   $xml_data =~ s/<\/VERSION>//g;
   
   $xml_data =~ s/<RESULT>//g;
   $xml_data =~ s/<\/RESULT>//g;
   
   if ( (length $xml_data) > 82) { print "error rest \n";}
   
   return $xml_data;
  # return $tree->{'XML'}->{'GETVERSION'}->{'VERSION'}->{'value'};
}

 sub decode_char
{
  my $string = shift(@_);
  $string =~ s/\+/ /g;
  $string =~ s/%([0-9A-F]{2})/pack('C',hex($1))/eg;
  return $string ;  
}

sub txt_consol(){
  my $s1 = shift();
  return  Encode::encode('cp866',Encode::decode('cp1251', $s1)) ;
};