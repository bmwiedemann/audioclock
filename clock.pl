#!/usr/bin/perl
use strict;
use warnings;
# zypper in perl-Alien-SDL perl-SDL

use SDLx::Sound;
use POSIX; # for close
use Time::HiRes qw"gettimeofday usleep sleep";
my $snd = SDLx::Sound->new();

sub waittosec()
{
  my $t=[gettimeofday()];
  print "@$t\n";
  usleep(1000000-$t->[1]);
  return $t;
}

sub dong(;$)
{ my $t=shift||1.9;
  $snd->play('dong-end.wav'); sleep $t;
  waittosec;
}
sub clack()
{
  $snd->play('clack.wav');
  sleep 1.9;
}

sub dong_end() {dong(13.9)}

sub dongs($)
{ my $n=shift;
  for(2..$n) {dong}
  dong_end;
}

sub ticktack()
{
  my $t=waittosec;
  my $sec=$t->[0];
  if($sec % 60<2) { # every minute
    clack();
    waittosec;
  }
  if($sec % 900<3) { # dong every quarter hour
    my $quarter= 1 + ($sec/900 - 1) % 4;
    dongs($quarter);
  }
  if($sec % 3600<3) { # full hour count (UTC)
    my $h = 1 + ($sec/3600 - 1) % 12;
    dongs($h)
  }
  for(4..32) { POSIX::close($_); }
  $snd->play('tick-tack.wav');
  sleep 1.9;
}


# test-code:
#for(1..3) {dong}
#dong_end;

# main:
while(1) {
  ticktack;
}

