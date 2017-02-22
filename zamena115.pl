#use warnings;
use strict;
use Encode qw(encode decode);
print txt_consol("Утилита для очистки не нужных услуг\nВходные файлы: oper.csv , queue.csv \nВыходной файл в queue2.csv\n") ;
sleep(5);

load_operile('oper.csv','queue.csv','>queue2.csv');

#----------------------------------------------------------------------------
sub load_operile(){
my($uslug,$q_in,$q_out) =@_;
my ( $load_q,$i,$k,$tmp);

open (op,$uslug) or die ("no file  : $!");
my @load_oper  = <op>;

open (in,$q_in) or die ("no file  : $!");

{  local $/ = "";
   $load_q  = <in>;   
}
   
for ( $i=0; $i < scalar(@load_oper) ; $i++ ){ 
	 $tmp = ''.$load_oper[$i];
	 chomp($tmp); 
  	 $load_q =~ s/($tmp)//ig;
	 
	 print "\n stroka:" .$i .'('.$tmp.')' ;
	 #print $load_q ;
}

open(out,$q_out) or die ("no file  : $!");
print out $load_q ;

close (out);
close(in);	  	
close(op);	  	

}

sub txt_consol(){
  my $s1 = shift();
  return  Encode::encode('cp866',Encode::decode('cp1251', $s1)) ;
};
 