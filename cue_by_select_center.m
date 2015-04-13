function  [cueImgCnt] = cue_by_select_center(center,spCnt,ratio, rectmn)

% calculate guass based selected center 
% center = spCnt(center,:);
nSp = length(spCnt);


iw = center(2);
tmp1 = spCnt(:,2) - repmat(iw, nSp,1);% x
ww = exp( -tmp1.^2/(ratio*rectmn(1).^2) );

ih = center(1);
tmp2 = spCnt(:,1) - repmat(ih, nSp,1);% x
wh = exp( -tmp2.^2/(ratio*rectmn(2).^2) );

cueImgCnt = ww.*wh;    


