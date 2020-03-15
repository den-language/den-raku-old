module Helpers is export {
    class File {
        has $.contents;
        has $.filename;
    }

    our sub read-file($filename) {
        File.new(
            contents => (slurp $filename),
            :$filename
        );
    }
}