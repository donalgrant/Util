#!/usr/bin/perl -w -I/Users/imel/Desktop/Dropbox/dev/lib

use Util::Msg;
use Data::Dumper;

# check level-setting function

msg_set_lvl(2);
msg_set_opt qw( MSG_NUMBERS TAG_MULTILINE TIME_TAGS TAG_NUMBERS );

msg "Hello, World - 1", 1;
msg "Hello, World - 2", 2;
msg "Hello, World - 3", 3;
msg "Hello, World - 0";

msg_clr_lvl;
msg "Hello, World - 3", 3;

# check filtering

msg_only_tags qw(WARN FAIL);

msg "Note message";
msg "WARN message", 'WARN';
msg "warn message", 'warn';
msg "fail message", 'fail';
msg "FAIL message", 'FAIL';

msg_hide_tags qw(WARN);

msg "Another WARN Message", 'WARN';
msg "Another FAIL Message", 'FAIL';

msg_all_tags;
msg_tag_default('#');  

msg "Last WARN Message", 'WARN';
msg "final note", 'NOTE';

my %T = msg_tag_counts;
msg Dumper(\%T);

msg_set_wrap(35);
msg "And this is a really long line which we will check for line-wrapping.  "x20;

msg_report;

msg_clr_counts;
msg_clr_opt qw( TIME_TAGS TAG_NUMBERS MSG_NUMBERS );
my $fh;  
open $fh, '>>', 'msg.log' or die "Couldn't open logfile for append:  $!";
msg_output( *STDOUT, $fh );    # send output to both STDOUT and msg.log
for (1..5) { msg "message $_" }

msg_report;
