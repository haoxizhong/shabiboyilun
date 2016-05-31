M = load('game_1.txt');

sizeofM = size(M);

n = sizeofM(1);
m = sizeofM(1);

presize = 5;

sum=0;

warning off;
xyz=[];
	c1=1;
	c2=1;
	c3=1;

for a=(1:1:50)
    if (mod(a,2)==0)
        op=a-1;
    else
        op=a+1;
	end

	X=[];
	Y=[];
	sY=[];
	seq=[];
	states=[];
	testAns=[];
	runAns=[];
	fnum=[];
	cx=[0 0 0];

    for b=(1:1:50)
        seq=[seq int16(M(a,b)+1)];
    	nows=int16(M(a,b)+1);
        states=[states nows];
    
        if (b>presize)
            nowX=[];
            mysum = [0 0 0];
            yoursum = [0 0 0];
            for c=(1:1:presize)
                if (M(a,b-c)==0)
                    mysum(1) = mysum(1)+1;
                end
                if (M(a,b-c)==1)
                    mysum(2) = mysum(2)+1;
                end
                if (M(a,b-c)==2)
                    mysum(3) = mysum(3)+1;
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
                if (M(op,b-c)==2)
                    yoursum(3) = yoursum(3)+1;  
                end
            end
            delta=zeros(3,3);
            for c=(1:1:b-1)
                if (M(a,c)==0)
                    if (M(op,c)==0)
                        delta(1,1) = delta(1,1)+1;
                    end
                    if (M(op,c)==1)
                        delta(1,2) = delta(1,2)+1;
                    end
                    if (M(op,c)==2)
                        delta(1,3) = delta(1,3)+1;
                    end
                end
                if (M(a,c)==1)
                    if (M(op,c)==0)
                        delta(2,1) = delta(1,1)+1;
                    end
                    if (M(op,c)==1)
                        delta(2,2) = delta(1,2)+1;
                    end
                    if (M(op,c)==2)
                        delta(2,3) = delta(1,3)+1;
                    end
                end
                if (M(a,c)==2)
                    if (M(op,c)==0)
                        delta(3,1) = delta(1,1)+1;
                    end
                    if (M(op,c)==1)
                        delta(3,2) = delta(1,2)+1;
                    end
                    if (M(op,c)==2)
                        delta(3,3) = delta(1,3)+1;
                    end
                end
            end
            yoursum = yoursum*1.0/presize;
        	nowX=[nowX mysum yoursum];
            for c=(1:1:3)
                for d=(1:1:3)
                    nowX=[nowX delta(c,d)*1.0/(b-1)];
                end
            end
            nowY=[];
            if (M(a,b)==0)
                nowY=[1,0,0];
                nowsY=['1','0','0'];
            end
            if (M(a,b)==1)
                nowY=[0,1,0];
                nowsY=['0','1','0'];
            end
            if (M(a,b)==2)
                nowY=[0,0,1];
                nowsY=['0','0','1'];
            end
        end

        if (b>presize && cx(1)+cx(2)+cx(3)==3)
          	ttt=0;
        	[trans, emis] = hmmestimate(seq, states);
            [trans, emis] = hmmtrain(seq, trans, emis);
            [seqe,stat] = hmmgenerate(50,trans,emis);
    
            net = newff( minmax(X'), [10 3] , {'purelin' 'logsig' } , 'traingdx');
        	net.trainparam.show = 5000 ;
            net.trainparam.epochs = 2000 ;
        	net.trainparam.goal = 0.1 ;
            net.trainParam.lr = 0.01 ;
            net = train(net,X',Y');
    
            testY = nowY';
        	resY = sim(net,nowX');

            res=1;
        	for c=(1:1:3)
				if (resY(c)>resY(res))
					res=c;
                end
            end
    
            svmstruct0=svmtrain(X,sY(:,1));	
            svmstruct1=svmtrain(X,sY(:,2));
            svmstruct2=svmtrain(X,sY(:,3));	

            ans = [svmclassify(svmstruct0,nowX), svmclassify(svmstruct1,nowX), svmclassify(svmstruct2,nowX)];
			res2=1;
			if (ans=='000')
				res2=int16(floor(rand*3))+1;
			else
				while (ans(res2)=='0')
					res2=int16(floor(rand*3)+1);
				end
			end
			if (b>30)

			%runAns=[runAns,res2-1];

			pr=rand;
           	%if (pr<=c1*1.0/(c1+c2+c3))
			if (c1>=c2 && c1>=c3)
                runAns=[runAns,seqe(b)-1];
            else
			%	%if (pr<=(c1+c2)*1.0/(c1+c2+c3))
				if (c2>c3)
	        		runAns=[runAns,res-1];
				else
					runAns=[runAns,res2-1];
				end
            end
			fnum=[fnum;[seqe(b)-1,res-1,res2-1]];
			%ft=[0,0,0];
			%ft(int16(seqe(b)))=ft(int16(seqe(b)))+1;
			%ft(res)=ft(res)+1;
			%ft(res2)=ft(res2)+1;
			%x=1;
			%for c=(1:1:3)
			%	if (ft(c)>ft(x))
			%		x=c;
			%	end
			%end
			%if (ft(x)==1)
			%	x=int16(floor(rand*3)+1);
			%end
			%x=x-1;
			%runAns=[runAns,x];

        	testAns = [testAns,M(a,b)];
			end
        	if (M(a,b)==seqe(b)-1)
        		c1=c1+1;
            end
        	if (M(a,b)==res-1)
                c2=c2+1;
            end
			if (M(a,b)==res2-1)
				c3=c3+1;
			end
        end


        if (b>presize)
            X=[X;nowX];
            Y=[Y;nowY];
            sY=[sY;nowsY];
			if (M(a,b)==0)
				cx(1)=1;
			end
			if (M(a,b)==1)
				cx(2)=1;
			end
			if (M(a,b)==2)
				cx(3)=1;
			end
        end
    end

	fnum=fnum';

	tot=[0,0,0];
	for b=(1:1:3)
		for c=(1:1:20)
			if (testAns(b)==fnum(b,c))
				tot(b)=tot(b)+1;
			end
		end
	end
	xyz=[xyz;[a,tot]];
    tot=0;
    for b=(1:1:20)
        if (testAns(b)==runAns(b))
            tot=tot+1;
        end
    end
	%x=1;
	%if (tot(2)>tot(x))
	%	x=2;
	%end
	%if (tot(3)>tot(x))
	%	x=3;
	%end
	sum=sum+tot;
	[a,tot,sum]
end

sum
xyz
