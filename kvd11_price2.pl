#!C:/Perl2/bin/perl
no warnings 'layer';
# применяем стандартные средства CGI
use CGI qw( :standard); 
use strict;
use CGI::Carp qw(fatalsToBrowser);

print "Content-type: text/html\n\n"; 

#my @check ;
my $symma = 0;

my @metod_rest =();

my @metod_rest = (
		{
		"id" => "0",		
		"nomer" => "0",
		"code" => "code_test", 
		"info" => "info_test", 
		"price" => "0",
        "flag" => "0"		
		},
	);
	
my $index=0;
my $flag = 0;

#-----------------------------------------------------------------------------------------------
 &load_price();
if(defined(param("report"))){
   &load_price();
   
   &head_price_html();
   &table_price();
   my $index1 = 0;
   
# предыдущий вариант:   
#   @check = param("check");
   
#   for( my $t = 0; $t < @check ; $t++ ) {
#      $index1 = $check[$t];
#	  $index1 =~ s/check//g;	  
#	  #print "<p>$check[$t] : $index1</p>";
	  
#      print "<tr style=\"text-align: center;\">";
#      print "<td>$metod_rest[$index1]->{'nomer'} </td>";
#      print "<td> $metod_rest[$index1]->{'info'} </td>";
#      print "<td>$metod_rest[$index1]->{'code'} </td>";
#      print "<td> &nbsp; &nbsp; </td>";
#      print "<td>$metod_rest[$index1]->{'price'} </td>";
#      print "<td> 1 </td>";
#      print "<td>$metod_rest[$index1]->{'price'} </td>";
#	   print "</tr>\n";	  
#	  $symma += $metod_rest[$index1]->{'price'}; 
#   }   
   my $count=0;
   my $symma_uslugi =0;
   for( my $t = 1; $t <= $index ; $t++ ) {
       if ( param("num$t") != '0')
	   {  
	      $count = param("num$t");
          #print "<p> num$t  : $t - $tmp </p>";
		    
		  print "<tr style=\"text-align: left;\">";
          print "<td>$metod_rest[$t]->{'nomer'} </td>";
          print "<td> $metod_rest[$t]->{'info'} </td>";
          print "<td>$metod_rest[$t]->{'code'} </td>";
          print "<td> &nbsp; &nbsp; </td>";
          print "<td style=\"text-align: center;\">$metod_rest[$t]->{'price'} </td>";
          print "<td style=\"text-align: center;\"> $count </td>";
		  $symma_uslugi = $metod_rest[$t]->{'price'}*$count;
          print "<td style=\"text-align: center;\"> $symma_uslugi </td>";
          print "</tr>\n";	  
          $symma += $metod_rest[$t]->{'price'}*$count; 
		  
	   }
   }
   
   &end_table_price();
   
   print "<div style=\"text-align:right ;\">Итого:$symma руб.</div>";  
   &end_price(); 
   &end_html();   
}
 else{   
   &head_html();
   
   print<<HEAD_TAB;
  <form metod="GET">
  <table style="width: 98%;" border="1" cellpadding="5" cellspacing="0" >
  <th>Кратность</th> <th>Код услуги</th><th>Наименование услуги</th><th>Стоимость (Руб.)</th>
  <tr>
HEAD_TAB

   &load_data_uslugi($index);
   
   print <<FRM;
   </table>
   <p><input name = "report"  
   type="submit" value="Расчитать_и_Печатать" 
   style="height:40px;border-width:3px;text-align:center;font-size:20px;"  ></p>
   </form>
FRM

}
&ver_show();
&end_html();
#--------------------------------------------------------------------------------------------------------------
sub ver_show{
print  "<small> версия 1.06(GET) </small>\n<br>";
}
sub load_data_uslugi(){
  my ( $ind ) = @_;
  
  for ( my $r = 1; $r <= $ind ; $r++ ){
     #предыдущий вариант: 
	 #print "\n<tr><td style=\"width: 7%;\"> <INPUT type=\"checkbox\" name= \"check\"  value = \"check$metod_rest[$r]->{'id'}\" /> $metod_rest[$r]->{'nomer'}  </td> <td> $metod_rest[$r]->{'info'} </td></tr>\n";
     
	 print "<tr><td style=\"width: 10%;\">";
	 print"<input name = \"down$metod_rest[$r]->{'id'}\" type=button onClick=\"addone_all(-1,$metod_rest[$r]->{'id'});\" value=\"-\" />\n";
     
	 print"<input id=\"$metod_rest[$r]->{'id'}\" type=\"text\" name=\"num$metod_rest[$r]->{'id'}\" size =\"3\" maxlength=\"3\" readonly value=\"0\" />\n";
     
	 print"<input name = \"up$metod_rest[$r]->{'id'}\" type=button onClick=\"addone_all(1,$metod_rest[$r]->{'id'});\" value=\"+\" />\n";
	 print "</td> <td  style=\"width: 10%;\"> $metod_rest[$r]->{'code'} </td> <td> $metod_rest[$r]->{'info'} </td> <td style=\"text-align: center;\"> $metod_rest[$r]->{'price'} </td>  </tr>\n\n";
	 
	 }
  	 
}
sub head_html{
print <<HTML;
<!DOCTYPE html>
<html>
<head>
<link id="localcss1" href="/css/price.css" type="text/css" rel="stylesheet" >
<title> Форма для создания прайса услуг </title> 
<h3 style="text-align: center;" >Форма для создания прайса услуг</h3> 
<h4> Выберите наименование услуг,поставив кратность :</h4>

<script type="text/javascript"> 
    function addone_all(i,param) { 
        ta2=document.getElementById(""+param); 
        ta2.value=parseInt(ta2.value)+i; 
        if (parseInt(ta2.value) <= 0) { ta2.value=0; } 
    } 
</script>

</head>
<body>
HTML

}
sub js_count_price{
print <<JS;
	<script>
	var s = document.forms.Sum,
		d = s.querySelectorAll('input[type="checkbox"]:not([value]), input[type="checkbox"][value=""]');
	for (var i = 0; i < d.length; i++) // чтобы не было написано NaN, убираем в disabled пункты, где не прописаны значения
		d[i].disabled = true;
	s.onchange = function() { // начало работы функции сложения
	var n = s.querySelectorAll('[type="checkbox"]'),
		itog = 0;
	for(var j=0; j<n.length; j++)
		n[j].checked ? itog += parseFloat(n[j].value) : itog;
		document.getElementById('rezultat').innerHTML = 'Сумма: ' + itog + ' руб. ';
	}
	</script>
JS

}
sub end_html
{
  print "</body>\n</html>\n";
  exit(0);
}

sub head_price_html{
print <<HTML1;
<!DOCTYPE html>
<html>
<head>
<link id="localcss1" type="text/css" rel="stylesheet" >
<title> Форма для прайса услуг </title> 
</head>
<body>
<div style="text-align: right;"><b> Приложение №2</b><br> 
к Договору на оказание<br> 
платных медицинских услуг<br>
№_________________<br>
от «__» _____________ 20__г.<br>
</div>
<br>
<div style="text-align: center;">Перечень возмездных медицинских услуг.</div>
<br>
HTML1
}

sub table_price{
print <<HTML2;
<table style="width: 100%;" border="1" cellpadding="0" cellspacing="0">
<tbody>
<tr style="text-align: center;">
<td>№ п/п </td>
<td> Наименование медицинской услуги </td>
<td>Код медицинской услуги</td>
<td>Сроки предоставления услуги	</td>
<td>Стоимость медицинской услуги</td>
<td>Количество</td>
<td>Сумма</td>

</tr>
<tr style="text-align: center;">
<td>1 </td>
<td>2 </td>
<td>3</td>
<td>4</td>
<td>5</td>
<td>6</td>
<td>7</td>
</tr>

HTML2
}

sub end_table_price{
print "</tr> </tbody></table>";
}
sub end_price{
print <<HTML3;
<div>
<div style="text-align: left;"> «Исполнитель» </div> <div style="text-align: right;">«Пациент»</div>  
<div style="text-align: left;">______________/________________ </div> <div style="text-align: right;"> ______________/________________</div>
<div style="text-align: left;">  &nbsp; &nbsp;  подпись  &nbsp; &nbsp; &nbsp; &nbsp;  «По доверенности   </div> <div style="text-align: right;"> подпись </div>
<div style="text-align: left;">  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  от___________ №______»</div> <div style="text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </div>
</div>
<script>window.parent.print()</script> 
HTML3

}
sub load_price{
   #@metod_rest =();
   $index = 0 ;
	
   my $file_csv ='kvd_price.txt';
   open (FILE2,$file_csv) or die ("Ошибка в работе с файлом kvd_price.txt: $!");
  
   while (<FILE2>)
	{
	 my($id,$nomer,$code,$info,$price)= split(/;/);	     	 
     push( @metod_rest,
		{    
		    "id" => $id,
			"nomer" => $nomer,
			"code" => $code, 
			"info" => $info, 
			"price" => $price,
			"flag" => $flag
		}
	 );
	 $index += 1; 	 
    }
	#print "index = $index ";
   close(FILE2);

}