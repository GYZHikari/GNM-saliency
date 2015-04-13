function [affmat,P] = gene_affmat(edges, spnum, sp_center,sp_fea, opts)
% Guangyu Zhong  13/12/08
%

guass = getoptions(opts, 'guass', 1);

affmat = zeros(spnum,spnum);

row = edges(:,1); col = edges(:,2);
ind = sub2ind(size(affmat), row, col);

similarity_type = getoptions(opts,'similarity_type','similar');
feat_dist_opt = getoptions(opts, 'feat_dist_opt', 'MVSSER');
if ~isstruct(sp_fea)
    feat_dist_opt = 'MVSSER';
end
switch feat_dist_opt
    case 'MVSSER'
        % feature
        tmp = sum( (sp_fea(row,:) - sp_fea(col,:)).^2, 2);
        valDistances = sqrt(tmp)+eps;
    case 'SDMVC'
        bin = fix((256-0.1)/sp_fea.binnum);
        sp_fea.R = (sp_fea.R+1).*bin;
        sp_fea.G = (sp_fea.G+1).*bin;
        sp_fea.B = (sp_fea.B+1).*bin;
        [L,a,b] = RGB2Lab(sp_fea.R,sp_fea.G,sp_fea.B);
        tmp = patch_distance(sp_fea.pixelNumRGB,L,a,b,sp_fea.colorNumEachPatch, opts.npix, length(opts.npix));
        valDistances = tmp(ind)+eps;
    otherwise
        warning('not implement!');
end

minVal = min(valDistances);
valDistances=(valDistances-minVal)/(max(valDistances)-minVal);
switch  lower(similarity_type)
    case 'dissimilar'
        weights = exp(valDistances/max(valDistances));
    case 'similar'
        weights = exp(-valDistances/max(valDistances));
    case 'aff_similar'
        weights = exp(-10*valDistances);
    otherwise
        warning('not implement!!')
end

if  guass
    max_dist_ratio_sp = getoptions(opts, 'max_dist_ratio_sp', 1.0);
    tmp = sqrt( sum( (sp_center(row,:) - sp_center(col,:)).^2, 2));
    w = exp( -tmp.^2/(max_dist_ratio_sp * max(tmp).^2) );  % guass
else
    w = ones(numel(row),1);
end

affmat(ind) = weights.*w;
ind = sub2ind(size(affmat), col, row);
affmat(ind) = weights.*w;

P = affmat - diag(diag(affmat));
P = diag(1.0./sum(P,2))*P;



