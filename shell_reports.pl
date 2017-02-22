#!C:/Perl/bin/perl
use File::Copy;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard); 
print "Content-Type: text/html\n\n";
print <<HTML_FORM;
<head>
 <meta charset="utf-8">
<link id="maincss1" href="/css/sv.css" type="text/css" rel="stylesheet" >
<link id="localcss1" href="/css/svlocal.css" type="text/css" rel="stylesheet" >
<script type="text/javascript" src="/js/alib.js">
</script>

</head> <body id="body1" >
HTML_FORM
#-------------------------------загрузка--конфиг-------------------------------------------------
my $file_csv = 'conf_report.csv'; 			   
my @str_name_base =(
         { 
          "ind"=> 0,		  
          "name_string"=> 'Не задано',
		  "name_file"=> '-'
         },
   ); 


my $i=0;			   
open (FILE2,$file_csv) or die ("Ошибка в работе с файлом : Дальнейшая работа НЕ возможна <br/>( $! )");

while (<FILE2>){
   my($count,$name_report,$file_conf)= split(/;/);	
   
   push(@str_name_base,
      { 
         "ind" => $count,		  
         "name_string" => $name_report,
		 "name_file" => $file_conf
      },
   );
   $i=$i+1;
}

close(FILE2);
# ------------------------------вывод информации-----------------------------------------
my $str_result =$str_name_base[0]->{"name_string"};
my $str_open_program = "";
			   
print <<HTML_FORM; 
<div align = "center">
<p class="TITLEFILTERSELECT" >Версия 1.03а <br/>Выберите базу ЕИС ОМС для работы  </p>
<form action=\"\" metod=\"post\" > 
 <div> <span style="text-align:center;font-family:arial;font-size:20px" >Имя базы : </span> 
 <select name="bd"  style="text-align:center;font-family:arial;font-size:20px" >
HTML_FORM
#-----------------------определяем какая БД выбрана -----------------------------------
if ( defined(param("test")) ) {
    for (my $k=0; $k < (scalar(@str_name_base)-1); $k++ ){
	 
	 if ( param("bd") eq $str_name_base[$k]->{"ind"} ) {
	     $str_result= $str_name_base[$k]->{"name_string"}; 
	     my $str= ''.$str_name_base[$k]->{"name_file"};
		 print $str;
		 copy($str, 'webeisrep.ini'); 
		 
	  $str_open_program = "<div class=\"TITLE\" align =\"center\">  <a  href=\"/cgi-bin/webeisrep.exe?dialogstart\"   > Начать работу с $str_result </a> <div>";	 
	 }
	 elsif (param("bd") eq "0"){
	        $str_open_program ="";
	 }
	 
   }
}
else{ 
	   $str_result = $str_name_base[0]->{"name_string"} ; # обнуляем параметр меню
       $str_open_program = "" ;
	}
#------------------Выводим переменные выбора меню-------------------------------------	

for (my $r=0; $r < (scalar(@str_name_base)-1); $r++ ){
        if ( $str_result eq $str_name_base[$r]->{"name_string"} ) {     
		  print "<option selected=\"$str_name_base[$r]->{\"ind\"}\" value=\"$str_name_base[$r]->{\"ind\"}\">$str_name_base[$r]->{\"name_string\"} </option> " ; 
		  }
      	  else{	
		      print "<option value=\"$str_name_base[$r]->{\"ind\"}\">$str_name_base[$r]->{\"name_string\"}</option> " ;
		   }
}

print <<HTML_FORM;	 
</select>
 <input  type="submit"  name="test" value= " Установить Базу" title = " Установить БД ЕИС ОМС "  
 style="-moz-border-radius:15px;-webkit-border-radius: 15px;border-radius: 15px;-o-border-radius: 15px;border-color:#A8D58F;border-width:3px;text-align:center;font-family:arial;font-size:20px;color:black;background-color:#A8D58F;background: -moz-linear-gradient(top,white,#A8D58F);background: -ms-linear-gradient(top,white,#A8D58F);filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='white', endColorstr='#A8D58F');background: -webkit-gradient(linear, left top, left bottom, from(white), to(#A8D58F));background: -o-linear-gradient(top,white,#A8D58F);height:45px">
 </div>
 </form>
</div> 
HTML_FORM

#print "<p class=\"TITLE\">Выбрана : ".$str_result."</p> ";	
print $str_open_program ; 
print '</body></html>';
#-------------------------------------------------------	
	