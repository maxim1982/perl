#!c:/perl/bin/perl.exe
use strict;
use warnings;
#use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use Encode;

use HTML::TokeParser;
use HTML::Entities;

print "Content-type: text/html;   \n\n";
print "<p>Web-app for load data REGIZ (1.03)</p>";
my $file ="";

#$file =~ s/.exe//g;

my ($tag,$param) ="";

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
	 }
   close(FILE2);  
   
  chop($param);
  open (FILE2,'>open.bat') or die ("Ошибка чтения файла: $!");
  print FILE2 ($param."sendreq.bat");
  close(FILE2);	
  
  system ('open.bat');
    
}
else{ print "Не верный входной параметр ... <br>"; }
