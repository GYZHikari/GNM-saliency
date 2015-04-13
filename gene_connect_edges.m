function edges = gene_connect_edges( spAdjacentMat,spnum,neg_label_inds,pos_label_inds, n_ring, opts)

connection_type = getoptions(opts,'connection_type','global');

if nargin < 7
    n_ring = 2;
end

spAffinityMat = spAdjacentMat;

%% compute 1-ring & 2-ring of superpixels
sp_num = size(spAffinityMat,1);
edges=[];
switch lower(connection_type)
    case 'local'
        for i=1:sp_num
            indext=[];
            ind=find(spAffinityMat(i,:)==1);
            
            % this for is for 2-ring
            if n_ring == 2
                for j=1:length(ind)
                    indj=find(spAffinityMat(ind(j),:)==1);
                    indext=[indext,indj];
                end
            end
            
            indext=[indext,ind];
            indext=indext((indext>i));
            indext=unique(indext);
            if(~isempty(indext))
                ed=ones(length(indext),2);
                ed(:,2)=i;
                ed(:,1)=indext;
                edges=[edges;ed];
            end
        end
        
        %% attach addtional connection/edge
        edges1 = edges_between(neg_label_inds);
        edges2 = edges_between(pos_label_inds);
        edges = [edges; edges1; edges2];
    case 'global'
        connect_patch = 1:spnum;
        edges = edges_between(connect_patch');
end

function edges = edges_between(inds)
%
if isempty(inds)
    edges = [];
end

num = length(inds);
mat = tril(ones(num), -1);
[row, col] = find(mat);
edges = [inds(row), inds(col)];


