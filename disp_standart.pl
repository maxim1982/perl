#!C:/Perl2/bin/perl
no warnings 'layer';
use strict;
use CGI qw( :standard); 
use CGI::Carp qw(fatalsToBrowser);
use JSON;
print "Content-type: text/html\n\n"; 

my $file_js ='disp_standart.json';

open (FILE2,$file_js) or die ("ошибка в работе с файлом disp_standart.json: $!");
my @json_text = <FILE2>; 
close(FILE2);

my $json_data = join("\n",@json_text);
#print ($json_data) ;

 #----------------------------------------------------------------------------------------------- 
&head_html();
my $q = new CGI;
my $sex = ($q->param("sex")) ;

 if ( $sex eq 'Рњ') { $sex ='М';}
 elsif( $sex eq 'Рј') { $sex ='М';}
 elsif( $sex eq 'I') { $sex ='М';}
 elsif( $sex eq 'i') { $sex ='М';}
 
 elsif( $sex eq 'Р–') { $sex ='Ж';}
 elsif( $sex eq 'Р¶') { $sex ='Ж';} 
 elsif( $sex eq '?') { $sex ='Ж';} 
 #elsif( $sex eq 'Рј') { $sex ='Ж';}

 else { print "<p>Не корректный задан параметр 'sex'(пол) : $sex </p>" ;exit();}
 
 
my $year = $q->param("year") ;
my $pattern='(\d{2})/(\d{2})/';
$year =~ s/$pattern//gm;
#print "ответ ". $sex . $year ."<br/>\n";
 
my $ref = JSON->new->decode($json_data);
my $arr = $ref->{"standart"};

for my $item ( @$arr ){
    $item->{"operation"} =~ s/;/<br\/>/g;

	if( ( index($item->{"year"}, $year) != -1)
	         &&( $item->{"sex"} eq $sex ) ){ 
       print  "<h3>" . $item->{"operation"}."</h3>";
    }
}
 
&end_html();
#--------------------------------------------------------------------------------------------------------------

sub head_html{
print <<HTML;
<!DOCTYPE html>
<html>
<head>
<link id="localcss1" type="text/css" rel="stylesheet" >
<title> Форма услуг </title> 
<h4> Перечень исследований, положенных по стандарту:</h4>
</head>
<body>
HTML
}

sub end_html
{
  print "\n<br/></body>\n</html>\n";
  exit(0);
}
