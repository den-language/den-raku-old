use Module;

module Helpers is export {
    our sub read-file(Str $filename, Module::Program $program) {
        Module::File.new(
            contents => (slurp $filename),
            :$filename
            :$program
        );
    }
}
