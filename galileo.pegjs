Program = _'('*_ a:Application _')'?_ {
  return a;
}

Application = l:ExprAbs r:Application* {
    if (!r || !r.length) {
        return l;
    } else {
        return { type: 'application', left: l, right: r };
    }
};

