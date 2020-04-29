#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::RunValgrind ();

if ( $^O eq "MSWin32" )
{
    plan skip_all => 'valgrind is not available on Windows';
}
plan tests => 7;

my $obj = Test::RunValgrind->new( {} );

# TEST
$obj->run(
    {
        log_fn => './fortune--1.valgrind-log',
        prog   => './fortune',
        argv   => [qw//],
        blurb  => 'fortune valgrind test',
    }
);

# TEST
$obj->run(
    {
        log_fn => './fortune--2-dash-f.valgrind-log',
        prog   => './fortune',
        argv   => [qw/-f/],
        blurb  => 'fortune -f valgrind test',
    }
);

# TEST
$obj->run(
    {
        log_fn => './fortune--3-dash-m.valgrind-log',
        prog   => './fortune',
        argv   => [qw/-m foobarbazINGAMINGATONGALKIYRE/],
        blurb  => 'fortune -m valgrind test',
    }
);

# TEST
$obj->run(
    {
        log_fn => './fortune--4-dash-m-i.valgrind-log',
        prog   => './fortune',
        argv   => [qw/-i -m foobarbazINGAMINGATONGALKIYRE/],
        blurb  => 'fortune -i -m valgrind test',
    }
);

# TEST*3
foreach my $prog (qw/ strfile unstr randstr /)
{
    $obj->run(
        {
            log_fn => "./fortune--$prog-buffer-overflow.valgrind-log",
            prog   => "./$prog",
            argv   => [
                ( ( $prog eq "randstr" ) ? ("filler") : () ),
                scalar( "AAAAAAAAAAAAAAAA/" x 1000 )
            ],
            blurb => "$prog buffer overflow test",
        }
    );
}
