function [pl, alloc] = compute_protection_level_v4_2(sigma, threshold_plus_bias, pfault, phmi, pl_tol)
%COMPUTE_PROTECTION_LEVEL_V4.2
%sigma is a matrix of size (nsets,3) corresponding to the 3 ENU components
%alloc is the vector of corresponding allocations normcdf((threshold_plus_bias - pl)./sigma) 

global NITER   %maximum number of iterations

alloc = Inf(length(sigma),1);


%%%% Exclude sigmas that are infinite and evaluate their integrity contribution
index_Inf = find(sigma == Inf);
index_fin = setdiff(1:length(sigma),index_Inf);
p_not_monitorable = sum(pfault(index_Inf));

if p_not_monitorable>=phmi    
    pl = Inf;
    alloc = zeros(length(sigma),1);
else
    sigma = sigma(index_fin);
    threshold_plus_bias = threshold_plus_bias(index_fin);
    pfault = pfault(index_fin);
    phmi = phmi - p_not_monitorable;

    %alloc max is the maximum necessary allocation
    alloc_max = ones(length(sigma),1);

    %determine lower bound on PL
    Klow=-norminv(min(1,phmi./(pfault.*alloc_max)));
    pl_low=max(threshold_plus_bias + Klow.*sigma);

    %determine upper bound on PL
    Khigh = max(0,-norminv(phmi./(length(sigma)*pfault)));
    pl_high=max(threshold_plus_bias + Khigh.*sigma);

    %compute logarithm of phmi
    log10phmi=log10(phmi);

    count=0;
    while ((pl_high-pl_low>pl_tol)&&(count<NITER))
        count = count+1;
        pl_half = (pl_low+pl_high)/2;
        cdfhalf = log10(sum(pfault.*min(modnormcdf((threshold_plus_bias-pl_half)./sigma),alloc_max)));
        if cdfhalf>log10phmi
           pl_low = pl_half;
        else
           pl_high = pl_half;
        end
    end

   pl = pl_high;
   alloc(index_fin) = min(modnormcdf((threshold_plus_bias-pl)./sigma),alloc_max);

end