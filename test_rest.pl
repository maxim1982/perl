#!C:/Perl2/bin/perl
#use CGI::Carp qw(fatalsToBrowser);
use CGI qw( :standard); 
no warnings 'layer';

print "Content-Type: text/html\n\n";

print <<HTML;
<meta charset=\"utf-8\">
<link id="maincss1" href="/css/sv.css" type="text/css" rel="stylesheet" >
<link id="localcss1" href="/css/svlocal.css" type="text/css" rel="stylesheet" >

<style type="text/css">
/* наша HTML таблица */
table.sort{
border-spacing:0.1em;
margin-bottom:1em;
margin-top:1em
}

/* ячейки таблицы */
table.sort td{
border:1px solid #CCCCCC;
padding:0.3em 1em
}

/* заголовки таблицы */
table.sort thead td{
cursor:pointer;
cursor:hand;
font-weight:bold;
text-align:center;
vertical-align:middle
}

/* заголовок отсортированного столбца */
table.sort thead td.curcol{
background-color:#999999;
color:#FFFFFF
}
</style>

	
<script type="text/javascript">
<!--

//var img_dir = "/i/"; // папка с картинками
var sort_case_sensitive = false; // вид сортировки (регистрозависимый или нет)

// ф-ция, определяющая алгоритм сортировки
function _sort(a, b) {
    var a = a[0];
    var b = b[0];
    var _a = (a + '').replace(/,/, '.');
    var _b = (b + '').replace(/,/, '.');
    if (parseFloat(_a) && parseFloat(_b)) return sort_numbers(parseFloat(_a), parseFloat(_b));
    else if (!sort_case_sensitive) return sort_insensitive(a, b);
    else return sort_sensitive(a, b);
}

// ф-ция сортировки чисел
function sort_numbers(a, b) {
    return a - b;
}

// ф-ция регистронезависимой сортировки
function sort_insensitive(a, b) {
    var anew = a.toLowerCase();
    var bnew = b.toLowerCase();
    if (anew < bnew) return -1;
    if (anew > bnew) return 1;
    return 0;
}

// ф-ция регистрозависимой сортировки
function sort_sensitive(a, b) {
    if (a < b) return -1;
    if (a > b) return 1;
    return 0;
}

// вспомогательная ф-ция, выдирающая из дочерних узлов весь текст
function getConcatenedTextContent(node) {
    var _result = "";
    if (node == null) {
        return _result;
    }
    var childrens = node.childNodes;
    var i = 0;
    while (i < childrens.length) {
        var child = childrens.item(i);
        switch (child.nodeType) {
            case 1: // ELEMENT_NODE
            case 5: // ENTITY_REFERENCE_NODE
                _result += getConcatenedTextContent(child);
                break;
            case 3: // TEXT_NODE
            case 2: // ATTRIBUTE_NODE
            case 4: // CDATA_SECTION_NODE
                _result += child.nodeValue;
                break;
            case 6: // ENTITY_NODE
            case 7: // PROCESSING_INSTRUCTION_NODE
            case 8: // COMMENT_NODE
            case 9: // DOCUMENT_NODE
            case 10: // DOCUMENT_TYPE_NODE
            case 11: // DOCUMENT_FRAGMENT_NODE
            case 12: // NOTATION_NODE
            // skip
            break;
        }
        i++;
    }
    return _result;
}

// суть скрипта
function sort(e) {
    var el = window.event ? window.event.srcElement : e.currentTarget;
    while (el.tagName.toLowerCase() != "td") el = el.parentNode;
    var a = new Array();
    var name = el.lastChild.nodeValue;
    var dad = el.parentNode;
    var table = dad.parentNode.parentNode;
    var up = table.up;
    var node, arrow, curcol;
    for (var i = 0; (node = dad.getElementsByTagName("td").item(i)); i++) {
        if (node.lastChild.nodeValue == name){
            curcol = i;
            if (node.className == "curcol"){
                arrow = node.firstChild;
                table.up = Number(!up);
            }else{
                node.className = "curcol";
                arrow = node.insertBefore(document.createElement("img"),node.firstChild);
                table.up = 0;
            }
            //arrow.src = img_dir + table.up + ".gif";
            arrow.alt = "";
        }else{
            if (node.className == "curcol"){
                node.className = "";
                if (node.firstChild) node.removeChild(node.firstChild);
            }
        }
    }
    var tbody = table.getElementsByTagName("tbody").item(0);
    for (var i = 0; (node = tbody.getElementsByTagName("tr").item(i)); i++) {
        a[i] = new Array();
        a[i][0] = getConcatenedTextContent(node.getElementsByTagName("td").item(curcol));
        a[i][1] = getConcatenedTextContent(node.getElementsByTagName("td").item(1));
        a[i][2] = getConcatenedTextContent(node.getElementsByTagName("td").item(0));
        a[i][3] = node;
    }
    a.sort(_sort);
    if (table.up) a.reverse();
    for (var i = 0; i < a.length; i++) {
        tbody.appendChild(a[i][3]);
    }
}

// ф-ция инициализации всего процесса
function init(e) {
    if (!document.getElementsByTagName) return;

    for (var j = 0; (thead = document.getElementsByTagName("thead").item(j)); j++) {
        var node;
        for (var i = 0; (node = thead.getElementsByTagName("td").item(i)); i++) {
            if (node.addEventListener) node.addEventListener("click", sort, false);
            else if (node.attachEvent) node.attachEvent("onclick", sort);
            node.title = "Нажмите на заголовок, чтобы отсортировать колонку";
        }
        thead.parentNode.up = 0;
        
        if (typeof(initial_sort_id) != "undefined"){
            td_for_event = thead.getElementsByTagName("td").item(initial_sort_id);
            if (document.createEvent){
                var evt = document.createEvent("MouseEvents");
                evt.initMouseEvent("click", false, false, window, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, td_for_event);
                td_for_event.dispatchEvent(evt);
            } else if (td_for_event.fireEvent) td_for_event.fireEvent("onclick");
            if (typeof(initial_sort_up) != "undefined" && initial_sort_up){
                if (td_for_event.dispatchEvent) td_for_event.dispatchEvent(evt);
                else if (td_for_event.fireEvent) td_for_event.fireEvent("onclick");
            }
        }
    }
}

// запускаем ф-цию init() при возникновении события load
var root = window.addEventListener || window.attachEvent ? window : document.addEventListener ? document : null;
if (root){
    if (root.addEventListener) root.addEventListener("load", init, false);
    else if (root.attachEvent) root.attachEvent("onload", init);
}
//-->
</script>

  <script>
   function loadPage() {
    document.getElementById('status').style.display = 'none';
	document.getElementById('tabl').style.display = 'block';
   }
  </script>

HTML

use LWP::Simple ;
use Encode;
#use XML::Bare;

print <<HTML;
<body onload="loadPage()" > 
<p class="TITLEFILTERSELECT" > Проверка версии REST-сервиса в ЛПУ. Версия 1.07.6  </p>

<form action="" metod="post" > 
 <div style="font-family:arial;font-size:20px" >Тест на версию REST-сервиса :  <input style="font-family:arial;font-size:20px" type= "text"  maxlegth="10" size="10" name="ver"  value="3.320" title ="проверить версию REST-сервиса"  ></div> 
 <div style="font-family:arial;font-size:20px">Выгрузить результат в файл log.csv <input type="checkbox" name="load_f" ></div>
 <div><input type="submit"  name ="test" value= "  Запуск теста  " title = " Запуск теста версии REST-сервиса "  
 style="-moz-border-radius:15px;-webkit-border-radius: 15px;border-radius: 15px;-o-border-radius: 15px;border-color:#A8D58F;border-width:3px;text-align:center;font-family:arial;font-size:20px;color:black;background-color:#A8D58F;background: -moz-linear-gradient(top,white,#A8D58F);background: -ms-linear-gradient(top,white,#A8D58F);filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='white', endColorstr='#A8D58F');background: -webkit-gradient(linear, left top, left bottom, from(white), to(#A8D58F));background: -o-linear-gradient(top,white,#A8D58F);height:45px">
 </div>
 </form> 
 
 <div id="status"  style="text-align:center">
<img src="/images/snake.gif"/>
</div>

 <div>
 <table>
 <tr><td> Варианты ответов : </td></tr>
 <tr>
 <td  bgcolor="aqua"> Нет доступа к сервису </td>
 </tr>
  <tr>
 <td  > Версия соответствует </td>
 </tr>
 <tr>
 <td  bgcolor="orange"> Версия Не соответствует </td>
 </tr>
 </table>
 </div> 
 <div></div>
 

<table id="tabl" class="sort" align="left"  border ="0">
<thead> <tr> <td>N</td> <td>Район</td><td>Название_поликлиники</td> <td>Ответ<br/>от REST-сервиса</td><td> Адрес_ЕМТС </td> <td> Время_запроса </td></tr> </thead> <tbody> 
 

HTML


if (defined(param("test"))) {

	@mTime= localtime(time()); # определяем системное время
	$start_script = "<p align=\"right\" > Время начала : ".$mTime[2].":".$mTime[1].":".$mTime[0]." , ".$mTime[3]."/".($mTime[4]+1)."/".($mTime[5]+1900)."  </p>" ;
	#-------------------------------------------------------	
	my $file_csv = 'orgs.csv'; #'orgs_my.csv';
	open (FILE2,$file_csv) or die ("ошибка в работе с файлом orgs_csv : $!");
	#-------------------------------------------------------	
	my @lpu_rest = (
		{ 
		"name" => "test",
		"info" => "test", 
		"url" => "test", 
		"area" => "test",
		"show" => "+"	 
		},
	);
	#-------------------------------------------------------	
	my $i=0; # кол-во rest-запросов 
	while (<FILE2>)
	{
		my $url ="";
		my $lpu ="";
		my $area ="";
		my $show="";
	
		($lpu,$url,$area,$show)= split(/;/);	     
		push( @lpu_rest,
			{ "name" => $lpu,
			"info" => "", 
			"url" => $url, 
			"area" => $area,
			"show" => $show  		  
			}
		);
	
		$i=$i+1;
	}
	close(FILE2);  
	@mTime= localtime(time()); # определяем системное время
	$load_file = "<p align=\"right\" > Обработан файл ORGS.csv : ".$mTime[2].":".$mTime[1].":".$mTime[0]." , ".$mTime[3]."/".($mTime[4]+1)."/".($mTime[5]+1900)."  </p>" ;
	#-------------------------------------------------------
	my $path_log = $ENV{'DOCUMENT_ROOT'}.'log.csv';
	open (FILE1,'>'.$path_log) or die ("ошибка в работе с файлом log_csv : $!");
	print FILE1 "N;Lpu;Information Rest;URL Rest;Area \n";;  
	#-------------------------------------------------------  
	my $i_err=0; # ошибки
    my $old_ver=0; # старые версии	
	my $nom_ver='/GETVERSION';
	my $nom=0; # счетчик 
	my $red_status="";
	my $write_resault="";
	my $ver ="";
    #-------------------------------------------------------	
	#print '<table class="sort" align="left"  border ="1">';
	#print '<thead> <tr> <td>N</td> <td>Район</td><td>Название_поликлиники</td> <td>Информация <br/>от REST-сервиса</td><td> Адрес_ЕМТС </td> <td> Время_запроса </td></tr> </thead> <tbody> '; 

	for (my $k=1;$k<=$i; $k++ ){
	  if ( $lpu_rest[$k]->{"show"} eq '+' ){  
		my $res=get($lpu_rest[$k]->{"url"}.$nom_ver);
	
		if ( defined($res) ) 
			{  $ver= decode_char($res) ; 
				$lpu_rest[$k]->{"info"} =ParsXML1($ver);	
			}
		else { $lpu_rest[$k]->{"info"} =decode('cp1251','no data'); 
				$i_err++; }
	    #------------------------------------------------ 
		
		$red_status= "" ; # Обнуляем статус и проверяем его
		
		if ( $lpu_rest[$k]->{"info"}  ne 'no data'){ # исключаем ЛПУ из не отвеченных...  
		
		   if ( param("ver") ne $lpu_rest[$k]->{"info"} ){ # и не та версия - красным подчеркиваем 
			  $old_ver= $old_ver+1;	
			  $red_status= " bgcolor=\"orange\" "  ;
			}
        }
		else {
		      $red_status= " bgcolor=\"aqua\" " ; # не отвеченная ЛПУ - синим
		}
		
		
		$nom=$nom+1;
	    @mTime= localtime(time()); # определяем системное время
		$time_post = "".$mTime[2].":".$mTime[1].":".$mTime[0] ; 
        
		$write_resault=" <tr".$red_status."><td> $nom </td><td>$lpu_rest[$k]->{\"area\"} </td><td> $lpu_rest[$k]->{\"name\"} </td><td> $lpu_rest[$k]->{\"info\"} </td><td> $lpu_rest[$k]->{\"url\"} </td><td> $time_post </td> </tr>" ;
		print "".decode('cp1251',$write_resault );
	    
		 if ( param("load_f") eq 'on' ){ 
		   $str1=" $nom ; $lpu_rest[$k]->{\"name\"} ; $lpu_rest[$k]->{\"info\"} ; $lpu_rest[$k]->{\"url\"} ; $lpu_rest[$k]->{\"area\"} \n";
		   print FILE1 $str1;
		 }
		 
	   }
	}
  
	close(FILE1); 
	print "</tbody></table><br/>";
	
	#-------------------------------------------------------	
	print "<p>Нет ответа от ЛПУ:".$i_err ."</p>";
	print "<p>Других версий в ЛПУ:".$old_ver ."</p>";
	print "<p>Опрошено ЛПУ(Всего):".$nom."</p>";
	#print "<div>Всего модулей :".$i."</div>";
	
	 if ( param("load_f") eq 'on' ){ 
	    my $log='http://'.$ENV{'SERVER_ADDR'}.':'.$ENV{'SERVER_PORT'}.'/log.csv'; 
  	    print "<p><a href=\"$log\" >Скачать результат работы </a> ( файл лежит $path_log ) </p>";
	}
	#-------------------------------------------------------	
	@mTime= localtime(time()); # определяем системное время
	$end_script = "<p align=\"right\"> Время окончания : ".$mTime[2].":".$mTime[1].":".$mTime[0]." , ".$mTime[3]."/".($mTime[4]+1)."/".($mTime[5]+1900)."  </p>" ;
	print  $start_script;
	print  $load_file;
	print  $end_script;
}
print '</body></html>';
#-------------------------------------------------------	 
# sub ParsXML1($){
#   my ($xml_data)=@_;   
#   my $obj = XML::Bare->new(text => $xml_data );
#   my $tree = $obj->parse;
#   return $tree->{'XML'}->{'GETVERSION'}->{'VERSION'}->{'value'};
#}

sub ParsXML1($){
   my ($xml_data)=@_;
   $xml_data =~ s/<XML>//g;
   $xml_data =~ s/<GETVERSION>//g;
   $xml_data =~ s/<VERSION>//g;
   
   $xml_data =~ s/<\/XML>//g;
   $xml_data =~ s/<\/GETVERSION>//g;
   $xml_data =~ s/<\/VERSION>//g;
   
   $xml_data =~ s/<RESULT>//g;
   $xml_data =~ s/<\/RESULT>//g;
   
   $xml_data =~ s/\n//g;
   $xml_data =~ s/\r//g;
   
   return $xml_data;
}

 sub decode_char
{
  my $string = shift(@_);
  $string =~ s/\+/ /g;
  $string =~ s/%([0-9A-F]{2})/pack('C',hex($1))/eg;
  return $string ;  
}