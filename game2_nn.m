M = load('game_2.txt');

sizeofM = size(M);

n = sizeofM(1);
m = sizeofM(1);

presize = 10;

sum=0;
xyz=[];

warning off;

for a=(1:1:50)
	if (mod(a,2)==0)
		op=a-1;
	else
		op=a+1;
	end

	X=[];
	Y=[];
	testAns=[];
	runAns=[];
	tot=0;

	for b=(presize+1:1:50)
		nowX=[];
		mysum = [0 0];
		yoursum = [0 0];
		for c=(1:1:presize)
			if (M(a,b-c)==0)
				mysum(1) = mysum(1)+1;
			end
			if (M(a,b-c)==1)
				mysum(2) = mysum(2)+1;
			end
		end
		mysum = mysum*1.0/presize;

		for c=(1:1:presize)
			if (M(op,b-c)==0)
				yoursum(1) = yoursum(1)+1;
			end
			if (M(op,b-c)==1)
				yoursum(2) = yoursum(2)+1;
			end
		end
	
		delta=zeros(2,2);
		for c=(1:1:b-1)
			if (M(a,c)==0)
				if (M(op,c)==0)
					delta(1,1) = delta(1,1)+1;
				end
				if (M(op,c)==1)
					delta(1,2) = delta(1,2)+1;
				end
			end
			if (M(a,c)==1)
				if (M(op,c)==0)
					delta(2,1) = delta(1,1)+1;
				end
				if (M(op,c)==1)
					delta(2,2) = delta(1,2)+1;
				end
			end
		end

		yoursum = yoursum*1.0/presize;
		nowX=[nowX mysum yoursum];
		for c=(1:1:2)
			for d=(1:1:2)
				nowX=[nowX delta(c,d)*1.0/(b-1)];
			end
		end
		nowY=[];
		if (M(a,b)==0)
			nowY=[1,0];
		end
		if (M(a,b)==1)
			nowY=[0,1];
		end

		if (b>30)
			net = newff( minmax(X'), [10 2] , {'purelin' 'logsig' } , 'traingdx');
			net.trainparam.show = 5000 ;
			net.trainparam.epochs = 1000 ;
			net.trainparam.goal = 0.1 ;
			net.trainParam.lr = 0.01 ;
			net = train(net,X',Y');

			testY = nowY';
			resY = sim(net,nowX');

			res1=1;
			res2=1;
			for c=(1:1:2)
				if (testY(c)>testY(res1))
					res1=c;
				end
				if (resY(c)>resY(res2))
					res2=c;
				end
			end
			testAns = [testAns,res1];
			runAns = [runAns,res2];
		end

		X=[X;nowX];
		Y=[Y;nowY];
	end

	for b=(1:1:20)
		if (testAns(b)==runAns(b))
			tot=tot+1;
		end
	end
	sum=sum+tot;
	[a,tot,sum]
	xyz=[xyz;[a,tot,sum]];
end

sum
