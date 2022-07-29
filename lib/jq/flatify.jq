def flatify(f;k): del(f) + (f // {} | with_entries(.key|=k));
