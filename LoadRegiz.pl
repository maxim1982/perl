#!c:/perl2/bin/perl.exe
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);

use CGI qw( :standard);
use Cwd;
use Encode qw(encode decode);
use locale;

print "Content-type: text/html; \n\n";
print "<head><title> Веб-приложение для определения bad-файлов </title> <meta charset=\"utf-8\"></head> <body>";
print '<b><p> Приложение для определения неотправленных bad-файлов в РЕГИЗ (версия 1.07 test)</p></b>';

# --- блок для чтения параметра PATHEXPORTORDERACROS из tcgi*.ini
my $file ="";
my ($tag,$param) ="";
my ($tag1,$param1) ="";

if ( index( param("file") ,".ini")!=-1 ) {
    
	$file = param("file"); 
    open (FILE2,$file) or die ("Ошибка чтения файла: $!");
    
	while (<FILE2>)
    {
       my $str = $_  ;
	   if (index ($str,'PATHSAVEFILEREGSEG') !=-1) {
	     ($tag,$param) = split(/=/,$str) ; 
	   }
	   elsif(index ($str,'PATHEXPORTORDERACROS') !=-1) {
	     ($tag,$param) = split(/=/,$str) ; 
	   }
	   elsif( index ($str, 'titlenomer') !=-1) {
	     ($tag1,$param1) = split(/=/,$str) ; 
	   }
	 } 
   close(FILE2);  
 
}
else{ print "Не верный входной параметр ... <br>"; }

#----- блок для определения команд
 
 if ( index( param("metod") ,"sendreq")!=-1 ) # отправляем данные в РЕГИЗ
   {  
      chop($param);
      open (FILE2,'>open.bat') or die ("Ошибка чтения файла: $!");
      print FILE2 ($param."sendreq.bat");
      close(FILE2);	
  
      system ('open.bat');  
   }
   
   if ( index( param("metod") ,"readbad")!=-1 ) # считываем  данные не отправленные в РЕГИЗ
   { 
      &Read_File_Reg($param,'.bad','.req');  # находим  bad-файлы   
   }
   
   if ( index( param("metod") ,"readreq")!=-1 ) # считываем  данные не отправленные в РЕГИЗ
   { 
      &Read_File_Reg($param,'.req','.bad');  # находим  req-файлы   
   }
   
my @mTime= localtime(time()); # определяем системное время   
print '<p> Время запроса: '.$mTime[2].":".$mTime[1].":".$mTime[0]." , ".$mTime[3]."/".($mTime[4]+1)."/".($mTime[5]+1900).'</p>';   

print "</body>";

#--------функция---для--конвертации--кодировки- utf  => win 1251----
sub txt_convert(){
  my $s = shift();
  return  Encode::encode('cp1251',Encode::decode('utf8', $s)) ;
};

#----------функция---для--обработки---bad-файлы ---------------------

sub Read_File_Reg($)
{  my ($path,$ex_file1,$ex_file2) ='';
  
  ($path,$ex_file1,$ex_file2) = @_;

   print 'Источник: '.Encode::encode('utf8',Encode::decode('cp866', $param1)).'</p>';
   my $path1=$path;
   $path =~ s/\\/\\\\/g; # формат для работы с:\ -> c:\\
   chomp($path); # убираем лишний символ в конце строки
 
   my $count_f1=0; # счетчик bad-файлов
   my $count_f2=0;# счетчик req-файлов
   chdir($path);
   my ($file_name ,@file);
   
   opendir(DIR, $path) or die("Ошибка $!"); # Открываем каталог 
   
   foreach(readdir(DIR)) { # Читаем каталог 
     $file_name = $path . $_;
	 # ищем файлы .bad
     if ( (-f $file_name) && (index( $file_name ,$ex_file1)!=-1 ) ) 
	 {	 push(@file, $_);	# 	Найденны файлы bad собираем к себе 
     }
     elsif ( (-f $file_name) && (index( $file_name ,$ex_file2)!=-1 ) ) 
	 {	 $count_f2++;	# 	Найденны файлы bad собираем к себе 
     }  	 
    }
	
    closedir(DIR); # Закрываем каталог  
    if  (scalar(@file)>0 ) { print "<p> Найденны $ex_file1 - файлы :</p>";	}
	
    print "<UL>\n"; 

	for (my $i=0; $i<@file; $i++) { 
       print "<LI>$file[$i]\n"; 
	   
	   my $text ='';
	   open(F2,$file[$i]) or die ("ERROR FILE $!"); 
        { 
         local $/ = "";
         $text = <F2>;  # записываем весь файл в переменную
        };
       close(F2);
	   
       print '<p>'. &parser_bad($text).'</p>' ;
	
   	   $count_f1 =$i+1;  # корректируем сумму 
    }
    print "</UL>\n"; 
  
  print "<p>Путь к пакетным РЕГИЗ-файлам : $path1 </p>";
  print "<b><p> Кол-во файлов $ex_file1 : $count_f1 </p></b>" ;
  print "<b><p> Кол-во файлов $ex_file2 : $count_f2 </p></b>" ;
 
}
# -------------------лог читаем---------------------------------


# -- разбор- текста в читаемый вид-
sub parser_bad {

my ($xml_data)=@_;
  
  $xml_data =~ s/<tem:patientFIO>/<big><b><tem:patientFIO>/g;
  $xml_data =~ s/<\/tem:patientFIO>/<\/tem:patientFIO><\/big><\/b>/g;
  $xml_data =~ s/<tem:patientBirthDate>/<big><b><tem:patientBirthDate>/g;
   
  $xml_data =~ s/<\/tem:patientBirthDate>/<\/tem:patientBirthDate><\/big><\/b>/g;
  
   return $xml_data;
}
