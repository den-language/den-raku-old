use Terminal::ANSIColor;

module Errors is export {
    class Error {
        has $.filename;
        has $.type;
        has $.text;
    }

    class Logger {
        has @!errors;
        has Bool $.debug;
    
        method error(Error $error) {
            @!errors.append: $error;
        }

        method log(Str $colored, Str $message) {
            say "{color('blue')}{$colored}{color('reset')} {$message}" if $.debug;
        }
    }
}
