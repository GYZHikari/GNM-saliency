function [obj, img,jj] = gene_obj_rectangle(img, odir,saldir, oname, objNum)
% generate object area using BING txt
% input: input_im original map
%        odir oname   object.txt location
%        objNum max rectangle numbers
% Guangyu Zhong : guangyuzhonghikari@gmail.com
fid = fopen([odir oname],'rt');
obj =textscan(fid,'%s','headerLines',1,'Delimiter',',');
obj = str2double(obj{1});
obj = reshape(obj, 5,numel(obj)/5)';
fclose('all');

for jj =1: min(length(obj(:,1))./3,objNum)
    color = [1,1,0];
    img(obj(jj,3):obj(jj,5), obj(jj,2),:) = repmat(color.*255,[obj(jj,5) - obj(jj,3)+1,1,1]);
    img(obj(jj,3):obj(jj,5), obj(jj,4),:) =  repmat(color.*255,[obj(jj,5) - obj(jj,3)+1,1,1]);
    img(obj(jj,3), obj(jj,2):obj(jj,4),:) =  repmat(color.*255,[obj(jj,4) - obj(jj,2)+1,1,1]);
    img(obj(jj,5), obj(jj,2):obj(jj,4),:) =  repmat(color.*255,[obj(jj,4) - obj(jj,2)+1,1,1]);
end
outname = [oname(1:end-4), '_obj.jpg'];
imwrite(img, [saldir, outname]);
