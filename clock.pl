#!/usr/bin/perl
# written 2014 by Bernhard M. Wiedemann
# licensed under the terms of the GNU GPL v2 or later
# see the included COPYING file for details
use strict;
use warnings;
# zypper in perl-Alien-SDL perl-SDL

use SDLx::Sound;
use POSIX; # for close
use Time::HiRes qw"gettimeofday usleep sleep";
my $snd = SDLx::Sound->new();

sub play($)
{
  return $snd->play("$_[0].wav");
}

sub waittosec()
{
  my $t=[gettimeofday()];
  print "@$t\n";
  usleep(($t->[0]&1)*1000000 + 1000000-$t->[1]);
  return $t;
}

sub dong(;$)
{ my $t=shift||1.9;
  play('dong-end'); sleep $t;
  waittosec;
}
sub clack()
{
  play('clack');
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
  play('tick-tack');
  sleep 1.9;
}


# test-code:
#for(1..3) {dong}
#dong_end;

# main:
while(1) {
  ticktack;
}

