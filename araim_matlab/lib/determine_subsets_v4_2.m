% ********************************************************************************************
% Author: Diego Lopez Rodrigo                                                                *
% Year: 2024                                                                                 *
% Location: The Netherlands                                                                  *
% Publication: Development and Implementation of an Advanced Receiver Autonomous             *
% Integrity Monitoring algorithm using Galileo and GPS - (Universidad Politécnica de Madrid) *
% ********************************************************************************************


function  [subsets, pap_subset_texp, pap_subset_multiplier, p_not_monitored] = determine_subsets_v4_2(G, p_sat, p_const, gps_idx, gal_idx, p_thres, fc_thres)
%DETERMINE_SUBSETS_V4_2 Returns the fault modes to be monitored, in the
%form of a vector indicating which satellites in the mode are not faulted.

global TEXP_INT 
global ARAIM_MFD_SAT_GPS ARAIM_MFD_SAT_GAL
global ARAIM_MFD_CONST_GPS ARAIM_MFD_CONST_GAL
global PHMI

Nsat = size(G,1);
Nconst = size(G,2)-3;

svconst = [(~isempty(gps_idx)) (~isempty(gal_idx))];
%multipliers to convert instant event probabilities to probabilities along 
%Time of Exposition
texp_sat_multiplier = (1+TEXP_INT./ [...
    ones(length(gps_idx),1)*ARAIM_MFD_SAT_GPS; ...
    ones(length(gal_idx),1)*ARAIM_MFD_SAT_GAL]);
texp_const_multiplier = (1+TEXP_INT./ [...
    ones(svconst(1),1)*ARAIM_MFD_CONST_GPS; ...
    ones(svconst(2),1)*ARAIM_MFD_CONST_GAL]);

%Compute probability of single events during Time of Exposition (Texp_int)
p_sat_texp = p_sat.*texp_sat_multiplier;
p_const_texp = p_const.*texp_const_multiplier;

%Compute probability of no fault over Time of Exposition (Texp_int)
pnofault = prod(1-p_sat)*prod(1-p_const);
p_no_fault_texp = prod(1-min(1,p_sat_texp))*prod(1-min(1,p_const_texp));

%Initialize pnotmonitored
p_not_monitored = 1-p_no_fault_texp;

% Determine maximum of simultaneous events to be monitored, to meet Eq. 23
% ADDv4.2. With this obtain the size of the set of modes to be monitored.
nevent_max = determine_nmax([p_sat;p_const],p_thres, gps_idx, gal_idx);
subsetsize =0;
for j=0:nevent_max
    subsetsize = subsetsize + nchoosek(Nconst+Nsat,j);
end

subsets_ex = zeros(subsetsize,Nsat+Nconst);
subsets_ex(1,:) = zeros(1,Nsat+Nconst); %subset corresponding to the all-in-view
pap_subset = zeros(subsetsize,1);
pap_subset(1) = 1;
pap_subset_texp = zeros(subsetsize,1);
pap_subset_texp(1) = 1;
pap_subset_multiplier = ones(subsetsize,1);
%Initialize k (number of simultaneous faults) and subset index j
k =0;
j = 1;

while (k<=Nsat)&&(p_not_monitored>p_thres)
    k=k+1;
    subsets_k = determine_k_subsets(Nsat+Nconst,k);
    subsets_k_texp_multiplier = 1 + subsets_k * (TEXP_INT./ [...
        ones(length(gps_idx),1)*ARAIM_MFD_SAT_GPS; ...
        ones(length(gal_idx),1)*ARAIM_MFD_SAT_GAL; ...
        ones(svconst(1),1)*ARAIM_MFD_CONST_GPS; ...
        ones(svconst(2),1)*ARAIM_MFD_CONST_GAL]);

    %Instantaneous fault probabilities a-priori
    pap_subsets_k = prod(subsets_k*diag([p_sat;p_const]) + ...
        (1-subsets_k)*diag([1-p_sat;1-p_const]),2);
    %Fault probabilities a-priori over Time of Exposition (Texp)
    pap_subsets_texp_k = prod(subsets_k*diag([p_sat;p_const]) + ...
        (1-subsets_k)*diag([1-p_sat;1-p_const]),2) .* ...
        subsets_k_texp_multiplier;
    
    %sort subsets by decreasing probability
    [p_subsets_k_s, index_k_s]=sort(pap_subsets_texp_k,1,'descend');
    subsets_k_s = subsets_k(index_k_s,:);
    pap_subsets_k = pap_subsets_k(index_k_s,:);
    subsets_k_texp_multiplier = subsets_k_texp_multiplier(index_k_s,:);
    
    n_k = size(subsets_k,1);
    h=1;
    %Faults exceeding PHMI probability must be monitored
    while (h<=n_k) && ( (p_not_monitored>p_thres) || p_subsets_k_s(h)>PHMI )
        if p_subsets_k_s(h)>0
         j=j+1;
         subsets_ex(j,:) = subsets_k_s(h,:);
         pap_subset_texp(j) = p_subsets_k_s(h);
         pap_subset(j) = pap_subsets_k(h);
         pap_subset_multiplier(j) = subsets_k_texp_multiplier(h);
         p_not_monitored = p_not_monitored - pap_subset_texp(j);
        end
        h=h+1;
    end
end
subsets_ex = subsets_ex(1:j,:);
pap_subset_texp = pap_subset_texp(1:j);
pap_subset = pap_subset(1:j);
pap_subset_multiplier = pap_subset_multiplier(1:j);


%Transform Nsat+Nconst subset vector in Nsat subset vector
subsets_const = subsets_ex(:,Nsat+1:Nsat+Nconst) * G(:,4:(3+Nconst))';
subsets_sat  = min(subsets_ex(:,1:Nsat) + subsets_const ,1); 


%subset consolidation
kk=0;
for  jj=1:length(svconst)
if svconst(jj)
    kk = kk+1;
    %find subset corresponding to only constellation jj wide fault first
    id_const_c=find((sum(subsets_ex(:,1:Nsat),2)==0).*...
        (sum(subsets_ex,2)==1).*(subsets_ex(:,Nsat+kk)==1));
    
    %If the constellation wide fault is part of the monitored set
    if id_const_c

    %find subsets that include the constellation fault or satellites within
    %only that constellation    
    index_cs = find(((subsets_sat*subsets_sat(id_const_c,:)')>0).*...
    ((subsets_sat*(1-subsets_sat(id_const_c,:))')<=0));

    else

    %find subsets that include the constellation fault or satellites within
    %only that constellation
    const_mask = [[ones(1,length(gps_idx)) zeros(1,length(gal_idx))]; ...
        [zeros(1,length(gps_idx)) ones(1,length(gal_idx))]];

    index_cs = find(((subsets_sat*const_mask(jj,:)')>0).*...
        ((subsets_sat*(1-const_mask(jj,:)'))<=0));
    
    end

    %sort subsets by decreasing probability
    [p_subsets_s, index_s]=sort(pap_subset(index_cs),1,'descend');
    subsets_sat_s = subsets_sat(index_cs,:);
    subsets_sat_s = subsets_sat_s(index_s,:);

    %Check inequality condition Eq.27 ADDv4.2
    prob_const_ineq = fc_thres*p_const(kk);
    n_k = size(subsets_sat_s,1);
    h=1;
    p_consolidate = 0;
    while (h<=n_k) && ( (p_consolidate<prob_const_ineq) )
        p_consolidate = p_consolidate+p_subsets_s(h);
        h=h+1;
    end
    
    idrmv    = index_cs(index_s(1:h-1));

    %remove from the list and add probability to constellation wide fault   
    if id_const_c
    
        p_not_monitored=p_not_monitored + sum(pap_subset_texp(idrmv)) + ...
            pap_subset_texp(id_const_c);
        pap_subset_texp(id_const_c)=(p_const(kk)+sum(pap_subset(idrmv)))*...
            texp_const_multiplier(kk);
        p_not_monitored=p_not_monitored - pap_subset_texp(id_const_c);

    else

        p_not_monitored=p_not_monitored + sum(pap_subset_texp(idrmv));
        pap_subset_texp(end+1)=(p_const(kk)+sum(pap_subset(idrmv)))*...
            texp_const_multiplier(kk);
        subsets_sat(end+1,:)=const_mask(jj,:);
        p_not_monitored=p_not_monitored - pap_subset_texp(end);
        pap_subset_multiplier(end+1,:)=texp_const_multiplier(kk);
    
    end
    
    idnew = setdiff(1:length(pap_subset_texp),idrmv);
    
    pap_subset_texp = pap_subset_texp(idnew);
    pap_subset_multiplier = pap_subset_multiplier(idnew);
    subsets_sat = subsets_sat(idnew,:);
end
end

subsets = 1 - subsets_sat;

end

