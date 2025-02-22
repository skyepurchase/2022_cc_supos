/* File parser.mly */

%{

let get_loc = Parsing.symbol_start_pos 

%}

%token <int> INT
%token ADD SUB MUL DIV EXP SEMICOLON DEC INC
%token LPAREN RPAREN
%token BEGIN END
%token EOF
%left ADD SUB        /* lowest precedence */
%left MUL DIV         /* medium precedence */
%left EXP
%nonassoc UMINUS
%nonassoc DEC INC


%start main
%type <Past.expr> simple_expr 
%type <Past.expr> expr 
%type <Past.expr list> exprlist
%type <Past.expr> main

%%
main:
	expr EOF                { $1 }
;
simple_expr:
| INT                                { Past.Integer (get_loc(), $1) }
| LPAREN expr RPAREN                 { $2 }

expr:
| simple_expr                        {  $1 }
| expr DEC                           { Past.UnaryOp(get_loc(), Past.DEC, $1) }
| expr INC                           { Past.UnaryOp(get_loc(), Past.INC, $1) }
| expr ADD expr                      { Past.Op(get_loc(), $1, Past.ADD, $3) }
| expr SUB expr                      { Past.Op(get_loc(), $1, Past.SUB, $3) }
| expr MUL expr                      { Past.Op(get_loc(), $1, Past.MUL, $3) }
| expr DIV expr                      { Past.Op(get_loc(), $1, Past.DIV, $3) }
| expr EXP expr                      { Past.Op(get_loc(), $1, Past.EXP, $3) }
| BEGIN exprlist END                 { Past.Seq(get_loc(), $2) }

exprlist:
|   expr                             { [$1] }
|   expr  SEMICOLON exprlist         { $1 :: $3  }


