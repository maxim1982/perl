#!C:/Perl2/bin/perl
no warnings 'layer';
# ��������� ����������� �������� CGI
use CGI qw( :standard); 
use CGI::Carp qw(fatalsToBrowser);

print "Content-type: text/html\n\n"; 

my @check ;
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
  
   @check = param("check");
   my $index1 = 0;
   
   for( my $t = 0; $t < @check ; $t++ ) {
      $index1 = $check[$t];
	  $index1 =~ s/check//g;
	  
	  #print "<p>$check[$t] : $index1</p>";
	  
      print "<tr style=\"text-align: center;\">";
      print "<td>$metod_rest[$index1]->{'nomer'} </td>";
      print "<td> $metod_rest[$index1]->{'info'} </td>";
      print "<td>$metod_rest[$index1]->{'code'} </td>";
      print "<td> &nbsp; &nbsp; </td>";
      print "<td>$metod_rest[$index1]->{'price'} </td>";
      print "<td> 1 </td>";
      print "<td>$metod_rest[$index1]->{'price'} </td>";
	  print "</tr>\n";	  
	  $symma += $metod_rest[$index1]->{'price'}; 
   }   
   
   &end_table_price();
   
   print "<div style=\"text-align:right ;\">�����:$symma ���.</div>";  
   &end_price(); 
   &end_html();   
}
 else{
   
   &head_html();
   
   print  "\n<form id = \"Sum\" metod =\"post\" action=\"\">";
   &write_checkbox($index);
   #print "<b><output id=\"rezultat\">�����: 0 ���. </output></b> \n";
   
print <<FRM;
   <p><input name = "report"  
   type=\"submit\" value=\"��������� � ��������\" 
   style=\"height:40px;border-width:3px;text-align:center;font-size:20px;\"  ></p>
   </form>
FRM
  #&js_count_price();
}
&ver_show();
&end_html();
#--------------------------------------------------------------------------------------------------------------
sub ver_show{
print  "<small> ������ 1.05 </small>\n<br>";
}
sub write_checkbox(){
  my ( $ind ) = @_;
  
  for ( my $r = 1; $r <= $ind ; $r++ ){
     #print "\n<p> <INPUT type=\"checkbox\" name= \"check\"  id=\"check$metod_rest[$r]->{'id'}\"  value = \"$metod_rest[$r]->{'price'}\" /> $metod_rest[$r]->{'nomer'} $metod_rest[$r]->{'info'} </p>\n";
     print "\n<p> <INPUT type=\"checkbox\" name= \"check\"  value = \"check$metod_rest[$r]->{'id'}\" /> $metod_rest[$r]->{'nomer'} $metod_rest[$r]->{'info'} </p>\n";
    }
}
sub head_html{
print <<HTML;
<html>
<head>
<link id="localcss1" href="/css/price.css" type="text/css" rel="stylesheet" >
<title> ����� ��� �������� ������ ����� </title> 
<h3 style="text-align: center;" >����� ��� �������� ������ �����</h3> 
<h4> �������� ������������ �����, ��������� ������ ������� :</h4>
</head>
<body>
HTML

}
sub js_count_price{
print <<JS;
	<script>
	var s = document.forms.Sum,
		d = s.querySelectorAll('input[type="checkbox"]:not([value]), input[type="checkbox"][value=""]');
	for (var i = 0; i < d.length; i++) // ����� �� ���� �������� NaN, ������� � disabled ������, ��� �� ��������� ��������
		d[i].disabled = true;
	s.onchange = function() { // ������ ������ ������� ��������
	var n = s.querySelectorAll('[type="checkbox"]'),
		itog = 0;
	for(var j=0; j<n.length; j++)
		n[j].checked ? itog += parseFloat(n[j].value) : itog;
		document.getElementById('rezultat').innerHTML = '�����: ' + itog + ' ���. ';
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
<html>
<head>
<link id="localcss1" href="/css/price2.css" type="text/css" rel="stylesheet" >
<title> ����� ��� ������ ����� </title> 
</head>
<body>
<div style="text-align: right;"><b> ���������� �2</b><br> 
� �������� �� ��������<br> 
������� ����������� �����<br>
�_________________<br>
�� �__� _____________ 20__�.<br>
</div>
<br>
<div style="text-align: center;">�������� ���������� ����������� �����.</div>
<br>
HTML1
}

sub table_price{
print <<HTML2;
<table style="text-align: left; width: 100%;" border="1" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td>� �/� </td>
<td> ������������ ����������� ������ </td>
<td>��� ����������� ������</td>
<td>����� �������������� ������	</td>
<td>��������� ����������� ������</td>
<td>����������</td>
<td>�����</td>

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
<div style="text-align: left;"> ������������� </div> <div style="text-align: right;">��������</div>  
<div style="text-align: left;">______________/________________ </div> <div style="text-align: right;"> ______________/________________</div>
<div style="text-align: left;">  &nbsp; &nbsp;  �������  &nbsp; &nbsp; &nbsp; &nbsp;  ��� ������������   </div> <div style="text-align: right;"> ������� </div>
<div style="text-align: left;">  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  ��___________ �______�</div> <div style="text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </div>
</div>
<script>window.parent.print()</script> 
HTML3

}
sub load_price{
   #@metod_rest =();
   $index = 0 ;
	
   my $file_csv ='kvd_price.txt';
   open (FILE2,$file_csv) or die ("������ � ������ � ������ kvd_price.txt: $!");
  
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