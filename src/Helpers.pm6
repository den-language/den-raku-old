use Module;

module Helpers is export {
    our sub read-file($filename) {
        Module::File.new(
            contents => (slurp $filename),
            :$filename
        );
    }
}
