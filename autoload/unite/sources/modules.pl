#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

my $version = $];

my %mods;
my %opts;

Getopt::Long::GetOptions(\%opts, qw( core inst all ));

if (@ARGV > 1) {
    die "Invalid arguments: @ARGV";
}

if ($opts{core}) {
    %mods = &core;
} elsif ($opts{inst}) {
    %mods = &inst;
} elsif ($opts{all}) {
    %mods = &core;
    my %inst_mod = &inst;
    for my $key (sort keys %inst_mod) {
        $mods{$key} = $inst_mod{$key};
    }
}

for my $mod (sort keys %mods) {
    print $mod . "\n";
}


use Module::CoreList;
sub core {
    my $modules = $Module::CoreList::version{$version};
    return %$modules;
}

use ExtUtils::Installed;
sub inst {
    my %modules;
    my $inst = ExtUtils::Installed->new();
    for my $core_mod ($inst->modules()) {
        $modules{$core_mod} = $inst->version($core_mod);
    }
    return %modules;
}
