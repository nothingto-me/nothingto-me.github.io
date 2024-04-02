% domain

block(a;b;c;d).

action(pick_up(X)) :- block(X).
action(put_down(X)) :- block(X).
action(stack(X,Y)) :- block(X), block(Y).
action(unstack(X,Y)) :- block(X), block(Y).

% executability conditions

:- occurs(pick_up(X), T), not holds(clear(X), T).
:- occurs(pick_up(X), T), not holds(ontable(X), T).
:- occurs(pick_up(X), T), not holds(handempty, T).

:- occurs(put_down(X), T), not holds(holding(X), T).

:- occurs(stack(X, Y), T), not holds(holding(X), T).
:- occurs(stack(X, Y), T), not holds(clear(Y), T).

:- occurs(unstack(X, Y), T), not holds(clear(X), T).
:- occurs(unstack(X, Y), T), not holds(on(X, Y), T).
:- occurs(unstack(X, Y), T), not holds(handempty, T).

% dynamic causal laws

-holds(ontable(X), T + 1) :- occurs(pick_up(X), T).
-holds(clear(X), T + 1) :- occurs(pick_up(X), T).
holds(holding(X), T + 1) :- occurs(pick_up(X), T).
-holds(handempty, T + 1) :- occurs(pick_up(X), T).

holds(ontable(X), T + 1) :- occurs(put_down(X), T).
holds(clear(X), T + 1) :- occurs(put_down(X), T).
-holds(holding(X), T + 1) :- occurs(put_down(X), T).
holds(handempty, T + 1) :- occurs(put_down(X), T).

-holds(holding(X), T + 1) :- occurs(stack(X, Y), T).
-holds(clear(Y), T + 1) :- occurs(stack(X, Y), T).
holds(clear(X), T + 1) :- occurs(stack(X, Y), T).
holds(handempty, T + 1) :- occurs(stack(X, Y), T).
holds(on(X, Y), T + 1) :- occurs(stack(X, Y), T).

holds(holding(X), T + 1) :- occurs(unstack(X, Y), T).
holds(clear(Y), T + 1) :- occurs(unstack(X, Y), T).
-holds(clear(X), T + 1) :- occurs(unstack(X, Y), T).
-holds(handempty, T + 1) :- occurs(unstack(X, Y), T).
-holds(on(X, Y), T + 1) :- occurs(unstack(X, Y), T).

% initial state

initially(handempty).
initially(clear(a)).
initially(clear(c)).
initially(ontable(c)).
initially(ontable(b)).
initially(on(a, b)).

% goal conditions

finally(on(a, c)).
finally(on(c, b)).

% time

time(1..7).

% goal

not_goal(T) :- time(T), finally(X), not holds(X, T).
goal(T) :- time(T), not not_goal(T).

% eliminating plan without given length

:- not goal(7).

% initial fluent values

holds(F, 1) :- initially(F).

% inertia

holds(F, T + 1) :- T < 8, holds(F, T), not -holds(F, T + 1).
-holds(F, T + 1) :- T < 8, -holds(F, T), not holds(F, T + 1).

% occurrence of actions

%1 { occurs(A, T) : action(A) } 1 :- time(T), not goal(T).

#show occurs/2.
