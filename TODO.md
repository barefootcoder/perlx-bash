These are things I want to not forget to do.  Also, any people who are
interested in contributing to PerlX::bash could take on one of these tasks.
The list below is not in any particular order.

* BUG: If your command is represented by a path object (e.g. Path::Class,
  Path::Tiny, etc), this confuses `bash`:
  ```
  [caemlyn:~] perl -MPath::Tiny -MPerlX::bash -E 'my $ls = path("/bin/ls"); say bash \string => $ls'
  bash: multiple capture specifications at -e line 1.
  ```
