#!/usr/bin/perl
# written 2014 by Bernhard M. Wiedemann
# licensed under the terms of the GNU GPL v2 or later
# see the included COPYING file for details
use strict;
use warnings;
# zypper in perl-Alien-SDL perl-SDL

use SDL::Mixer;
use SDL::Mixer::Channels;
use SDL::Mixer::Samples;
use POSIX; # for close
use Time::HiRes qw"gettimeofday usleep sleep";

SDL::Mixer::open_audio( 44100, AUDIO_S16SYS, 2, 4096 );

my %sound=();
for(qw"tick-tack clack dong-end dong-end-deep") {
  $sound{$_} = SDL::Mixer::Samples::load_WAV("$_.wav")
    or die "failed to load $_: $!";
}

sub play($)
{
  my $s = $sound{$_[0]};
  SDL::Mixer::Channels::play_channel(1, $s, 0)
    or die "failed to play $_[0] $s: $!";
}

sub waittosec()
{
  my $t=[gettimeofday()];
  print "@$t\n";
  usleep(($t->[0]&1)*1000000 + 1000000-$t->[1]);
  return $t;
}

sub dong(;$$)
{ my $t=shift||1.9;
  my $deep=shift||"";
  play('dong-end'.$deep); sleep $t;
  waittosec;
}
sub clack()
{
  play('clack');
  sleep 1.9;
}

sub dongs($;$$)
{ my $n=shift;
  my $fullhour=shift||0;
  my $deep=shift;
  for(2..$n) {dong(1.9, $deep)}
  dong($fullhour?5.9:13.9, $deep);
}

sub ticktack()
{
  my $t=waittosec;
  my $sec=$t->[0];
  my $fullhour = $sec % 3600<3;
  if($sec % 60<2) { # every minute
    clack();
    waittosec;
  }
  if($sec % 900<3) { # dong every quarter hour
    my $quarter= 1 + ($sec/900 - 1) % 4;
    dongs($quarter, $fullhour);
  }
  if($fullhour) { # full hour count (UTC)
    my $h = 1 + ($sec/3600 - 1) % 12;
    dongs($h, 0, "-deep")
  }
  play('tick-tack');
  sleep 1.9;
}


# test-code:
#for(1..3) {dong}
#dong(13.9);

# main:
while(1) {
  ticktack;
}

