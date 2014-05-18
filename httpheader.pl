use Parallel::ForkManager;
use URI::Title qw( title );

use vars qw( $PROG );
( $PROG = $0 ) =~ s/^.*[\/\\]//;

#Usage
if ( @ARGV == 0 ) {
    print
"Usage: ./$PROG [IPLIST] [THREADS] [OUTPUT]\nExample: ./$PROG ips.txt 10 ips.output\nMade by Vypor\n";
    exit;
}

my $max_processes = $ARGV[1];
my $pm            = Parallel::ForkManager->new($max_processes);
my $filename      = $ARGV[2];

my $weblist = $ARGV[0];
open my $handle, '<', $weblist;
chomp( my @webservers = <$handle> );
close $handle;

for my $webservers (@webservers) {
    my $pid = $pm->start and next;

    my $title = title("http://$webservers");
    print "$webservers $title\n";
    open( MYFILE, ">>$filename" );
    print MYFILE "$webservers $title\n";
    close(MYFILE);
    $pm->finish;
}
$pm->wait_all_children;
