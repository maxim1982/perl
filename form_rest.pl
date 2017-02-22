#!C:/Perl2/bin/perl
#use SOAP  ;
#use strict ;
use warnings;

use CGI qw/:all/; # ��������� ����������� �������� CGI
	
my $file_csv ='rest_query.csv';
open (FILE2,$file_csv) or die ("������ � ������ � ������ rest_query.csv : $!");

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
	
print                              # ������� � �������� �����
 header(-charset=>'windows-1251'), # � ��������� CP1251:
 start_html(-title=>'����� ��� ������ � REST-��������' ,
            -style=>{'src'=>'../css/sv.css'},       # ����� ��� ���������
			),             # ����� ��������,
 h4('������� ��������� �������:'),# ���������, 
 start_form,                               # �����, � ���
    "URL � REST: http://",                                 # �������,
    textfield(-name=>'url_rest', size=>55),    # ���� �����,
    
	popup_menu('menu_name',
			   [@m],
			    'info_test'), 
	
  
	submit('���������'),                  # ������,
 end_form,                                 # ����� ����� 
 hr, "\n";  # � �������������� �����
 

 # ����� ���������, ���� �� �������� ������ �����
if (param) { # ���� �������� ������ - ��������� �����
   print                                 # �������: 
    " �����: ",
    param('url_rest'),
	' - ',                      # � ���, � ����� 
    param('menu_name'), # ����������� 
    hr,"\n";                   # � �������������� �����
}
print end_html;                # ��������� ����� ��������