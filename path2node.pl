#!/usr/bin/perl -w
use strict;
#use List::MoreUtils ':all';

open IN, "$ARGV[0]" or die $!;
my %utig1=();
while(<IN>){
	chomp;
	my @array=split(/\s+/, $_);
	$utig1{$array[0]}=$array[1];
}
close IN;

open IN, "$ARGV[1]" or die $!;
#utig2-0	utig1-73393;utig1-33016;
my %utig2=();
while(<IN>){
	chomp;
	my @array=split(/\s+/, $_);
	$utig2{$array[0]}=$array[1];
}
close IN;

open IN, "$ARGV[2]" or die $!;
#utig3-0 <utig2-1002:0:0
my %utig3=();
while(<IN>){
	chomp;
	my @array=split(/\s+/, $_);
	$utig3{$array[0]}=$array[1];
}
close IN;

open IN, "$ARGV[3]" or die $!;
open OUT, "> $ARGV[4]" or die $!;
my (@ctg, %tig, %ctg, %ctg2, %ctg1)=();
while(<IN>){
	chomp;
	my @array=split(/\s+/, $_);
	$array[1]=~ s/</>/g;
	my @info=split(/>/, $array[1]);
	push(@ctg, $array[0]);
	for (my $i=1; $i < @info; $i++){
		$info[$i]=~ s/:.*//g;
		if($ctg1{$array[0]}){
			$ctg1{$array[0]}=$ctg1{$array[0]}.";".$info[$i];
		}else{
			$ctg1{$array[0]}=$info[$i];
		}
		$info[$i]=~ s/:.*//g;
		if($utig3{$info[$i]}){
			$utig3{$info[$i]}=~ s/</>/g;
			my @info1=split(/>/, $utig3{$info[$i]});
			for (my $j=1; $j < @info1; $j++){
				$info1[$j]=~ s/:.*//g;
				if($ctg2{$array[0]}){
					$ctg2{$array[0]}=$ctg2{$array[0]}.";".$info1[$j];
				}else{$ctg2{$array[0]}=$info1[$j];}
				if($utig2{$info1[$j]}){
					if($ctg{$array[0]}){
						$ctg{$array[0]}=$ctg{$array[0]}.";".$utig2{$info1[$j]};
					}else{
						$ctg{$array[0]}=$utig2{$info1[$j]};
					}
					my @info2=split(/;/, $utig2{$info1[$j]});
					for (my $k=0; $k <@info2; $k++){
						if($utig1{$info2[$k]}){
							if($tig{$array[0]}){
								$tig{$array[0]}=$tig{$array[0]}.";".$utig1{$info2[$k]};
							}else{
								$tig{$array[0]}=$utig1{$info2[$k]};
							}
						}else{print $array[0], "\tutig1\t$info2[$k]\n";}
					}
				}else{
					print $array[0], "\tutig2\t$info1[$j]\n";
				}
			}
		}else{print $array[0], "\tutig3\t$info[$i]\n";}
	}
}
close IN;

for (my $i=0; $i < @ctg; $i++){
	if($tig{$ctg[$i]}){
#		my @all=split(/;/, $tig{$ctg[$i]});
#		my @uniq=uniq(@all);
#		my $uniq=join(";", @uniq);
#		print OUT $ctg[$i], "\t", $uniq, "\n";
		print OUT $ctg[$i], "\t", $ctg1{$ctg[$i]}, "\t",$ctg2{$ctg[$i]},  "\t",$ctg{$ctg[$i]}, "\t", $tig{$ctg[$i]},"\n";
	}else{
		print $ctg[$i], "\n";
	}
}
close OUT;
