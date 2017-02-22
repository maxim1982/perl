 use Encode qw(encode decode);
 use LWP::Simple ;

 my $url=$ARGV[0]; 
 my $res=get($url);
 
 print  Encode::encode('cp866', Encode::decode('cp1251',decode_char($res) ));
 
 
 #my $url=$ARGV[0];  
 #my $res=get($ARGV[0]); 
 #print $res;
 #open (FILE2,'>1.html') or die ("ошибка в работе с файлом 1.html : $!");
 #print FILE2 Encode::encode('cp866', Encode::decode('cp1251',decode_char($res) ));
 #close(FILE2);
 #-----------------------------------------------------------------------------
 sub decode_char
{
  my $string = shift(@_);
  $string =~ s/\+/ /g;
  $string =~ s/%([0-9A-F]{2})/pack('C',hex($1))/eg;
  return $string ;  
}