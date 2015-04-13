%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------------------------------------------
% A brief implementation for the paper : 
% A generalized nonlocal mean framework with object-level
% cues for saliency detection.
% Author: Guangyu Zhong, Guangyuzhonghikari@gmail.com
%----------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear all;
DEBUG =1; 

%% gene dir and file name
imdir = '.\img\input\';
spdir = '.\img\output\superpixels\';
saldir = '.\img\output\saliencymap\';
odir ='.\img\obj\';
imnames=dir([imdir '*' 'bmp']);
onames = dir([odir '*' 'txt']);
graphOpts.featMode=1;
graphOpts.guass = 0;
graphOpts.connection_type = 'local';
graphOpts.similarity_type = 'aff_similar';
sp_num_max = 200;
theta = 0.40;
alpha = 0.99;
addback = 1;
lambda = 10;
background = 0;
bw_backprior = 0;
bwmap = 0;

for ii=1:1
    close all;    clear w;
    oname = onames(ii).name
    fid = fopen([odir oname],'rt');
    obj =textscan(fid,'%s','headerLines',1,'Delimiter',',');
    obj = str2double(obj{1});
    obj = reshape(obj, 5,numel(obj)/5)';
    fclose('all');
    imname = [oname(1:end-4), '.bmp'];
    [input_im1] = imread([imdir, imname]);
    if size(input_im1,3)==1
        input_im2(:,:,1) = input_im1;
        input_im2(:,:,2) = input_im1;
        input_im2(:,:,3) = input_im1;
        input_im1 = input_im2;
    end
    [input_im,w]=remove_frame([imdir, imname]);
    imname = [imname(1:end-4), '.bmp'];
    [m,n,k] = size(input_im);
    
    %% generate superpixels
    [superpixels, spAdjcMat, sp_inds, sp_center, sp_npix] = gene_superpixel(imdir, imname, sp_num_max, spdir, m, n);
    graphOpts.npix = sp_npix;
    sp_num = size(spAdjcMat,1);
    %% Extract features from each SP
    [sp_fea, rgb_fea]  = gene_feature(input_im, superpixels, sp_center, sp_npix, graphOpts);
    min_sp_fea = min(sp_fea(:));
    sp_fea=(sp_fea-min_sp_fea)/(max(sp_fea(:))-min_sp_fea);
    %% compute 3 priors: location, color & background
    %% location
    objNum =3;
    opt = 'start';
    [obj, img,selobjnum] = gene_obj_rectangle(input_im, odir,saldir, oname, objNum);
    
    centers(:,2) = (obj(1:selobjnum,2) + obj(1:selobjnum,4))./2;
    centers(:,1) = (obj(1:selobjnum,3) + obj(1:selobjnum,5))./2;
    rect_mn(:,2) = abs(obj(1:selobjnum,3) - obj(1:selobjnum,5))./2;
    rect_mn(:,1) = abs(obj(1:selobjnum,2) - obj(1:selobjnum,4))./2;
    centerprior = zeros(sp_num,1);
    obj(:,1) = normal(obj(:,1));
    ratio = 0.3;
    for objnn = 1:selobjnum
        [center_prior] = cue_by_select_center(centers(objnn,:),sp_center,ratio, rect_mn(objnn,:));
        center_prior = normal(center_prior);
        centerprior = (center_prior*(obj(objnn,1)).^2)+ centerprior;
    end
    clear centers rect_mn;
    center_prior = centerprior;
    center_prior = normal(center_prior);
    center_prior_img = superpixel2img(center_prior, superpixels);
    center_prior_img = add_frame(center_prior_img, w);
    outname = [saldir imname(1:end-4)  '_center.bmp'];
    imwrite(center_prior_img, outname);
    
    %% color prior
    color_prior = color_contrast(sp_center, sp_fea, sp_npix,theta, m, n);
    min_color_prior = min(color_prior(:));
    color_prior=(color_prior-min_color_prior)/(max(color_prior(:))-min_color_prior);
    color_prior_img = superpixel2img(color_prior, superpixels);
    outname = [saldir imname(1:end-4)  '_color.bmp'];
    imwrite(color_prior_img, outname);
    %% fore prior
    fore_prior = center_prior.*color_prior;
    bd=unique([superpixels(1,:),superpixels(:,1)',superpixels(:,n)',superpixels(m,:)]);
    edges = gene_connect_edges( spAdjcMat,sp_num,bd',[], 2, graphOpts);
    [affmat] = gene_affmat(edges, sp_num, sp_center, sp_fea,graphOpts);
    back_ratio = 0.3;
    [index_top, index_down, index_left, index_right, bg_center,~] = gene_bound_rect(input_im,obj,saldir, oname,sp_center, sp_num, superpixels,back_ratio,DEBUG);
    bg_center = normal(bg_center);
    [back_sal] = solve_NLm_improve(affmat, bg_center, alpha);
    back_sal = 1-normal(back_sal);
    back_sal_img = superpixel2img(back_sal, superpixels);
    back_sal_img = add_frame(back_sal_img, w);
    outname = [saldir imname(1:end-4)  '_back.bmp'];
    imwrite(back_sal_img, outname);
    fore_prior = normal(fore_prior.*back_sal);
    [fore_sal] = solve_NLm_improve(affmat, fore_prior, alpha);
    
    fore_sal = normal(fore_sal);
    fore_sal_img = superpixel2img(fore_sal, superpixels);
    fore_sal_img = add_frame(fore_sal_img, w);
    outname = [saldir imname(1:end-4)  '_fore.bmp'];
    imwrite(fore_sal_img, outname);
    fore_prior_img = superpixel2img(fore_prior, superpixels);
    fore_prior_img = add_frame(fore_prior_img, w);
    myfilter = fspecial('gaussian',[5 5], 1);
    prior_img = imfilter(fore_prior_img, myfilter, 'replicate');
    outname = [saldir imname(1:end-4)  '_sal.bmp'];
    imwrite(prior_img, outname);
end

