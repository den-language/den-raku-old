use Parser;

module Module is export {
    class File {
        has $.contents;
        has $.filename;
        has $.ast is rw;
        has $.module;

        method parse {
            say "Parsing { self.filename }";
            self.ast = Parser::Den.parse(self.contents);
        }
    }
}
