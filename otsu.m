function th = otsu(I)
% The range for I should be 0-255
[m,n]=size(I);
count = zeros(256,1);
for i=0:1:255
    count(i+1,1) = sum(sum(I == i));
end
P=count/(m*n); 
E=zeros(1,256); 
for TH=0:1:255        
    av0=0;
    av1=0;
    w0=sum(P(1:TH+1));  % P(Intensiry = 0 to TH)  
    w1 = 1 - w0;
    % class1
    for i=1:TH+1        % sigma(i=0 to TH)
        av0= av0 + (i-1)*count(i);   
    end 
    u0 = av0/w0;        % mean intensity of class1
    % class2
    for i=TH+2:256     % sigma(i=TH+1 to L-1)
        av1= av1 + (i-1)*count(i);   
    end 
    u1 = av1/w1;      % mean intensity of class2
    E(TH+1) = w0*w1*(u1-u0)*(u1-u0);   %compute between-class variance
end 
position=find(E==max(E));  % find the location of maximum value  
th=floor(mean(position))-1; 
end