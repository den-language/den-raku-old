use lib "./src";
use Helpers;
use Module;

my %*SUB-MAIN-OPTS =
  :named-anywhere,
;

sub MAIN(
    Str $filename, #= File to compile with entry point
    Bool :$debug, #= Debug mode
) {
    my $program = Module::Program.new(
        $debug
    );
    my $file = Helpers::read-file($filename, $program);
    $program.add-file($file);
    $file.parse;
    say $program.files{"examples/functions.den"}.ast;
}
