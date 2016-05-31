M = load('game_2.txt');

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

	for b=(1:1:50)
		if (b>30)
			ttt=0;
			[trans, emis] = hmmestimate(seq, states);
			[trans, emis] = hmmtrain(seq, trans, emis);
			%[seqe,stat] = hmmgenerate(50,trans,emis);
			res=1;
			for c=(1:1:2)
				if (trans(M(a,b-1)+1,c)>trans(M(a,b-1)+1,res))
					res=c;
				end
			end
			runAns = [runAns,res-1];
			testAns = [testAns,M(a,b)];
		end
		seq=[seq int16(M(a,b)+1)];
		nows=int16(M(a,b)+1);
		states=[states nows];
	end

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
