Program = _'('*_ a:Application _')'?_ {
  return a;
}

Application = l:ExprAbs r:Application* {
    if (!r || !r.length) {
        return l;
    } else {
        r = r.pop();
        return { type: 'application', left: l, right: r };
    }
};

ExprAbs = Expr / Abstraction;

Abstraction = _ '('? _ 'fun' _ id:Identifier ':' f:Application _ ')'? _ {
    return {
        type: 'abstraction',
        arg: {id: id}, 
        body: f
    };
}

Expr = IfThen / True / False / Identifier / ArithmeticOperation

ArithmeticOperation = o:Operator e:Application {
    return {
        type: 'arithmetic',
        operator: o,
        expression: e
    };
};

IfThen = If expr:Application Then then:Application Else el:application {
    return {
        condition: expr,
        then: then,
        el: el
    };
}

Identifier = !ReservedWord _ id:[a-z]+ _ {
    return {
        name: id.join(''),
        type: identifier
    };
}


True = _'true'_ {
    return {
        type: 'literal',
        value: 'true'
    };
}

False = _'false'_ {
    return {
        type: 'literal',
        value: 'false'
    };
}

ReservedWord = If / Then / Else / False / Reply / ListenFor / Say 

If  = _'if'_

Then = _'then'_ 

Else = _'else'_ 

Reply = _'reply'_ {
    return 'reply';
}

ListenFor = _'listenFor'_ {
    return 'listenFor';
}

Say = _'say'_ {
    return 'say';
}
