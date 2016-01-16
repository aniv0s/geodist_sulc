addpath('./geodesic');
addpath('./areal/share');
addpath('./surfstat');
addpath('/a/software/matlab/extensions/fieldtrip/currentversion/public/');

load('sulcal_variability_distance_zones.mat')

distances_all= a;
zones_all = b;

increase = 15;
for i = 1:2
    w = distances_all(find(zones_all == i));
    w = -1 .* (1 - (w ./ (max(w) + (max(w)/increase))));
    distances_all(find(zones_all == i)) = w;
end
% flips one zone to negative values:
distances_all(find(zones_all == 1)) = distances_all(find(zones_all == 1)) .* -1;

figure; SurfStatView(sulc, fsa_reg, 'sulcal variability');
figure; SurfStatView(distancess_all, fsa_reg, 'geodesic distance');
colorbar
figure; plot(sulc, distance_all)
figure; SurfStatPlot(sulc, distances_all); title('r = 0.76');

%figure; SurfStatView(sulc, fsa_reg);
%figure; SurfStatView(a, fsa_reg);
%colorbar
%figure; plot(sulc, a)


%for i = mask
%    sdepth_new(i) = -7
%end