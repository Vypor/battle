#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket;
use threads;
use threads::shared;

if ( $#ARGV != 1 ) {
    print "Usage: <Ip list> <port> <threads> <outputfile>\n";
    print
"Remember to ulimit -n your server above your threads (ulimit -n 100000\n";
    exit;
}
my $count : shared = 0;
my $array          = $ARGV[0];
my $port           = $ARGV[1];
our $MAX //= $ARGV[2];
my $output     = $ARGV[3];
my $totallines = `cat $array | wc -l`;
my @threads;

open my $handle, '<', $array;
chomp( my @array = <$handle> );
close $handle;

for my $ip (@array) {

    push @threads, async {

        my $socket = IO::Socket::INET->new(
            PeerAddr => $ip,
            PeerPort => $port,
            Proto    => 'tcp',
        ) or print "";

        system("clear");
        print "$count/$totallines\n\r";
        open( LOGFILE, ">>$output" );
        my $recv_line = <$socket>;
        print LOGFILE "$ip $recv_line\n";
        close(LOGFILE);
        lock $count;
        $count++;
    };
    sleep 1 while threads->list(threads::running) > $MAX;
}
$_->join for @threads;
