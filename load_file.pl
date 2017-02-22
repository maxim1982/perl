#!c:/perl/bin/perl.exe
use strict;
use warnings;
#use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard);
use Encode;

use HTML::TokeParser;
use HTML::Entities;

print "Content-type: text/html;   \n\n";

my $file_csv ="";

if ( index( param("file") ,".csv") ){
    $file_csv = param("file"); 
    open (FILE2,$file_csv) or die ("Страница в разработке... $!");

    print "<table border=\"1\" cellspacing=\"0\"  cellpadding=\"0\"><tr> <td>";
    while (<FILE2>)
    {
       my $str = $_  ;
	   $str =~ s/;/<\/td><td>/g ;
	   $str =~ s/\n/<\/tr><tr><td>/g ;
	   #print  $str;	 
	   print  decode('utf8',$str);	   
   }
   close(FILE2);  
   print " </tr></table>";

}



