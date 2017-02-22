# информационное табло... на Perl
#!/usr/bin/perl -w
use DBI;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard);

$str_nom=0;
$save_put=0;
$del_but=0;

$save_put=param("save_put");
$str_nom=param("Button");
$add_but=param("Button");
$del_but=param("DelStr");

 print "Content-Type: text/html; charset=windows-1251\n\n";
 
 my $dbplan=DBI->connect('dbi:ODBC:tablo86','','') ; 
#------------------------------------------------------------------------------------------------------
if($save_put>0){
   $save_d1=param("D1");
   $save_d2=param("D2");
   $save_d3=param("D3");
   $save_d4=param("D4");
   $save_d5=param("D5");
  
   $save_t1=param("T1");
   $save_t2=param("T2");
   $save_t3=param("T3");
   $save_t4=param("T4");
   $save_t5=param("T5");

   $save_doc=param("DOC");
   $save_sp=param("SPEC");
   $save_uch=param("UCH");
   $save_kab=param("KAB");

   $save_prim=param("PRIM");

   $SQLtxt2 = "update tablo86 set day1='$save_d1',day2='$save_d2',day3='$save_d3',day4='$save_d4',day5='$save_d5' ,time1='$save_t1' ,time2='$save_t2' ,time3='$save_t3' ,time4='$save_t4',time5='$save_t5' ,doctor='$save_doc' ,spec='$save_sp' ,uch='$save_uch' ,kab='$save_kab' ,prim='$save_prim' where ind='$save_put' ";                              
   
   $res2 = $dbplan->prepare($SQLtxt2); 
   $res2 -> execute() ;                        
   $res2->finish();              
}
#------------------------------------------------------------------------------------------------------
   if($add_but eq "add_but"){
   	$SQLtxt4 = "select ind from tablo86 ";                              
                $i_max=0;
                 
   	$res4 = $dbplan->prepare($SQLtxt4); 
   	$res4 -> execute() ;
                
                while (my  $ind = $res4->fetchrow_array() ){       	
                if ( $ind > i_max ) {
                      $i_max=$ind;
                     }
                }
                $res4->finish();  
   	++$i_max;                
#--------------------------------------------------   
   	$SQLtxt3 = "insert into tablo86 (ind ,day1,day2,day3,day4,day5,time1,time2,time3,time4,time5,doctor,spec,uch,kab,prim )  values ('$i_max','Пн\.','Вт\.','Ср\.','Чт\.','Пт\.' ,'00\.00-00\.00' ,'00\.00-00\.00' ,'00\.00-00\.00' ,'00\.00-00\.00','00\.00-00\.00' ,'?' ,'?' ,'0' ,'0' ,'?') ";                              
   
   	$res3 = $dbplan->prepare($SQLtxt3); 
   	$res3 -> execute() ;
                             
   	$res3->finish();             
#------------------------------------------------------------------------------------------------------
   }
#------------------------------------------------------------------------------------------------------
#if (defined($del_but) ){
                         
      #$SQLtxt5 = "update tablo set ind='-1' where ind='$del_but' ";
#        $SQLtxt5 = "delete from tablo86 where ind='$del_but' ";

#      $res5 = $dbplan->prepare($SQLtxt5); 
#      $res5->execute() ;
 
 #     if ($res5->err){
 #        print"<BR> ОШИБКА 5" . $res5->errstr. "\n";
 #   }
    
 #    $res5->finish();
 #   print " del str  = $del_but \n";              
#}
               
#------------------------------------------------------------------------------------------------------ 
print "<BODY bgcolor=\"#FFFFFF\" text=\"#0000FF\" >";
 
 $name_but="";
  
if ($str_nom==0) { 
  print "<center>\n <p><font size=\"6\">Просмотр Расписания П86\. </font></p> \n";
}
else{
    print "<center>\n <p><font size=\"6\">Редактирование Расписания П86\. </font></p></center> \n";
}

 print " версия программы 1\.0022\n"; 

 print "<table width=\"100%\" border=\"1\" cellspacing=\"1\"> \n";
 print " <tr><td>№</td><td>день1</td><td>день2</td><td>день3 </td><td>день4</td><td>день5 </td><td>время1 </td><td>время2</td><td>время3</td><td>время4 </td><td>время5 </td><td>Врач </td><td>Спец </td><td> Уч\.</td><td>Каб.\</td><td>Прим </td><td>Действие</td></tr> \n";
 
 #----------------------------------------------------------------------
 if($dbplan){
       $SQLtxt1="SELECT * FROM tablo86 ";
                                                 
       $res1 = $dbplan->prepare($SQLtxt1); 
       $res1 -> execute() ;

       $nom_button=0;

     if ($res1->err){
         print"<BR> ОШИБКА" . $res1->errstr. "\n";
    }
     else {
            while (my  @row = $res1->fetchrow_array() ){
               print "<FORM id=\"form1\" method=\"POST\">\n";
               #print "<FORM>\n";              
               $nom_button=$nom_button+1;
                
               if ($str_nom==$nom_button && $save_put==0){
                  $name_but="Сохр\.";
                  print  "<INPUT TYPE=\"hidden\" name=\"save_put\" value=\"$nom_button\" > </td>\n";
                  
                print " <tr><td>",$row[0],"</td>\n";
                print        "<td><INPUT ID=\"D1\" TYPE=\"text\" NAME=\"D1\" SIZE=\"3\" VALUE=\"",$row[1],"\" style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"D2\" TYPE=\"text\" NAME=\"D2\" SIZE=\"3\" VALUE=\"",$row[2],"\" style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"D3\" TYPE=\"text\" NAME=\"D3\" SIZE=\"3\" VALUE=\"",$row[3],"\" style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"D4\" TYPE=\"text\" NAME=\"D4\" SIZE=\"3\" VALUE=\"",$row[4],"\" style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"D5\" TYPE=\"text\" NAME=\"D5\" SIZE=\"3\" VALUE=\"",$row[5],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	print       "<td> <INPUT ID=\"T1\" TYPE=\"text\" NAME=\"T1\" SIZE=\"30\" VALUE=\"",$row[6],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"T2\" TYPE=\"text\" NAME=\"T2\" SIZE=\"30\" VALUE=\"",$row[7],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"T3\" TYPE=\"text\" NAME=\"T3\" SIZE=\"30\" VALUE=\"",$row[8],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"T4\" TYPE=\"text\" NAME=\"T4\" SIZE=\"30\" VALUE=\"",$row[9],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"T5\" TYPE=\"text\" NAME=\"T5\" SIZE=\"30\" VALUE=\"",$row[10],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"DOC\" TYPE=\"text\" NAME=\"DOC\" SIZE=\"25\" VALUE=\"",$row[11],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"SPEC\" TYPE=\"text\" NAME=\"SPEC\" SIZE=\"25\" VALUE=\"",$row[12],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"UCH\" TYPE=\"text\" NAME=\"UCH\" SIZE=\"4\" VALUE=\"",$row[13],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	print        "<td> <INPUT ID=\"KAB\" TYPE=\"text\" NAME=\"KAB\" SIZE=\"10\" VALUE=\"",$row[14],"\"style=\"font-size:large\" SIZE=5> </td>\n";
               	#print       "<td>&nbsp",$row[15]," </td>\n";
               	print       "<td>&nbsp <INPUT ID=\"PRIM\" TYPE=\"text\" NAME=\"PRIM\" SIZE=\"15\" VALUE=\"",$row[16],"\"style=\"font-size:large\" SIZE=5></td>\n";   
   
               	}
               else{
                $name_but="Измен\.";

                print " <tr><td>&nbsp<h4>",$row[0],"</td>\n";
                print        "<td>&nbsp<h4>",$row[1]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[2]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[3]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[4]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[5]," </td>\n";
               	print       "<td>&nbsp<h4>",$row[6]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[7]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[8]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[9]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[10]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[11]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[12]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[13]," </td>\n";
               	print        "<td>&nbsp<h4>",$row[14]," </td>\n";
              # print       "<td>&nbsp<h4>",$row[15]," </td>\n";
               	print       "<td>&nbsp<h4>",$row[16]," </td>\n";
 
               }

               print   "<td><INPUT TYPE=\"submit\" NAME=\"COMMAND\"  VALUE=\"$name_but\" ></td>\n";
               print  "<INPUT TYPE=\"hidden\" name=\"Button\" value=\"$nom_button\" > </td>\n";
               print "</FORM>\n";
               
               print "<FORM id=\"form1\" method=\"POST\">\n";
               #print "<FORM>\n";              
                
               #print   "<td><INPUT TYPE=\"submit\" NAME=\"COMMAND\"  VALUE=\"Удал\.\" ></td>\n";
               #print  "<INPUT TYPE=\"hidden\" name=\"DelStr\" value=\"$nom_button\" > </td>\n";
               #print "</FORM>\n";               

               print    "</tr> \n";
          }  
      }              
      $res1->finish();
       print "</table> \n";
       
       print "<BR><FORM id=\"form1\" method=\"POST\">"; 
       print  "<INPUT TYPE=\"hidden\" name=\"Button\" value=\"add_but\" > ";      
       print   "<INPUT TYPE=\"submit\" NAME=\"COMMAND1\"  VALUE=\" Добавить  запись [в конец таблицы]\" >";
       print "</FORM>";
     }
else{
    print "<BR>Не подключиться к БД!. $DBI::errstr";
}

$dbplan->disconnect();
print " </BODY></HTML>\n";
#---------------------------