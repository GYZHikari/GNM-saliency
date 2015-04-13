function color_prior = color_contrast(sp_center, sp_fea,sp_npix, theta,m ,n)
% SF method color contrast prior map
% GuangyuZhong 2014/2/24

    sp_center(:,1) = sp_center(:,1)./m;
    sp_center(:,2) = sp_center(:,2)./n;

    loc_dis = dist(sp_center');
    loc_dis = exp(-loc_dis/(2*theta.^2)); 
    lab_dis = dist(sp_fea');
    number = repmat(sp_npix', size(sp_center,1), 1);
    color_prior = sum(lab_dis.*loc_dis.*number, 2);
    