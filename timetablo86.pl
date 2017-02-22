# информационное табло... на Perl
#!/usr/bin/perl -w
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard);

print "Content-Type: text/html; charset=windows-1251\n\n";
 
 #print "<HTML><HEAD> <TITLE> Информационное Табло </TITLE></HEAD> <BODY> \n";
 
  my $dbplan=DBI->connect('dbi:ODBC:tablo86','','') ; 
 
 open(FILE_IND, 'index.txt' ) or die ("Ошибка $!");
 $ind=<FILE_IND>;   
# print "! $ind !";
 close(FILE_IND);

 #----------------------------------------------------------------------
 if($dbplan){
       $SQLtxt1="SELECT count(ind) FROM tablo86 ";
                                                 
       $res1 = $dbplan->prepare($SQLtxt1); 
       $res1 -> execute() ;
       $count_max= $res1->fetchrow_array();
       $res1->finish(); 
 }
  
  #----------------------------------------------------------------------
 if($ind>$count_max){$ind=1;}
 
#---------------------------------------------------------------------
 $i_ind=0;

 if($dbplan){
       $SQLtxt1="SELECT * FROM tablo86 WHERE ind=\'$ind\'  ";
                                                 
       $res1 = $dbplan->prepare($SQLtxt1); 
       $res1 -> execute() ;
    
     if ($res1->err){
         print"<BR> ОШИБКА" . $res1->errstr. "\n";
    }
     else {
            while (my  @row = $res1->fetchrow_array() ){
                  
               #print " ",$row[0]," ",$row[1]," ",$row[2]," med= ",$row[3]," ",$row[4]," ",$row[5]," ",$row[6]," <BR>\n";
               $d1=$row[1] ;
               $d2=$row[2] ;
               $d3=$row[3] ;
               $d4=$row[4] ;
               $d5=$row[5] ;

               $t1=$row[6] ;
               $t2=$row[7] ;
               $t3=$row[8] ;
               $t4=$row[9] ;
               $t5=$row[10] ;
               
               $name_doc=$row[11] ;
               $name_spec=$row[12] ;
               $prim=$row[16];

               if ($row[13]>0){                  $name_spec
= $name_spec
."     \.Участок ".$row[13];                   
               }

               
               $name_uch=$row[13] ;
               $kab=$row[14] ;
               $adr=$row[15] ;
     
           }  
      }              
      $res1->finish();      
   }
else{
    print "<BR>Не подключиться к БД!. $DBI::errstr";
}

$dbplan->disconnect();

if($adr ne ""){
    $file_info="tablo86A.htm";
}
else{
      $file_info="tablo86.htm"; 
}

open (L, $file_info); 

while ($line1=<L>) { 
   chomp($line1); 
   if ($line1=~/\@med\@/) { 
      $line ="<font size=\"7\">".$name_doc."</font>" ;
      print "$line";    
  } 
  elsif($line1=~/\@spec\@/){
       if($name_uch==0){
          $line ="<font size=\"7\"> Специалист    -   ".$name_spec."</font>" ;
      }
      else{ $line ="<font size=\"7\"> ".$name_spec."</font>" ;} 
      print "$line";    
  }
  elsif($line1=~/\@kab\@/){
      $line ="<font size=\"7\">".$kab."</font>" ; 
      print "$line";    
  }
  elsif($line1=~/\@time1\@/){
      $line ="<font size=\"7\">".$t1."</font>" ; 
      print "$line";    
  }

  elsif($line1=~/\@time2\@/){
      $line ="<font size=\"7\">".$t2."</font>" ; 
      print "$line";    
  }

  elsif($line1=~/\@time3\@/){
      $line ="<font size=\"7\">".$t3."</font>" ; 
      print "$line";    
  }

  elsif($line1=~/\@time4\@/){
      $line ="<font size=\"7\">".$t4."</font>" ; 
      print "$line";    
  }

  elsif($line1=~/\@time5\@/){
      $line ="<font size=\"7\">".$t5."</font>" ; 
      print "$line";    
  }

  elsif($line1=~/\@day5\@/){
      $line ="<font size=\"7\">".$d5."</font>" ; 
      print "$line";    
  }


  elsif($line1=~/\@day1\@/){
      $line ="<font size=\"7\">".$d1."</font>" ; 
      print "$line";    
  }


  elsif($line1=~/\@day2\@/){
      $line ="<font size=\"7\">".$d2."</font>" ; 
      print "$line";    
  }


  elsif($line1=~/\@day3\@/){
      $line ="<font size=\"7\">".$d3."</font>" ; 
      print "$line";    
  }


  elsif($line1=~/\@day4\@/){
      $line ="<font size=\"7\">".$d4."</font>" ; 
      print "$line";    
  }

  elsif($line1=~/\@prim\@/){
      $line ="<font size=\"6\">".$prim."</font>" ; 
      print "$line";    
  }

    elsif($line1=~/\@adr\@/){
      $line ="<font size=\"6\">".$adr."</font>" ; 
      print "$line";    
  }

  else{ 
       print "$line1\n";
    } 
 } 
 close(L);
 
 ++$ind;
 open(FILE_IND, '>index.txt' ) or die ("Ошибка $!");
 print FILE_IND $ind ;   
 #print "! $ind !";
 close(FILE_IND);


#print "</BODY></HTML>\n";