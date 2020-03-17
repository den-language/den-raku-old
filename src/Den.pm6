use lib "./src";
use Helpers;

my %*SUB-MAIN-OPTS =
  :named-anywhere,
;

sub MAIN(
    Str $filename, #= File to compile with entry point
    Bool :$debug, #= Debug mode
) {
    my $file = Helpers::read-file($filename);
    $file.parse;
}
