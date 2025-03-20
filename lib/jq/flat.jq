def flat(f): [tostream|select(.[1]!=null)|{(.[0]|f):.[1]}]|reverse|add;
