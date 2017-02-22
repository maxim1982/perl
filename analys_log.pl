use strict;
use Data::Dumper qw(Dumper);
use Encode qw(encode decode);

print txt_consol("Анализ логов stop_timer_n*.txt (ver 1.005) \n\n");

my @summ=(
         {
		  "count_"=>'0',
		  "rull_" =>"IDENTFOND"
		 }
);
#my @tmp= (
#		{"user" => "",
#		 "rull" => "", 
#		 "param" => "",
#		 "date" => "",
#         "time" => "",
#		 "file" => "",
#		 "namecgi"=>"" 		 
#		},
#	);

my @tmp ;

#-----------------------------------------------------------------		
my $i_tmp=0;	
my @files = <stoptimer_n_*.txt>;
my @load_f;
my $count_all =0;

 my $path_res = 'result_log.csv';
 open (FILE1,'>'.$path_res) or die ("ошибка в работе с файлом result_log_csv : $!");
  
 print FILE1 "Дата; Время; Пользователь ;Команда  ;Параметры запроса; Файл ; Процесс \n";

for( my $i=0; $i<scalar(@files);$i++){
   analys_file($files[$i]);
   $count_all = $i;
 }
 
 close(FILE1);
 
 print  txt_consol("Результаты сохранены в файл result_log.csv"); 
 sleep(2);
 print `result_log.csv`;
 
#------------------------------------------------------------------------------------------------------------ 
sub analys_file { 
   my $name_file= shift();
   open(F2,$name_file) or die ("ERROR FILE $!");
   @load_f = <F2>;
   close(F2);
         
   my @time_stop= ('-','-','-','-'); 
   @time_stop=split(/ /,join (' ',$load_f[0]) );
   
   chomp($time_stop[3]); 
       
   #--------------------------------------------------!
   push( @tmp ,   
	    { "file" => $name_file,
		  "time" => $time_stop[2],
		  "date" => $time_stop[0],
		  "user" =>  get_user($load_f[2]) ,
          "param" => get_param($load_f[2]),
          "namecgi"=> $time_stop[3],		  
          "rull" => get_rull($load_f[2])		  
	    },
    );
	
   print FILE1 "$tmp[$i_tmp]{'date'};" ;
   print FILE1 "$tmp[$i_tmp]{'time'};" ;
   print FILE1 "$tmp[$i_tmp]{'user'};" ;   
   print FILE1 "$tmp[$i_tmp]{'rull'};" ;  
   print FILE1 "$tmp[$i_tmp]{'param'};" ;
   print FILE1 "$tmp[$i_tmp]{'file'};" ;
   print FILE1 "$tmp[$i_tmp]{'namecgi'} \n" ;
   
   $i_tmp= $i_tmp + 1;
    
 }
  
 sub   get_user{
   my @param ;  
   my @m_query= split(/&/,shift() );
  
   for (my $elem = 0; $elem < scalar(@m_query) ; $elem++ ){    
	 if ( index($m_query[$elem],"USER=")!= -1 ){
	    @param = split(/=/,$m_query[$elem]);
     } 
   }
   return $param[1] ;
 }
 
 sub get_rull{
  my @param  ; 
  my @m_query= split(/&/,shift() );
   
   for (my $elem = 0; $elem < scalar(@m_query) ; $elem++ ){  
     $m_query[$elem]="&".$m_query[$elem];

	 if ( index($m_query[$elem],"&RULL=")!= -1 ){
	    @param = split(/=/,$m_query[$elem]);
    }	 
   }
   return $param[1] ;
 }
 
 sub   get_param{
   my $res =shift();
   chomp($res);   
   return  $res;
 }
 
 sub get_rull1{ 
	 my @mas_str= split(/&/,shift() );
	 my @get_string;
	 
	 for (my $s=0; $s < scalar(@mas_str) ; $s++ ){
	    $mas_str[$s] ="&".$mas_str[$s] ;
		#print $mas_str[$s]."\n" ;
		
	     if ( index($mas_str[$s],"&RULL=")!= -1 ){
	        @get_string = split(/=/,$mas_str[$s]);
		    #print $mas_str[$s];
			
		    my $b_duble=0;
		    for( my $i =0; $i < scalar(@summ); $i++ ){
		      if (  $get_string[1] eq $summ[$i]->{"rull_"}   ){
			      $summ[$i]->{"count_"} = 1 + $summ[$i]->{"count_"} ; 
				  $b_duble = 1;    				  
			  }			  
	        }
			
			if ($b_duble == 0) {
			push( @summ,
			           {  "rull_" => $get_string[1], 
			              "count_" => '1' 	  
					   }
					 );
			}
			
		 }
     }   
	 return $get_string[0] ."=". $get_string[1];
 };
 
 sub print_summ{
   for( my $i =0; $i<scalar(@summ); $i++ ){   
	       print  txt_consol($summ[$i]->{"rull_"}." = ". $summ[$i]->{"count_"}."\n");
		   print FILE1 ( $summ[$i]->{"rull_"}.";". $summ[$i]->{"count_"}."\n" );		   
		}
 } 

 
sub analys_time(){
 ;
}

sub print_res(){
 for( my $i=0; $i< scalar(@tmp); $i++){
    #print  txt_consol(' '. $tmp[$i]->{"name"}.' '.$tmp[$i]->{"date"}.' '. $tmp[$i]->{"time"}.' '. $tmp[$i]->{"name_rul"}."\n");
  }
}
 
sub analys_date(){;}

sub txt_consol(){
  my $s1 = shift();
  return  Encode::encode('cp866',Encode::decode('cp1251', $s1)) ;
};