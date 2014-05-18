if ( $#ARGV < 0 ) {
    print "Usage: perl TinyStat.pl [Interface]\n";
    print "Made by Vypor, http://pastebin.com/u/Autism\n";
    exit;
}

print "Starting TinyStat on $ARGV[0]...\n";
while (1) {
    my $rx = `cat /sys/class/net/$ARGV[0]/statistics/rx_bytes`;
    my $tx = `cat /sys/class/net/$ARGV[0]/statistics/tx_bytes`;
    my $ps = `cat /sys/class/net/$ARGV[0]/statistics/rx_packets`;
    my $po = `cat /sys/class/net/$ARGV[0]/statistics/tx_packets`;

    sleep 1;

    my $ps2 = `cat /sys/class/net/$ARGV[0]/statistics/rx_packets`;
    my $po2 = `cat /sys/class/net/$ARGV[0]/statistics/tx_packets`;
    my $rx1 = `cat /sys/class/net/$ARGV[0]/statistics/rx_bytes`;
    my $tx1 = `cat /sys/class/net/$ARGV[0]/statistics/tx_bytes`;

    my $tb     = $tx1 - $tx;
    my $rb     = $rx1 - $rx;
    my $ppsin  = $po2 - $po;
    my $ppsout = $ps2 - $ps;
    my $kbs    = $rb / 1024;
    my $rbs    = $tb / 1024;

    if ( $rbs >= 1024 and $kbs >= 1024 ) {
        my $mbs  = $kbs / 1024;
        my $rmbs = $rbs / 1024;
        printf "\e[37mIN: \e[32;1m%0.2f\e[0m \e[37mMB\e[0m",           $mbs;
        printf " \e[37m| \e[37mOUT: \e[32;1m%0.2f\e[0m \e[37mMB\e[0m", $rmbs;

    }
    elsif ( $rbs >= 1024 ) {

        my $rmbs = $rbs / 1024;
        printf "\e[37mIN: \e[32m%0.2f\e[0m \e[37mKB\e[0m",             $kbs;
        printf " \e[37m| \e[37mOUT: \e[32;1m%0.2f\e[0m \e[37mMB\e[0m", $rmbs;

    }
    elsif ( $kbs >= 1024 ) {

        my $mbs = $kbs / 1024;

        printf "\e[37mIN: \e[32;1m%0.2f\e[0m \e[37mMB\e[0m",         $mbs;
        printf " \e[37m| \e[37mOUT: \e[32m%0.2f\e[0m \e[37mKB\e[0m", $rbs;

    }
    else {
        printf "\e[37mIN: \e[32m%0.2f\e[0m \e[37mKB\e[0m",           $kbs;
        printf " \e[37m| \e[37mOUT: \e[32m%0.2f\e[0m \e[37mKB\e[0m", $rbs;
    }

    printf " \e[37m| \e[37mPPS_OUT: \e[32m%0.2f\e[0m \e[37mPPS\e[0m",    $ppsin;
    printf " \e[37m| \e[37mPPS_IN: \e[32m%0.2f\e[0m \e[37mPPS\n\e[0m", $ppsout;
}
