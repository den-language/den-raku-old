use lib "./src";
use Helpers;

sub MAIN($filename) {
    my $file = Helpers::read-file($filename);
}
