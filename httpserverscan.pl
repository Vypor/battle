#!/usr/bin/perl
use Net::IP;
use LWP::UserAgent;
use vars qw( $PROG );
( $PROG = $0 ) =~ s/^.*[\/\\]//;
#Usage
if ( @ARGV == 0 ) {
        print "Usage: ./$PROG [START-IP] [END-IP] [THREADS] [TIMEOUT] [OUTPUT]\n";
    exit;
}

my $threads  = $ARGV[2];
my @ip_team  = ();
$|= 1;
my $ip   = new Net::IP ("$ARGV[0] - $ARGV[1]") or die "Invaild IP Range.". Net::IP::Error() ."\n";

print "[!]Starting with $threads threads\n[!]Scanning $ARGV[0] to $ARGV[1]\n";
while ($ip) {
push @ip_team, $ip++ ->ip();
if ( $threads == @ip_team ) { Scan(@ip_team); @ip_team = () }
}
Scan(@ip_team);


sub Scan
{
my @Pids;
        foreach my $ip (@_)
        {
        my $pid        = fork();
        die "Could not fork! $!\n" unless defined $pid;

                if  (0 == $pid)
                {
my $ua = LWP::UserAgent->new;
$ua->timeout($ARGV[3]);
 
my $response = $ua->get("http://$ip");

if ($response->is_success) {
	print "Found one $ip!\n";
	open (MYFILE, ">>$ARGV[4]");
	print MYFILE "$ip\n";
	close (MYFILE);
}
else {
    die "[-] No Webserver Found!";
}
                exit
                }
                else
                {
                push @Pids, $pid
                }
        }

foreach my $pid (@Pids) { waitpid($pid, 0) }
}
