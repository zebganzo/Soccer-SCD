split([]).
split([Head|Tail]) :-
	assert(Head),
    %writeln(Head),
	split(Tail).

atoms_list(Atom, List):-
  atomic_list_concat(['[', Atom, ']'], NAtom), 
  term_to_atom(List, NAtom).

go :- 
	current_prolog_flag(argv, Argv),
    %writeln(Argv),
    consult(actions),
    consult(utilities),
    nth0(1,Argv,File),
    atoms_list(File,ArgList),
    %writeln(File),
    %writeln(ArgList),
    split(ArgList),
    action(X,Y,D),
	write(X),
	write(,),
	write(Y),
	write(,),
	write(D).
%   sub_atom(File, 6, _, 0, N), 
%   string_concat('DECISION', N, Output),
%   open(Output, write, OS),
%   write(OS,X), nl(OS),
%   write(OS,Y), nl(OS),
%   write(OS,D),
%   close(OS).

% swipl -O -t go --quiet --stand_alone=true -o exe_player -c exe_player.pl
% ./exe STATUS2

% swipl -O -g go,halt -t 'halt(1)' --quiet --stand_alone=true -o exe_player -c exe_player.pl

% swipl --goal=go --quiet --stand_alone=true -o exe_player -c exe_player.pl
