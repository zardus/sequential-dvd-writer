#!/usr/bin/perl
use strict;

sub whiptail
{
	my $arg = shift @_;
	my $blankok = shift @_;

	system("dialog $arg 2> /tmp/dvdwrite");
	open(RESULT, "/tmp/dvdwrite");
	my $new = <RESULT>;
	close RESULT;

	exit if (!defined $blankok && $new eq "");

	return $new;
}

sub browsedir
{
	my $startdir = shift @_;
	my $dir = shift @_;
	my $stop = shift @_;
	my $title = shift @_;
	my $type = shift @_;

	if ($type eq "")
	{
		$type = "-type d"
	}
	else
	{
		$type = ""
	}

	my $cmdline = "find \"$dir\" -follow -maxdepth 1 $type -printf \"%P\n\" | sort";

	my @dirs = `$cmdline`;
	chomp @dirs;
	shift @dirs;
	unshift (@dirs, "..") if ($dir ne $startdir);
	unshift (@dirs, $stop) if ($stop ne "");

	$title = "Please choose directory to burn. Current is:\n$dir" if ($title eq "");

	$cmdline = "--title \"Directory Selection\" --menu \"$title\" 0 0 0 ";

	foreach my $d (@dirs) { $cmdline .= "\"$d\" \"\" "; }

	my $new = whiptail($cmdline, 1);

	if ($new eq "..")
	{
		$dir = `dirname "$dir"`;
		chomp $dir;
	}
	elsif ($new eq "") { $dir = ""; }
	elsif ($new eq $stop) { $dir = $stop; }
	else  { $dir .= "/$new"; }

	return $dir;
}
