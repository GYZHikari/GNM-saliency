function [pfeats,rgb_fea] = gene_feature(img, spImg, sp_center, sp_npix, options)
% function pfeats = extract_sp_feats(img, cntSp, spImg, options)
% spImg           : Superpixel image 
% options.featMode : method for computing patch features. 
%            1: iccv11_Distributed Cosegmentation via Submodular Optimization on Anisotropic Diffusion, just color
%            2: iccv11_Distributed Cosegmentation via Submodular Optimization on Anisotropic Diffusion, color + texture
%
% jjcao @ 2013

featMode = getoptions(options, 'featMode', 1);
pixelNumEachPatch = sp_npix;
  
%% feature type
sp_num = size(sp_center,1);
switch featMode
    case 1
        [pfeats, rgb_fea] = extract_feat_segment_1(img, spImg, sp_num, 0);          
    case 2
        [lab_fea, rgb_fea, txt_fea] = extract_feat_segment_1(img, spImg, sp_num, 1);
        pfeats = [lab_fea txt_fea];
end

end

function [lab_fea, rgb_fea, txt_fea] = extract_feat_segment_1(input_im, superpixels, sp_num, textMode)
% compute the feature (mean color in lab color space)
% for each node (superpixels)
% lab_fea -- LAB feature for each superpixel
[m,n,k] = size(input_im);

input_vals=reshape(input_im, m*n, k);
rgb_vals=zeros(sp_num,1,3);
for i=1:sp_num
    tmp = find(superpixels==i);
    rgb_vals(i,1,:) = mean(input_vals(tmp,:),1);
end
lab_vals = colorspace('Lab<-', rgb_vals);
lab_fea=reshape(lab_vals,sp_num,3);% feature for each superpixel
rgb_fea=reshape(rgb_vals,sp_num,3);

if textMode
    if size(input_im, 3)==3
        img_f = rgb2gray(input_im);
    end
    img_texton = MRS4fast(imfilter(img_f, fspecial('gaussian', 3, 1))) ; 
    
    TspImg = superpixels(:) ;
    txt_fea = mex_get_desc_mean_segm(TspImg, img_texton, sp_num) ;% compute the mean of texture descriptors of each segment
else
    txt_fea = [];
end
end