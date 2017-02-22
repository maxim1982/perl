#!C:/Perl/bin/perl
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard); 
use Encode;

print "Content-Type: text/html\n\n";

my $file_csv = 'setOrderAkros.log'; 
open (FILE2,$file_csv) or die ("Error file - setOrderAkros : $!");

my $load_q;
{  local $/ = "";
   $load_q  = <FILE2>;   
}

ParsXML2($load_q);
close(FILE2);


#----------------------------------------------------------------------------------
sub ParsXML2($){
   my ($xml_data)=@_;
   $xml_data =~ s/<XML>//g;
   $xml_data =~ s/<GETVERSION>//g;
   $xml_data =~ s/<VERSION>//g;
   
   $xml_data =~ s/<\/XML>//g;
   $xml_data =~ s/<\/GETVERSION>//g;
   $xml_data =~ s/<\/VERSION>//g;
   
   $xml_data =~ s/<RESULT>//g;
   $xml_data =~ s/<\/RESULT>//g;
   
   $xml_data =~ s/\n//g;
   $xml_data =~ s/\r//g;
   
   return $xml_data;
}