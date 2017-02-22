#!c:/perl/bin/perl.exe
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);
use Encode;
use HTML::TokeParser;
use HTML::Entities;
use Spreadsheet::WriteExcel;

print "Content-type: text/html\n\n";
#--------------------------------------------------------------------------------------------------------------
print <<METKA1;
<HTML><HEAD>
<TITLE>Отчет выгружен в таблицу (v1\.23)</TITLE>
</HEAD>
<BODY>
<a href="http://10.129.107.254:8080/reestr_fcc.xls"> Скачать отчет </a>
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

my @tages=("tr","td","th");

my $parser = HTML::TokeParser->new("report2.txt") ;
my $str="";
my $i=0;
my @mas;

my $workbook = Spreadsheet::WriteExcel->new("c:/Apache2/http_bl/www/reestr_fcc.xls");
my $worksheet1=$workbook->add_worksheet('reestr_bl');
$worksheet1->set_column(1,8,50);

my $format = $workbook->add_format(valign=>'vcenter',align=>'left');
$format->set_size(12); 
$format->set_text_wrap();
#$format->set_bold();
$format->set_border();

my $i=-1;
my $j=0;

while ( my $item = $parser->get_tag(@tages) ){
      
	   if ($item->[0] eq 'th' ){
		  $str = $parser->get_trimmed_text("/th");       
          $worksheet1->write($i,$j,decode('cp866', $str ),$format);
		  #print  $i."-".$j."-".$str .";\n";
		  $j=$j+1;
		}
	   
       if ($item->[0] eq 'td' ){   	   
          $str = $parser->get_trimmed_text("/td"); 
          $str =~ s/\//\./g ;        
		  $worksheet1->write($i,$j,decode('cp866', $str ),$format);
		  $j=$j+1;
          #print  $str .";\n";		 
        }

        if ($item->[0] eq 'tr' ){
		 $i=$i+1;
		 $j=0;
        }
} 

$workbook->close();

#print `reestr_fcc.xls`;
