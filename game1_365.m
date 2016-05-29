M = load('game_1.txt');

sizeofM = size(M);

n = sizeofM(1);
m = sizeofM(1);

presize = 0;

sum=0;

warning off;

	for a=(1:1:50)
if (mod(a,2)==0)
	op=a-1;
	else
	op=a+1;
	end
	seq=[];
	states=[];
	testAns=[];
	runAns=[];

for b=(2:1:50)
	seq=[seq int16(M(a,b)+1)];
	nows=int16(M(a,b)+1);
	states=[states nows];
if (b>30)
	ttt=0;
	[trans, emis] = hmmestimate(seq, states);
	[trans, emis] = hmmtrain(seq, trans, emis);
	[seqe,stat] = hmmgenerate(50,trans,emis);
	%nowsum=0;
	%pr=rand;
	%pr
	%nows
	%for c=(1:1:9)
	%	nowsum=nowsum+trans(nows,c);
	%	if (pr<=nowsum)
	%		runAns = [runAns,(c-1)/3];
	%		b
	%		break
	%	end
	%end
	runAns = [runAns,seqe(b)-1];
	testAns = [testAns,M(a,b)];
	end
	end

	seqe
	seq
	tot=0;
	for b=(1:1:20)
if (testAns(b)==runAns(b))
	tot=tot+1;
	end
	end
	sum=sum+tot;
	[a,tot,sum]
	end

	sum
