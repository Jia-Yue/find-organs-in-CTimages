function [num_regions,label_I] = one_pass(I)
% use 'One component at a time' algorithm referrenced by Wiki to compute the connected regions
[m,n]=size(I);
pad_Image=padarray(I,[1,1]);
label_I=zeros(m,n);     
label=1;
queue_head=1;       
queue_tail=1;      
eight_neighbors=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  

for i=2:m-1
    for j=2:n-1
        if pad_Image(i,j)==1 && label_I(i,j) ==0           
            label_I(i,j)=label;
            q{queue_tail}=[i j]; % Use tuple to simulate queue and list current coordinates
            queue_tail=queue_tail+1;
            
            while queue_head~=queue_tail
                pix=q{queue_head};                
                for k=1:8               
                    pix1=pix+eight_neighbors(k,:); % pix1 is one of eight neighbors
                    if pix1(1)>=2 && pix1(1)<=m-1 && pix1(2) >=2 &&pix1(2)<=n-1
                        if pad_Image(pix1(1),pix1(2)) == 1 && label_I(pix1(1),pix1(2)) ==0  
                     % if the neighbor of current location is 1 without any
                     % label, label it with the current label
                            label_I(pix1(1),pix1(2))=label;
                            q{queue_tail}=[pix1(1) pix1(2)];
                            queue_tail=queue_tail+1;
                        end
                    end
                end
                queue_head=queue_head+1;
            end
            
            clear q;                %clear q for new label of new connected components
            label=label+1;
            queue_head=1;
            queue_tail=1;            
        end
    
    end
end
num_regions = max(label_I(:));  % num_regions is the number of connected regions.
end