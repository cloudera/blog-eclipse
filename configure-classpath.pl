#!/bin/perl

# usage: perl configure-classpath.pl 

$cmd = `mv .classpath .tmp_classpath`;
open IN, ".tmp_classpath";
open OUT, ">.classpath";

$copied = 0;
while(<IN>) {
    $orig_line = $_;
    if ( (index($orig_line, "src/core") != -1)
	 || (index($orig_line, "src/hdfs") != -1)) {
	next;
    }

    if (index($orig_line, "build/ivy/lib/Hadoop/common") == -1) {
        print OUT $orig_line;
        next;
    }

    if ($copied == 1) {
	next;
    }
    
    open(FIND_LIBS, "find build/ivy/lib/Hadoop -name *.jar | sort -n | ");
    while (<FIND_LIBS>) {
	chomp($_);
	$path = $_;
	if ($path ne "") {
	    print OUT "\t<classpathentry kind=\"lib\" path=\"$path\"/>"."\n";
	}
    }
    close FIND_LIBS;


    $copied = 1;
}
close IN;
close OUT;
