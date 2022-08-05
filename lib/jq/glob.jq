def glob($g): test("^"+($g|glob_to_re)+"$");
