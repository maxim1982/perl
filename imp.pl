#!c:/perl/bin/perl.exe
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);
use Encode;

use HTML::TokeParser;
use HTML::Entities;

print "Content-type: text/html\n\n";
#--------------------------------------------------------------------------------------------------------------
print <<METKA1;
<HTML><HEAD>
<TITLE>Отчет выгружен в таблицу !</TITLE>
</HEAD>
<BODY>
<a href="http://10.129.107.254:81/report2.csv"> Посмотреть отчет </a>
</BODY></HTML>
METKA1
#--------------------------------------------------------------------------------------------------------------

open (FILE1,'Report1.txt') or die ("Error $!");
open (FILE2,'>Report2.txt') or die ("Error $!");
my @mas1;
while (<FILE1>)
   {
    my $str = $_  ;
    @mas1 = split(/&nbsp/,$str);
    print FILE2 @mas1; 
   }
close(FILE1);
close(FILE2); 


open (OUT_FILE,">:encoding(cp1251)",'C:/Apache2/otchet/www/report2.csv') or die ("error - $!");  #write in win1251  >:encoding(cp1251)

my @tages=("tr","td","th");

my $parser = HTML::TokeParser->new("report2.txt") ;
my $str="";
my $i=0;
my @mas;

while ( my $item = $parser->get_tag(@tages) ){
       
       if ($item->[0] eq 'td' ){   
          $str = $parser->get_trimmed_text("/td");   
            
          print OUT_FILE decode('cp866',$str ); # out cp866           
          print OUT_FILE ";";
        }

        if ($item->[0] eq 'th' ){
          $str = $parser->get_trimmed_text("/th");       
          print OUT_FILE  decode('cp866',$str ); # out cp866
          print OUT_FILE ";";
        }        

        if ($item->[0] eq 'tr' ){
           print OUT_FILE "\n"; 
        }
       # print $i++."\n" ;
}
close(OUT_FILE); 
#--------------------------------------------------------------------------------------------------------------