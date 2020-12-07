function [head,body,tail]=decomp(A)
N=length(A);
C=A;
C(find(C<0))=0;
env = imdilate(C, true(1500, 1));
plot(env)
zindex=find(env<0.01);
zdiff=diff(zindex);
index=find(zdiff>N/10)
if~length(index)==0
head_index=index(1);
tail_index=index(length(index))+1;
head=A(1:zindex(head_index));
body=A(zindex(head_index)+1:zindex(tail_index));
tail=A(zindex(tail_index)+1:N);
else
    body=A;
    head=0;
    tail=0;
end

