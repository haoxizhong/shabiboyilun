M = load('game_1.txt');

sizeofM = size(M);

n = sizeofM(1);
m = sizeofM(1);

presize = 5;

sum=0;

warning off;

for a=(1:1:50)
    if (mod(a,2)==0)
        op=a-1;
    else
        op=a+1;
    end
    X=[];
    Y=[];
    for b=(presize+1:1:30)
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
        nowX=[nowX mysum yoursum];
        for c=(1:1:3)
            for d=(1:1:3)
                nowX=[nowX delta(c,d)*1.0/(b-1)];
            end
        end
        X=[X;nowX];
        if (M(a,b)==0)
            Y=[Y;[1,0,0]];
        end
        if (M(a,b)==1)
            Y=[Y;[0,1,0]];
        end
        if (M(a,b)==2)
            Y=[Y;[0,0,1]];
        end
    end
    
    X=X';
    Y=Y';
    net = newff( minmax(X), [20 3] , {'purelin' 'logsig'} , 'traingdx');
    net.trainparam.show = 5000 ;
    net.trainparam.epochs = 2000 ;
    net.trainparam.goal = 0.1 ;
    net.trainParam.lr = 0.01 ;
    net = train(net,X,Y);
    
    testX=[];
    testY=[];
    for b=(31:1:50)
        nowX=[];
        for c=(1:1:presize)
            nowX=[nowX M(a,b-c)];
        end
        for c=(1:1:presize)
            nowX=[nowX M(op,b-c)];
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
        for c=(1:1:3)
            for d=(1:1:3)
                nowX=[nowX delta(c,d)*1.0/(b-1)];
            end
        end
        testX=[testX;nowX];
        if (M(a,b)==0)
            testY=[testY;[1,0,0]];
        end
        if (M(a,b)==1)
            testY=[testY;[0,1,0]];
        end
        if (M(a,b)==2)
            testY=[testY;[0,0,1]];
        end
    end
    
    testY=testY';
    resY=sim(net,testX');
    tot=0;
    testAns=[];
    runAns=[];
    for b=(1:1:20)
        res1=1;
        res2=1;
        for c=(1:1:3)
            if (testY(c,b)>testY(res1,b))
                res1=c;
            end
            if (resY(c,b)>resY(res2,b))
                res2=c;
            end
        end
        testAns = [testAns,res1];
        runAns = [runAns,res2];
    end
    for b=(1:1:20)
        if (testAns(b)==runAns(b))
            tot=tot+1;
        end
    end
    sum=sum+tot;
    [a,tot,sum]
end

sum
