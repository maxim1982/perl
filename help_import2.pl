use strict;
use Encode qw(encode decode);

print txt_consol("правка файлов .bad (ЖДЕМ НОВОГО СЕРВИСА) \n\n");
#-----------------------------------------------------------------			
my @files = <*.bad>;
my $i;
my $count_all =0;

for( $i=0; $i<scalar(@files);$i++){
   my $text;
   my $name_file = '>'.$files[$i] ; # режим перезаписи файла
	
   open(F2,$files[$i]) or die ("ERROR FILE $!"); 
   { 
    local $/ = "";
    $text = <F2>;  # записываем весь файл в переменную
   };
   close(F2);
   
   open(F2,$name_file) or die ("ERROR FILE $!"); 
   my $pattern = ':  /  /    ';
   $text =~ s/$pattern//g;  # убираем текст 1
   
   $pattern=':(\d{2})/(\d{2})/(\d{4})'; 
   $text =~ s/$pattern//gm; # убираем текст 2
   print F2 $text ; # записываем в файл bad
   close(F2);
  
   $count_all = $i; # кол-во файлов bad
 }
 
 $count_all = $i;
 
 print txt_consol("Кол-во обработанных файлов $count_all");
 sleep(2);

#------------------------------------------------------------------------------------------------------------
sub txt_consol(){
  my $s1 = shift();
  return  Encode::encode('cp866',Encode::decode('utf8', $s1)) ;
};