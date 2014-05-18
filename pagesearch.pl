#made by Vypor
#11:40 AM
#4/6/2014
#Made for the request of: TheMuddFamily
#161rum.com

use HTML::Parser;
use LWP::UserAgent;
use LWP::Simple;
use Parallel::ForkManager;
use Term::ANSIColor;
use vars qw( $PROG );
( $PROG = $0 ) =~ s/^.*[\/\\]//;

if ( @ARGV == 0 ) {
        print "[!] Usage: ./$PROG [IPLIST] [THREADS] [OUTPUT] [STRING] [PATH] [TIMEOUT] \n[!] Example: ./$PROG ips.txt 100 output.txt \"This page has this text!\" pathlist 10\nPath list must be in format: \page.php\nMade by Vypor\nhttp://pastebin.com/u/Autism\n";
    exit;
}

$SIG{'INT'} = sub {exit;};
my $stringsearch = $ARGV[3];
my $filename = $ARGV[2];
my $max_processes = $ARGV[1];
my $pm = Parallel::ForkManager->new($max_processes);
		my $weblist = $ARGV[0];
			open my $handle, '<', $weblist;
			chomp(my @webservers = <$handle>);
			close $handle;
		my $paths = $ARGV[4];
			open my $handle2, '<', $paths;
			chomp(my @pages = <$handle2>);
			close $handle2;

print "\e[33m[!] Starting\n\e[0m";
print "\e[33m[!] Using input list: $ARGV[0] | Output list: $filename\n\e[0m";
print "\e[33m[!] Using $ARGV[1] Fork's\n\e[0m";
print "\e[33m[!] Using Vypor's Wordpress Scanner 161rum.com\n\e[0m";
sleep("3");

for my $strat (@webservers) {
foreach (@pages) {
	my $pid - $pm->start and next;
	alarm("$ARGV[5]");

		my $url = "http://$strat" . "$_";
		my $ua = LWP::UserAgent->new;
			print "\e[96m[!]Searching \e[31m$url\n\e[0m";		
		my $response = $ua->get($url);
		if ( !$response->is_success ) {
		}
		if (head($url)) {
	
		my $parser = HTML::Parser->new( 'text_h' => [ \&text_handler, 'dtext' ] );
		$parser->parse( $response->decoded_content );
		sub text_handler {
    		chomp( my $text = shift );
			
    		if ( $text =~ /$stringsearch/i ) {
				open (FILE, ">>$filename");
				print FILE "$url\n";                                
                                close (FILE);
				print "\e[96m[+]Found: \e[32m$url\e[0m\n";
		}
		
	}
	} else {
}
$pm->finish;
}
}
