def unsorted_unique_by(f): to_entries|unique_by(.value|f)|sort_by(.key)|map(.value);
