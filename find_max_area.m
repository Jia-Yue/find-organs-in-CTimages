function max_area = find_max_area(I)
[m,n]=size(I);
[num,label]= one_pass(I);
area = zeros(num,1);
for k = 1:1:num    
    area(k)= length(find(label==k));
    area2 = sort(area,'descend');
    max_area_label = find(area==area2(1));
end
C = zeros(m,n);
C(find(label==max_area_label))=1;
max_area = C.*I;
end