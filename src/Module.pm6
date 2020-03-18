use Parsing::Parser;
use Parsing::Actions;
use Errors;

module Module is export {
    class File {
        has $.contents;
        has $.filename;
        has $.ast is rw;
        has $.module;
        has $.program;

        method parse {
            $.program.logger.log("Parsing", "$.filename");
            $.ast = Parser::Den.parse(self.contents, actions => Actions::Build);
        }
    }

    class Program {
        has %.files;
        has Bool $.debug;
        
        has $.logger;

        method new(Bool $debug) {
            self.bless(:$debug, logger => Errors::Logger.new(:$debug));
        }

        method add-file(File $file) {
            %.files.push: ($file.filename, $file);
        }
    }
}
