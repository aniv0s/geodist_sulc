function[] = DoBrainCatalogue(directory, surface, roiCingulate, roiInsula)
% Example: DoBrainCatalogue('../surfaces/slothbear/', 'split-brain_sloth-bear.inf.lh.mgh', 'split_bear_cing.lh.1D.roi', 'split_bear_ins.lh.1D.roi');

addpath('../surfstat');

surf = SurfStatReadSurf([directory surface]);
roiCing = load([directory roiCingulate];
roiIns = load([directory roiInsula]);
rIns = zeros([1 32492]);
rCing = zeros([1 32492]);
rIns(roiIns + 1) = 1;
rCing(roiCing + 1) = 1;

[geoDistIns] = surfGeoDist_orig(surf, rIns);
[geoDistCing] = surfGeoDist_orig(surf, rCing);

geoDist = ([geoDistIns; geoDistCing]);
[s ind] = sort(geoDist, 1);
lab = ind(1,:)';
edg = SurfStatEdg(surf);
labE = lab(edg);
border = unique([edg(find(eq(labE(:,1), labE(:,2)) == 0), 1); edg(find(eq(labE(:,1), labE(:,2)) == 0), 2)]);
mask = zeros([length(surf.coord) 1]);
mask(border) = 1;
geoDistL = s(1,:)';
geoDistL(find(mask)) = 0;

figure; SurfStatView(geoDistL, surf);