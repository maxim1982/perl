use strict;
use Encode qw(encode decode);

print txt_consol("правка файлов .bad (замена строк типа (:  /  /    :  /  /     ) \n\n");
#-----------------------------------------------------------------			
my @files = <*.bad>;
my $i;
my $count_all =0;

for( $i=0; $i<scalar(@files);$i++){
   analys_file($files[$i]);
   $count_all = $i;
 }
 
 $count_all = $i;
 print txt_consol("Кол-во обработанных файлов $count_all");
 sleep(2);
#------------------------------------------------------------------------------------------------------------ 
sub analys_file { 
   my $name_file= shift();
   my $text;
   open(F2,$name_file) or die ("ERROR FILE $!"); 
   { 
    local $/ = "";
    $text = <F2>;  
   };
   close(F2);
   
   $name_file = '>'.$name_file ;
   open(F2,$name_file) or die ("ERROR FILE $!"); 
   my $pattern = ':  /  /    ';
   $text =~ s/$pattern//g;
   
   $pattern=':(\d{2})/(\d{2})/(\d{4})';
   $text =~ s/$pattern//gm;
   print F2 $text ;
   
   close(F2);
 } 
sub txt_consol(){
  my $s1 = shift();
  return  Encode::encode('cp866',Encode::decode('utf8', $s1)) ;
};