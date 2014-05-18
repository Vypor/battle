#made by Vypor
#2:35 AM
#4/6/2014
#Made for the request of: Matt
#161rum.com
use HTML::Parser;
use LWP::UserAgent;
use LWP::Simple;
use Parallel::ForkManager;
use Term::ANSIColor;
use vars qw( $PROG );
( $PROG = $0 ) =~ s/^.*[\/\\]//;

if ( @ARGV == 0 ) {
        print "[!] Usage: ./$PROG [IPLIST] [THREADS] [OUTPUT] [TIMEOUT]\n[!] Example: ./$PROG ips.txt 100 output.txt 10\nMade by Vypor\nhttp://pastebin.com/u/Autism\n";
    exit;
}
$SIG{'INT'} = sub {exit;};
my @folders = ("/wordpress/", "/wp/", "blog", "/");
my $stringsearch = "XML-RPC";
my $filename = $ARGV[2];
my $max_processes = $ARGV[1];
my $pm = Parallel::ForkManager->new($max_processes);
my $weblist = $ARGV[0];
open my $handle, '<', $weblist;
chomp(my @webservers = <$handle>);
close $handle;

print "\e[33m[!] Starting\n\e[0m";
print "\e[33m[!] Using input list: $ARGV[0] | Output list: $filename\n\e[0m";
print "\e[33m[!] Using $ARGV[1] Fork's\n\e[0m";
print "\e[33m[!] Using Vypor's Wordpress Scanner 161rum.com\n\e[0m";
sleep("3");

for my $strat (@webservers) {
foreach (@folders) {

	my $pid - $pm->start and next;
	alarm("$ARGV[3]");

		my $url = "http://$strat" . "$_" . "xmlrpc.php";
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

        my $ui = $url;
        $ui =~ s/xmlrpc.php/?feed=rss2/;
        if (head($ui)) {
                sub check {
                        $LOLGETIT=get($ui);
                        $LOLGETIT =~ /<item>.+?<link>(.+?)<\/link>.+?<\/item>/s;
                        if ($1) {
                                open (FILE, ">>$filename");
				my $post = $1;
				$ui =~ s{\Q?feed=rss2\E}{xmlrpc.php};
				print FILE "$ui $post\n";                                
                                close (FILE);
				print "\e[96m[+]Found: \e[32m$ui $post\e[0m\n";
                                exec($^X, "-e", "sleep 1,kill(0,$pid)||kill -9,$pid");
                        }
                }
                check();
        } else {
        }		}	
	}
	} else {
}
$pm->finish;
}
}
