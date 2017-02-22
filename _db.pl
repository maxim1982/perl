use DBI;
use Encode;
use POSIX;

sub db_base{
my $Surname  = shift(@_);
my $Name1  = shift(@_);
my $Name2 = shift(@_);
my $dr    = shift(@_);

my $date1= shift(@_);
my $date2= shift(@_);

if ( $date1 ne "" ){
 @tmp=split(/\./,$date1);
 $date1="'".$tmp[0]."-".$tmp[1]."-".$tmp[2]."'";
}
else 
{
  $date1="'01-01-1990'";
  print " Даты взяты от $date1 "; 
}

if ( $date2 ne "" ){
 @tmp=split(/\./,$date2);
 $date2="'".$tmp[0]."-".$tmp[1]."-".$tmp[2]."'";
}
else {$date2="'01-01-2090'";
print " по $date2 \n <br>"; 
}

my $dopparm="";
if ( $dr ne "" ){
    @tmp=split(/\./,$dr);
 $dr="'".$tmp[0]."-".$tmp[1]."-".$tmp[2]."'";
 $dopparm="AND st.DR=$dr " ;
}
open (LOGS, '>>log_err.txt');
print "<tr><td> № </td><td> Ф И О ПАЦИЕНТА</td><td>ДАТА РОЖД.</td><td> АДРЕС </td><td>ДИАГНОЗ</td><td>ВРАЧ</td><td>ПОСЕЩ.</td><td>МЕСТО</td><td> СТРАХ.ПОЛИС </td><tr> \n";
   $n=0;
my $db=DBI->connect('DBI:ODBC:sv_stat','sa','svKICHn00') ;
          if($db){
                  $SQLTXT= " SELECT st.fam,st.name,st.name2,st.dr,st.street,st.house,st.korp,st.flat,st.dz,med.doctor,gosop.date_go, typego.place, st.smo,st.smo_ser,st.smo_Nom FROM med,typego,gosop join stattal st on gosop.ID=st.ID WHERE gosop.id_med=med.code AND gosop.id_place=typego.code AND st.fam like '$Surname%' AND st.NAME like '$Name1%' AND st.NAME2 like '$Name2%' ".$dopparm." AND gosop.[DATE_GO] >= $date1 AND gosop.[DATE_GO] <= $date2 ";
                                     # SELECT SURNAME,NAME1,NAME2,BIRTHDAY,STREET,HOUSE,KORP,KV,DIAG,VISIT.IDMED,VISIT.VDATE,VISIT.MESTO,TALON.SMO,TALON.SPOL,TALON.NPOL FROM VISIT,TALON WHERE VISIT.ID=TALON.ID AND SURNAME like '$Surname%' AND NAME1 like '$Name1%' AND NAME2 like '$Name2%' ".$dopparm." AND VISIT.VDATE >= $date1 AND VISIT.VDATE <= $date2 " ; 
       
                    my $res1 = $db->prepare($SQLTXT);
                    $res1 -> execute() ;
                    #print $SQLTXT."<br>\n";
                   if (!$res1->err){
                         while(my @row = $res1->fetchrow_array()){
                                  $n=$n+1;

								$row[3]=~s/00:00:00.000//g ;
								 my @tmp=split(/\-/,$row[3]);
								 chop($tmp[2]);
                                 $row[3]=$tmp[2]."\.".$tmp[1]."\.".$tmp[0];
								
								 $row[10]=~s/00:00:00.000//g ;
								 @tmp=split(/\-/,$row[10]);
								 chop($tmp[2]);
                                 $row[10]=$tmp[2]."\.".$tmp[1]."\.".$tmp[0];
								 
			                	 print encode('cp1251',"<tr><td> $n </td><td> $row[0] $row[1] $row[2] </td><td> $row[3] </td><td> $row[4] ,$row[5] , $row[6] KB $row[7] </td><td> $row[8] </td><td> $row[9]</td><td> $row[10]</td><td> $row[11] </td><td>$row[12] $row[13] $row[14]</td> </tr> \n"); 
                        }
                 }
                 $res1->finish();
          }
           else{
               print "<BR>Не подключиться к базе SQL . $DBI::errstr";
			   print LOGS strftime(" %d.%m.%Y,%H:%M:%S ",localtime() )." : ";
			   print LOGS "Ошибка . $DBI::errstr \n";
			       }
        $db->disconnect();
		close (LOGS);
}		
	
sub print_time
{
print strftime("<center>  Отчёт создан. дата :%d.%m.%Y , время :%H:%M:%S </center>",localtime() );
print "<br><small> Версия программы: 2\.05\.1 <br>(Автор Лютов М.А. e-mail: maxim_7\@mail.ru);</small>";
}
return 1;