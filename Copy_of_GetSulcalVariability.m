function [sulc, curv] = GetSulcalVariability()
% first: addpath ('/scr/hugo1/brain_catalogue/sulcal_variability/gifti-1.5/')

List = dir('/a/documents/connectome/_all/');

for i = 1:length(List)-2
    subList(i,:) = List(i+2).name;
end

surf1 = gifti('/scr/hugo1/brain_catalogue/scripts/topography/data/Q1-Q6_R440.L.midthickness.32k_fs_LR.surf.gii');
surf.tri = surf1.faces; surf.coord = surf1.vertices';
surf.tri = surf.tri';
surf = surfGetNeighbors(surf);
surf.tri = surf.tri';

% grab resting state data
dim = 32492;
curv = [];
sulc = [];
dir1 = ['/a/documents/connectome/_all/'];
for i = 1:length(subList)
    filename = [dir1 num2str(subList(i,:)) '/MNINonLinear/fsaverage_LR32k/' num2str(subList(i,:)) '.L.sulc.32k_fs_LR.shape.gii'];            			
    if exist(filename, 'file')
        disp(filename);
        d = gifti(filename);        
        sulc = [sulc d.cdata];
    end       
    filename = [dir1 num2str(subList(i,:)) '/MNINonLinear/fsaverage_LR32k/' num2str(subList(i,:)) '.L.curvature.32k_fs_LR.shape.gii'];            			
    if exist(filename, 'file')
        disp(filename);
        d = gifti(filename);        
        curv = [curv d.cdata];
    end      
end

DoFlatten(sulc, 'sulc', 'scalar_left', '32');
DoFlatten(curv, 'curv', 'scalar_left', '32');
