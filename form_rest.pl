#!C:/Perl2/bin/perl
#use SOAP  ;
#use strict ;
use warnings;

use CGI qw/:all/; # применяем стандартные средства CGI
	
my $file_csv ='rest_query.csv';
open (FILE2,$file_csv) or die ("ошибка в работе с файлом rest_query.csv : $!");

	my @metod_rest = (
		{ 
		"nomer" => "0",
		"info" => "info_test", 
		"metod" => "metod_test", 
		"row" => "0" 
		},
	);
	
my @m;

while (<FILE2>)
	{
	 my($nomer,$info,$metod,$row)= split(/;/);	     
	 push( @metod_rest,
		{ 
			"nomer" => $nomer,
			"info" => $info, 
			"metod" => $metod, 
			"row" => $row  		  
		}
	 );
	$m[@m]=$metod;#$info;
}
close(FILE2);
	
print                              # выводим в выходной поток
 header(-charset=>'windows-1251'), # в кодировке CP1251:
 start_html(-title=>'Форма для работы с REST-сервисом' ,
            -style=>{'src'=>'../css/sv.css'},       # Стиль для документа
			),             # шапку страницы,
 h4('Введите параметры запроса:'),# заголовок, 
 start_form,                               # форму, в ней
    "URL к REST: http://",                                 # надпись,
    textfield(-name=>'url_rest', size=>55),    # поле ввода,
    
	popup_menu('menu_name',
			   [@m],
			    'info_test'), 
	
  
	submit('Отправить'),                  # кнопку,
 end_form,                                 # конец формы 
 hr, "\n";  # и горизонтальную черту
 

 # далее проверяем, были ли присланы данные формы
if (param) { # если присланы данные - параметры формы
   print                                 # выводим: 
    " пишем: ",
    param('url_rest'),
	' - ',                      # и имя, а также 
    param('menu_name'), # комментарий 
    hr,"\n";                   # и горизонтальную черту
}
print end_html;                # оформляем конец страницы