
sub start
{
  my $title= shift(@_);
  $title ='Не известный документ ' if(!($title));
  print "<!DOCTYPE html PUBLIC \"-/\/W3C\//DTD XHTML 1\.0 Transitional//EN\"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"> \n\n";
  print "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"ru\" xml:lang=\"ru\"> \n\n";
  
  #print "<html>\n\n";
  print "<head>\n";
  print "<title>$title</title> \n";
  #print "<meta http-equiv=\"CONTENT-TYPE\" content=\"text/html; charset=windows-1251\">";
  print "</head>\n\n";
  print "<body>\n"; 
 # print "<h5>$title</h5> \n";
}

sub stop
{
  print "</body>\n";
  print "</html>\n";
  exit(0);
}

sub recvquery_get
{
  my $query = $ENV{'QUERY_STRING'};
  if($query ne ''){ &parse_query($query) ;}  
}

sub recvquery_post
{
  my $query ="";
  my $content_length = $ENV{'CONTENT_LENGTH'}; 
  if ($contenth_lenth)
  {
    my $buf;
    while (sysread(STDIN,$buf,1024))
	{
	  $query .=$buf; 
	}	
  }
  if ($query ne '')
  {
    &parse_query($query);
  }
}

sub parse_query
{
  my $string = shift(@_);
  my @query = split('&',$string);
  
  foreach $element(@query)
  {
    my @fields = split('=',$element);
     $fields[0]= decode1($fields[0]);
     $fields[1]= decode1($fields[1]);
     $userdata{$fields[0]}=$fields[1];

  }
  
}

sub decode1
{
  my $string = shift(@_);
  $string =~ s/\+/ /g;
  $string =~ s/%([0-9A-F]{2})/pack('C',hex($1))/eg;
  return $string ;  
}


return 1;