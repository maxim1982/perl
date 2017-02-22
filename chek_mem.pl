
use warnings;
use strict;
use POSIX;
use Win32::OLE;

my $size =1024*1024;
my $name_disk="d:";

my $fs = Win32::OLE->CreateObject('Scripting.FileSystemObject');
my $d = $fs->GetDrive($name_disk);

print  floor($d->{TotalSize}/$size), " total\n";
print  floor($d->{FreeSpace}/$size), " free\n";
print  floor($d->{AvailableSpace}/$size), " available\n";
print  floor($d->{TotalSize}/$size - $d->{FreeSpace}/$size)." used\n";

sleep(8);