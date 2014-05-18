#!/usr/bin/perl
use strict;
use warnings;
use Net::IP;
use IO::Socket;
use Term::ANSIColor;
use vars qw( $PROG );
( $PROG = $0 ) =~ s/^.*[\/\\]//;

#Usage
if ( @ARGV == 0 ) {
    print
"Usage: ./$PROG [START-IP] [END-IP] [PORT] [THREADS] [TIMEOUT] [OUTPUT]\n";
    exit;
}
my $threads = $ARGV[3];
my @ip_team = ();
$| = 1;
my $ip = new Net::IP("$ARGV[0] - $ARGV[1]")
  or die "Invaild IP Range." . Net::IP::Error() . "\n";

#Start Forking :D
while ($ip) {
    push @ip_team, $ip++ ->ip();
    if ( $threads == @ip_team ) { Scan(@ip_team); @ip_team = () }
}
Scan(@ip_team);

#Scan
sub Scan {
    my @Pids;

    foreach my $ip (@_) {
        my $pid = fork();
        die "Could not fork! $!\n" unless defined $pid;

        if ( 0 == $pid ) {

            #Open socket, save to list, print out open ports
            my $socket = IO::Socket::INET->new(
                PeerAddr => $ip,
                PeerPort => $ARGV[2],
                Proto    => 'tcp',
                Timeout  => $ARGV[4]
            );
            print color 'bold blue';
            print "port is open on $ip!\n" if $socket;
            print color 'reset';
            open( MYFILE, ">>$ARGV[5]" );
            print MYFILE "$ip\n" if $socket;
            close(MYFILE);
            exit;
        }
        else {
            push @Pids, $pid;
        }
    }

    foreach my $pid (@Pids) { waitpid( $pid, 0 ) }
}
