def unsorted_unique: to_entries|unique_by(.value)|sort_by(.key)|map(.value);
