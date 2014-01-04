go :- 
	current_prolog_flag(argv, Argv),
    consult(actions),
    consult(utilities),
    nth0(1,Argv,File),
    consult(File),
    action(X,Y,D),
    sub_atom(File, 6, _, 0, N), 
    string_concat('DECISION', N, Output),
    open(Output, write, OS),
    write(OS,X), nl(OS),
    write(OS,Y), nl(OS),
    write(OS,D),
    close(OS).

% swipl -O -t go --quiet --stand_alone=true -o exe -c exe.pl
% ./exe STATUS2

% swipl -O -g go,halt -t 'halt(1)' --quiet --stand_alone=true -o exe_player -c exe_player.pl
