#! c:/Perl/bin/perl.exe

print "Content-type: text/html ;charset=windows-1251 \n\n";

require '_stdlib.pl';
require '_db.pl';

&recvquery_get;
 
&start('����� ��������� �������� �� ���� ���');

if(-e  'logs.txt'){ 
  open (INFILE, '>>logs.txt');
  print INFILE strftime("-> %d.%m.%Y,%H:%M:%S ",localtime() )."\n";
}
else { open (INFILE, '>logs.txt');}

print "<form action=\"search_pos.pl\" metod=\"get\" > \n";
print "<fieldset> <legend>��������� ������ :</legend>";

print "<label>����(���������) <br/>� :  <input type= \"text\"  maxlegth=\"10\" size=\"10\" name=\"date1\"  value=\"$userdata{'date1'}\" title =\"���� � ������� : 09\.12.2001\"  >\n" ;
print " �� :  <input type= \"text\"  maxlegth=\"10\" size=\"10\" name=\"date2\"  value=\"$userdata{'date2'}\" title =\"���� � ������� : 09\.12.2003\"  ></label>" ;

print "<label></br>������� :<br/>  <input type= \"text\" size=\"30\" name=\"surname\"  value=\"$userdata{'surname'}\" ></label> " ;
print "<label></br>��� : <br/> <input type= \"text\" size=\"30\" name=\"name\"  value=\"$userdata{'name'}\" ></label>" ;
print "<label></br>�������� : <br/><input type= \"text\" size=\"30\" name=\"name2\"  value=\"$userdata{'name2'}\" ></label>" ;
print "<label></br>���� ����.: <br/><input type= \"text\"  maxlegth=\"10\" size=\"10\" name=\"dr\"  value=\"$userdata{'dr'}\" title =\"���� � ������� : 01\.12.1983\" ></label>" ;

print "<label><input type=\"submit\"  value= \"  �����  \" title = \"����� ������ � �� \"  >";
print "<input type=\"reset\"  value= \" �������� \"></label> </fieldset>";
print "</form> \n";

if( ($userdata{'surname'} ne '') || ($userdata{'name'} ne '') || ($userdata{'name2'} ne '') || ($userdata{'dr'} ne '') )
{ #print "<fieldset> <legend> ���������: </legend>";
  print "<table width=\"100%\" border=\"1\" cellspacing=\"0\" > \n";
  &db_base($userdata{'surname'},$userdata{'name'},$userdata{'name2'},$userdata{'dr'},$userdata{'date1'},$userdata{'date2'} );   
  print "</table> \n";
  #print "</fieldset>";
}
else
{
  print "<h4>������� ������ ��� ������.... </h4>\n";
  &stop;
}
my @s=values(%userdata) ;
my $strinfo =strftime("<- %d.%m.%Y,%H:%M:%S ",localtime() )."\n";  
print INFILE "  : @s \n";
print INFILE $strinfo; 
close(INFILE);
&print_time;

&stop;