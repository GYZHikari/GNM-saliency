function normal_prior = normal(prior)

min_prior = min(prior(:));
normal_prior=(prior-min_prior)/(max(prior(:))-min_prior);