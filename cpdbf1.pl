use Fcntl;

my $name_dbf = $ARGV[0];
my $codepage = $ARGV[1];

print "Utils for rewrite code page for dbf (e-mail: maxim_7\@mail.ru)\n";
print "USE: cpdbf1.exe <dbf-file> <codepage> \n";
chomp($name_dbf);
chomp($codepage);

#sysopen (Fl, "sendreq.dbf" , O_RDWR) or die("ERROR $!");
sysopen (Fl, $name_dbf , O_RDWR) or die("ERROR $!");

$read = sysread (Fl, $string, 29);
$position = sysseek(Fl, 0, 1) or die "err pos : $!\n"; 

#$string = chr('38');
$string = chr($codepage);

$written = syswrite (Fl, $string, 2) or die "err write : $!\n" ;
close Fl or die $!;

print "complite file - $name_dbf \n" ;