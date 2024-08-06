% Please insert the names and email addresses of the group members:
% Ayan Aslanli - ayan.aslanli@uni-potsdam.de
% Joy Mallick Md Nazmul - joy.md@uni-potsdam.de

%
% Input:
%   #const n: the time steps range from 0 to n
%   edge(N1,N2): there is an (undirected) edge between nodes N1 and N2
%   robot(R,C,N): robot R is of class C and starts at node N
%   job(J,C,D): job J is of class C and its deadline is D 
%   operation(J,O,N): J's operation O takes place at node N (O >= 1)
%
% Output:
%   at(R,N,T): robot R is at node N at time step T
%   assign(R,J,I): assign to R the job J at index I (in the sequence of jobs assigned to R) (I >= 1)
%

time(0..n).
edge(B,A):- edge(A,B).
node(A):- edge(A,_).

at(R,N,T) :- robot(R,C,N), T=0.
{at(R,N,T) : node(N)}=1 :- time(T), robot(R,_,_).
:- at(R,N,T), at(R,N',T+1), not edge(N,N'), N!=N'.
:- at(R,N,T), at(R',N,T), R!=R'.
:- at(R,N,T), at(R',N',T), at(R,N',T+1), at(R',N,T+1), edge(N,N'), R!=R', N!=N'.



{assign(R,J,1..P) : robot(R,C,_)}=1 :- job(J,C,_), P = #count{L: job(L,C,_)}.
:- assign(R,J,P), assign(R,J',P), J!=J'. 



reaches(R,J,1,1,T) :- assign(R,J,1), job(J,_,D), operation(J,1,N), at(R,N,T), T<=D.

reaches(R,J,1,P+1,T+1) :- job(J,_,D), assign(R,J,P+1), operation(J,1,N), at(R,N,T+1), reaches(R,J',O',P,T), O'=#count{O:operation(J',O,_)}, T+1<=D.
reaches(R,J,O+1,P,T+1) :- reaches(R,J,O,P,T), assign(R,J,P), job(J,_,D), operation(J,O+1,N), at(R,N,T+1), T+1<=D.

reaches(R,J,O,P,T+1) :- reaches(R,J,O,P,T), T+1<=n.
:- operation(J,O,_), not reaches(_,J,O,_,_).


stays(R,N,T,T') :- at(R,N,T), at(R,N,T'), T'=T+1.
#maximize{1,R,N,T,T': stays(R,N,T,T')}.

#show at/3.
#show assign/3.
