use strict;
use warnings;
use encoding 'cp1251';
use Encode;

#-----------------------------------------
my $path_in="d:/cart/in/";
#-----------------------------------------


my(@file,@dir,$file_name );
chdir($path_in);
opendir(DIR0,$path_in) or die ("error $!");

foreach(readdir(DIR0)){
  $file_name=$path_in.$_;
  if (-d $file_name){
    push(@dir,$_);
  }
}
closedir(DIR0);

for(my $i=0; $i < @dir ; $i++) {
   my $path_in_1 =$path_in.$dir[$i]."/";
   print "open: $path_in_1 \n" ;
   sleep(2);
   chdir($dir[$i]);
   opendir(DIR1,$path_in_1) or die ("error $!"); 
    
  	
  my @infile = glob($path_in_1."*.htm");
  for(my $k=0; $k <@infile; $k++) {
    print "$k:$infile[$k] \n" ;
	
	open(file1,$infile[$k]) or die "Error open file - $!";
	my $str="";
	{
	  local $/="";
	  $str=<file1>;
	}
	close (file1);
    open(file2,">:encoding(cp866)",$infile[$k]) or die("error file $!");
    
	   $str = decode('cp1251',$str);
        print file2 $str; 
	
    close (file2);
  }
   
  closedir(DIR1);
  	  
}

