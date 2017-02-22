#!C:/Perl/bin/perl
use strict;
#use CGI::Carp qw(fatalsToBrowser);
#use CGI qw( :standard); 

use Encode qw(encode decode);

print "Content-Type: text/html\n\n";
#-------------------------------загрузка--конфиг-------------------------------------------------
my $file_ini = 'import_csv.ini'; 			   

my @conf_file =(
         { 
          "in_file"=> 'report_11.txt',		  
          "out_file"=> 'report_22.csv',
		  "path_file"=> 'http://127.0.0.1:80/'
         },
   );

open (FILE2,$file_ini) or die ("Ошибка в работе с файлом : Дальнейшая работа НЕ возможна <br/>( $! )");

while (<FILE2>){
   my($in_f,$out_f,$p_file)= split(/;/);	
   
   push(@conf_file,
      { "in_file" => $in_f,		  
         "out_file" => $out_f,
		 "path_file" => $p_file
      },
   );
}
close(FILE2);  

#print $conf_file[1]->{"in_file"};
#print $conf_file[1]->{"out_file"};
#print $conf_file[1]->{"path_file"};
#print 'переменная окружения CGI [SCRIPT_FILENAME] : '.$ENV{'SCRIPT_FILENAME'}."<br/>";

my $path_log = $ENV{'DOCUMENT_ROOT'}.$conf_file[1]->{"out_file"};
#--------------------------------------------------------------------------------------------------------------
print <<METKA1;
<HTML><HEAD>
<TITLE>Отчет выгружен в таблицу CSV!</TITLE>
</HEAD>
<BODY>
<a href="$conf_file[1]->{"path_file"}/$conf_file[1]->{"out_file"}"> [Скачать отчет] </a>
</BODY></HTML>
METKA1
#--------------------------------------------------------------------------------------------------------------

my $file_in = $conf_file[1]->{"in_file"}; 

open (IN,$file_in) or die ("Error file : $!");

my $file_out =  $path_log ;
open (OUT,'>:encoding(cp1251)',$file_out) or die ("Error file : $!");

my $load_txt;
{  local $/ = "";
   $load_txt  = <IN>;   
}

$load_txt =  Parse_html2($load_txt) ;
print OUT txt_consol($load_txt );

close(IN);
close(OUT);

#----------------------------------------------------------------------------------
sub Parse_html2($){
   my ($html_tag)=@_;
   $html_tag =~ s/\n//g;
   $html_tag =~ s/\r//g;
   
   $html_tag =~ s/<body>//g;
   $html_tag =~ s/<\/body>//g;
   
   $html_tag =~ s/<html>//g;
   $html_tag =~ s/<\/html>//g;

   $html_tag =~ s/<table>//g;
   $html_tag =~ s/<\/table>//g;

   $html_tag =~ s/<TD>//g;
   $html_tag =~ s/<\/TD>/;/g;
   
   $html_tag =~ s/<TH>//g;
   $html_tag =~ s/<\/TH>/;/g;
   
   $html_tag =~ s/<th>//g;
   $html_tag =~ s/<\/th>/;/g;
   
   $html_tag =~ s/<TR>//g;
   $html_tag =~ s/<\/TR>/\n/g;
   
   $html_tag =~ s/<p>//g;
   $html_tag =~ s/<\/p>//g;
   
   $html_tag =~ s/<br>/\n/g;
   $html_tag =~ s/<br\/>/\n/g;

   $html_tag =~ s/<b>//g;
   $html_tag =~ s/<\/b>//g;
   
   $html_tag =~ s/<TABLE width="100%" border="1" cellspacing="0">//g;   
   $html_tag =~ s/<\/TABLE>/\n/g;
   
   $html_tag =~ s/<center>//g;
   $html_tag =~ s/<\/center>/\n/g;
   
   $html_tag =~ s/<right>//g;
   $html_tag =~ s/<\/right>/\n/g;
   
   $html_tag =~ s/&nbsp;//g;
   
   $html_tag =~ s/<span style="text-transform: lowercase">//g;
   $html_tag =~ s/<\/span>//g;
   
   return $html_tag;
}

sub txt_consol(){
  my $s1 = shift();
return  Encode::decode('cp866', $s1);
};