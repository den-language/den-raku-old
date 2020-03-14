module Helpers {
    sub read-file($filename) is export {
        slurp $filename
    }
}