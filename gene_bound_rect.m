function [back_top, back_down, back_left, back_right, centerprior, centers] = gene_bound_rect(img,obj,saldir, oname,sp_center, sp_num, superpixels,ratio,DEBUG)
% 3,5,2,4  top down left right
% Guangyu Zhong : Guangyuzhonghikari@gmail.com
[m,n,d] = size(img);
back_top = [];
back_down = [];
back_left = [];
back_right = [];

index_top = find(obj(:,3)<10);
for jj = 1:length(index_top)
    
    if abs(obj(index_top(jj),3)-obj(index_top(jj),5))>100
        continue;
    end
    back_top = [back_top, index_top(jj)];
    if DEBUG
        color = [0,0,1];
        img(obj(index_top(jj),3):obj(index_top(jj),5), obj(index_top(jj),2),:) = repmat(color.*255,[obj(index_top(jj),5) - obj(index_top(jj),3)+1,1,1]);
        img(obj(index_top(jj),3):obj(index_top(jj),5), obj(index_top(jj),4),:) =  repmat(color.*255,[obj(index_top(jj),5) - obj(index_top(jj),3)+1,1,1]);
        img(obj(index_top(jj),3), obj(index_top(jj),2):obj(index_top(jj),4),:) =  repmat(color.*255,[obj(index_top(jj),4) - obj(index_top(jj),2)+1,1,1]);
        img(obj(index_top(jj),5), obj(index_top(jj),2):obj(index_top(jj),4),:) =  repmat(color.*255,[obj(index_top(jj),4) - obj(index_top(jj),2)+1,1,1]);
    end
end
%% down
index_down = find(obj(:,5)>m-10);

for jj = 1:length(index_down)
    
    if abs(obj(index_down(jj),3)-obj(index_down(jj),5))>100
        continue;
    end
    back_down = [back_down, index_down(jj)];
    if DEBUG
        color = [0,0,1];
        img(obj(index_down(jj),3):obj(index_down(jj),5), obj(index_down(jj),2),:) = repmat(color.*255,[obj(index_down(jj),5) - obj(index_down(jj),3)+1,1,1]);
        img(obj(index_down(jj),3):obj(index_down(jj),5), obj(index_down(jj),4),:) =  repmat(color.*255,[obj(index_down(jj),5) - obj(index_down(jj),3)+1,1,1]);
        img(obj(index_down(jj),3), obj(index_down(jj),2):obj(index_down(jj),4),:) =  repmat(color.*255,[obj(index_down(jj),4) - obj(index_down(jj),2)+1,1,1]);
        img(obj(index_down(jj),5), obj(index_down(jj),2):obj(index_down(jj),4),:) =  repmat(color.*255,[obj(index_down(jj),4) - obj(index_down(jj),2)+1,1,1]);
    end
end

%% left
index_left = find(obj(:,2)<10);

for jj = 1:length(index_left)
    
    if abs(obj(index_left(jj),2)-obj(index_left(jj),4))>100
        continue;
    end
    back_left = [back_left, index_left(jj)];
    if DEBUG
        color = [0,0,1];
        img(obj(index_left(jj),3):obj(index_left(jj),5), obj(index_left(jj),2),:) = repmat(color.*255,[obj(index_left(jj),5) - obj(index_left(jj),3)+1,1,1]);
        img(obj(index_left(jj),3):obj(index_left(jj),5), obj(index_left(jj),4),:) =  repmat(color.*255,[obj(index_left(jj),5) - obj(index_left(jj),3)+1,1,1]);
        img(obj(index_left(jj),3), obj(index_left(jj),2):obj(index_left(jj),4),:) =  repmat(color.*255,[obj(index_left(jj),4) - obj(index_left(jj),2)+1,1,1]);
        img(obj(index_left(jj),5), obj(index_left(jj),2):obj(index_left(jj),4),:) =  repmat(color.*255,[obj(index_left(jj),4) - obj(index_left(jj),2)+1,1,1]);
    end
end

%% right
index_right = find(obj(:,4)>n-10);

for jj = 1:length(index_right)
    if abs(obj(index_right(jj),2)-obj(index_right(jj),4))>100
        continue;
    end
    back_right = [back_right, index_right(jj)];
    if DEBUG
        color = [0,0,1];
        img(obj(index_right(jj),3):obj(index_right(jj),5), obj(index_right(jj),2),:) = repmat(color.*255,[obj(index_right(jj),5) - obj(index_right(jj),3)+1,1,1]);
        img(obj(index_right(jj),3):obj(index_right(jj),5), obj(index_right(jj),4),:) =  repmat(color.*255,[obj(index_right(jj),5) - obj(index_right(jj),3)+1,1,1]);
        img(obj(index_right(jj),3), obj(index_right(jj),2):obj(index_right(jj),4),:) =  repmat(color.*255,[obj(index_right(jj),4) - obj(index_right(jj),2)+1,1,1]);
        img(obj(index_right(jj),5), obj(index_right(jj),2):obj(index_right(jj),4),:) =  repmat(color.*255,[obj(index_right(jj),4) - obj(index_right(jj),2)+1,1,1]);
    end
end

if DEBUG
    outname = [oname(1:end-4), '_objback.jpg'];
    imwrite(img, [saldir, outname]);
end
back = [back_top, back_down, back_left, back_right];
%% centers
centers(:,2) = [(obj(back_top,2) + obj(back_top,4))./2; (obj(back_down,2) + obj(back_down,4))./2; obj(back_left,2); obj(back_right,4)];  %y
centers(:,1) = [obj(back_top,3);  obj(back_down,5); (obj(back_left,3) + obj(back_left,5))./2; (obj(back_right,3) + obj(back_right,5))./2];  %x

rect_mn(:,2) = abs(obj(back,3) - obj(back,5))./2;
rect_mn(:,1) = abs(obj(back,2) - obj(back,4))./2;

centerprior = zeros(sp_num,1);
obj(:,1) = normal(obj(:,1));
if DEBUG
    figure; imshow(img);hold on;
end

for objnn =1:numel(back)
    [center_prior] = cue_by_select_center(centers(objnn,:),sp_center,ratio, rect_mn(objnn,:)); % 这个函数用错了 除以 长，宽一半的平方 而不是 中点位置
    center_prior = normal(center_prior);
    if DEBUG
        rectangle('Position',[obj(back(objnn),2),obj(back(objnn),3),obj(back(objnn),4)-obj(back(objnn),2), obj(back(objnn),5) - obj(back(objnn),3)],'edgecolor',color,'LineWidth',4);
    end
    centerprior = (center_prior.*(1-(obj(objnn,1)).^2))+ centerprior;
end
