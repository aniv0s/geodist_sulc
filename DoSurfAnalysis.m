function[dpx, surf] = DoSurfAnalysis(species, hemi, type)
%
% To run (example): 
% [dpx, surf] = DoSurfAnalysis('ferret', 'left', 'ply');
% [dpx, surf] = DoSurfAnalysis('slow_loris', 'right', 'stl');

addpath('/a/software/matlab/extensions/fieldtrip/currentversion/public/');
addpath('./geodesic');
addpath('./areal/share');
addpath('./surfstat');

% Import data:
switch type
    case 'ply'
        [vert, faces] = read_ply(['../surfaces2/' species '/' hemi '.ply']);
        vertices(:,1) = vert.x;
        vertices(:,2) = vert.y;
        vertices(:,3) = vert.z;
        
    case 'stl'
        [vertices,faces] = read_stl(['../surfaces2/' species '/' hemi '.stl']);
        [vertices, ~, ind] = unique(vertices, 'rows', 'stable');
        faces = ind(faces);
end

% % remove nodes with only one edge :
% for rem = 1
%     freq = histc(reshape(faces, [prod(size(faces)) 1]),unique(faces));
%     remove = find(freq == rem);
%     index1 = ismember(faces(:,1),remove);
%     index2 = ismember(faces(:,2),remove);
%     index3 = ismember(faces(:,3),remove);
%     index = index1 + index2 + index3;
%     facesN = faces(index == 0,:);
%     [incld, ~, r2] = unique(facesN);
%     new = 1:length(incld);
% 
%     % reorder
%     vertices = vertices(incld,:);
%     faces = reshape(new(r2), size(facesN));
% end

freq = histc(reshape(faces, [prod(size(faces)) 1]),unique(faces));
surf.tri = faces;
surf.coord = vertices';
data = zeros(length(vertices),1);
for i = 1:max(freq)
    data(find(freq == i)) = i;
end
data = zeros(length(vertices),1);
data(find(freq == 3)) = 3;
source = find(freq == 3);


%% Run Geodesic
N = length(vertices);
% Run 
global geodesic_library;                
geodesic_library = 'libgeodesic';
mesh = geodesic_new_mesh(vertices,faces);
algorithm = geodesic_new_algorithm(mesh, 'exact');
source_points = {};
s = source';
for vertex_id = s;
    source_points{end+1} = geodesic_create_surface_point('vertex',vertex_id, vertices(vertex_id,:));
end;
geodesic_propagate(algorithm, source_points);
distances = zeros(N,1); source_ids = zeros(N,1);
for i=1:N   
    q = geodesic_create_surface_point('vertex',i,vertices(i,:));
    [source_ids(i), distances(i)] = geodesic_distance_and_source(algorithm, q);    
end;
geodesic_delete;

%% Save output
srfwrite(vertices,faces,['../surfaces2/' species '/' hemi '.srf']);
[vtx,fac] = srfread(['../surfaces2/' species '/' hemi '.srf']);
dpxwrite(['../surfaces2/' species '/' hemi '_distance.dpv'], distances, vtx, 1:length(vtx));
dpx2map(['../surfaces2/' species '/' hemi '_distance.dpv'], ['../surfaces2/' species '/' hemi '.srf'], ['../surfaces2/' species '/' hemi '_distance'], 'jet');

% To read back data:
[dpx,crd,idx] = dpxread(['../surfaces2/' species '/' hemi '_distance.dpv']);
% dpx is the data


