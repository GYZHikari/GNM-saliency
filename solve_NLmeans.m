function [u_new_nlm] = solve_NLmeans(aff_mat, prior_source)

D = sum(aff_mat,2);
nD = diag(1./ D);

W = nD * aff_mat;

u_new_nlm = W * prior_source;

end

