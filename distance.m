function[surf al am distances_al distances_am distances_all zones_all vertices faces] = distance(species, hemi)

%to run example: distance('ferret', 'right')

addpath('/a/software/matlab/extensions/fieldtrip/currentversion/public/');
addpath('./geodesic');
addpath('./areal/share');
addpath('./surfstat');

[vert, faces] = read_ply(['../surfaces/' species '/' hemi '.ply']);
vertices(:,1) = vert.x;
vertices(:,2) = vert.y;
vertices(:,3) = vert.z;
surf.tri = faces;
surf.coord = vertices';
x = size(vert.x);

%% med geodesic
rawmask = load(['../surfaces/' species '/' hemi '_mask_med.1D.roi']);
mask_med = rawmask(:,1);
am = zeros(x(1),1);
am(mask_med + 1) = 1;
N = length(vertices);
% Run 
global geodesic_library;                
geodesic_library = 'libgeodesic';
mesh = geodesic_new_mesh(vertices,faces);
algorithm = geodesic_new_algorithm(mesh, 'exact');
source_points = {};
s = find(am)';
for vertex_id = s;
    source_points{end+1} = geodesic_create_surface_point('vertex',vertex_id, vertices(vertex_id,:));
end;
geodesic_propagate(algorithm, source_points);
[~, distances_am] = geodesic_distance_and_source(algorithm);    
geodesic_delete;


%% lat geodesic

rawmask = load(['../surfaces/' species '/' hemi '_mask_lat.1D.roi']);

mask_lat = rawmask(:,1);
al = zeros(x(1),1);
al(mask_lat + 1) = 1;
N = length(vertices);
%Run
global geodesic_library;                
geodesic_library = 'libgeodesic';
mesh = geodesic_new_mesh(vertices,faces);
algorithm = geodesic_new_algorithm(mesh, 'exact');
source_points = {};
s = find(al)';
for vertex_id = s;
    source_points{end+1} = geodesic_create_surface_point('vertex',vertex_id, vertices(vertex_id,:));
end;
geodesic_propagate(algorithm, source_points);
[~, distances_al] = geodesic_distance_and_source(algorithm);    
geodesic_delete;



[distances_all, zones_all] = min([distances_am distances_al]', [],1);
% finds the indices of the minimum values in each column of a matrix [distances_am distances_al]' and returns them in output row vector I, 
% using any of the input arguments in the previous syntaxes. If the minimum value occurs more than once, 
%then min returns the index corresponding to the first occurrence. (??)

% Then save outputs distances_all and zones_all as dpx files like
% before....

%save(['./' species '_' hemi '.mat'], '-v7.3', 'distances_all');
%save(['./' species '_' hemi '.mat'], '-v7.3', 'zones_all');

%[surf al am distances_al distances_am distances_all zones_all] = distance('ferret', 'right');
%figure; SurfStatView(zones_all,surf);

% To make Anastasia's colorbar
% rescale each zone and flip values within zone
%increase = 15;
%for i = 1:2
%    a = distances_all(find(zones_all == i));
%    a = -1 .* (1 - (a ./ (max(a) + (max(a)/increase))));
%    distances_all(find(zones_all == i)) = a;
%end
% flips one zone to negative values:
%distances_all(find(zones_all == 1)) = distances_all(find(zones_all == 1)) .* -1;

% To get the original:
%distances_all = abs(distances_all);

%% Save output
%srfwrite(vertices,faces,['../surfaces/' species '/' hemi '_all.srf']);
%[vtx,fac] = srfread(['../surfaces/' species '/' hemi '_all.srf']);
%dpxwrite(['../surfaces/' species '/' hemi '_distance_all.dpv'], distances_all, vtx, 1:length(vtx));
%dpx2map(['../surfaces/' species '/' hemi '_distance_all.dpv'], ['../surfaces/' species '/' hemi '_all.srf'], ['../surfaces/' species '/' hemi '_distance_all'], 'jet');
%dpxwrite(['../surfaces/' species '/' hemi '_zones_all.dpv'], zones_all, vtx, 1:length(vtx));
%dpx2map(['../surfaces/' species '/' hemi '_zones_all.dpv'], ['../surfaces/' species '/' hemi '_all.srf'], ['../surfaces/' species '/' hemi '_zones_all'], 'jet');



% To read back data:
%[dpx,crd,idx] = dpxread(['../surfaces/' species '/' hemi '_distance_all.dpv']);
% dpx is the data


