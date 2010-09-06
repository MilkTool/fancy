def class AST {
  def class Method : Node {
    self read_write_slots: ['ident, 'args, 'body];

    def Method identifier: ident args: args body: body {
      m = AST::Method new;
      m ident: ident;
      m args: args;
      m body: body;
      m
    }

    def Method from_sexp: sexp {
      ident = AST::Identifier new: (sexp second);
      args = sexp third map: 'to_ast;
      body = sexp fourth to_ast;
      AST::Method identifier: ident args: args body: body
    }

    def to_s {
      "<Method: ident:'" ++ @ident ++ "' args:" ++ @args ++ " body:" ++ @body ++ ">"
    }
  }
}
