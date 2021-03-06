Program = _'('*_ a:Application _')'?_ {
  return a;
}

Application = l:ExprAbs r:Application* {
  if (!r || !r.length) {
    return l;
  } else {
    r = r.pop();
    return { type: 'application', left: l, right: r};
  }
};

ExprAbs = Expr / Abstraction;

Abstraction = _ '('* _ 'λ' _ id:Identifier ':' t:Type '→' f:Application _ ')'? _ {
  return { type: 'abstraction', arg: { type: t, id: id }, body: f };
}

Expr = IfThen / IsZeroCheck / ArithmeticOperation / Zero / True / False / Identifier / ParanExpression

ArithmeticOperation = o:Operator e:Application {
  return { type: 'arithmetic', operator: o, expression: e };
};

IsZeroCheck = IsZero e:Application {
  return { type: 'is_zero', expression: e };
}

Operator = Succ / Pred

IfThen = If expr:Application Then then:Application Else el:Application {
  return { type: 'conditional_expression', condition: expr, then: then, el: el };
}

Type =  Nat / Bool

_  = [ \t\r\n]*

__ = [ \t\r\n]+

Identifier = !ReservedWord _ id:[a-z]+ _ {
  return { name: id.join(''), type: 'identifier' };
}

ParanExpression = _'('_ expr:Expr _')'_ {
  return expr;
}

True = _ 'true' _ {
  return { type: 'literal', value: true };
}

False = _ 'false' _ {
  return { type: 'literal', value: false };
}

Zero = _ '0' _ {
  return { type: 'literal', value: 0 };
}

ReservedWord = If / Then / Else / Pred / Succ / Nat / Bool / IsZero / False

If = _'if'_

Then = _'then'_

Else = _'else'_

Pred = _'pred'_ {
  return 'pred';
}

Succ = _'succ'_ {
  return 'succ';
}

Nat = _'Nat'_ {
  return 'Nat';
}

Bool = _'Bool'_ {
  return 'Bool';
}

IsZero = _'iszero'_ {
  return 'iszero';
}