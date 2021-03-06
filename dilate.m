function Dilation = dilate(Ik,SE)
% Ik is input image, SE is structuring element whose size must be odd
% pad the input image to operate edge
L=size(SE,1);
padl=floor(L/2);
pad_Image=padarray(Ik,[padl,padl]);
[M,N]=size(Ik);
Dilation=zeros(M,N);
for i=1:M
    for j=1:N
        % get the subregion
        Block=pad_Image(i:i+2*padl,j:j+2*padl);
        M=Block.*SE;
        % delete 0 value
        M=M(:);
        M(find(SE==0))=[];
        % dilation
        Dilation(i,j)=max(M);
    end
end
end
             