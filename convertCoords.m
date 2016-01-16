function[ indVal ] = convertCoords(orig_coord, new_coord)

new_coord(1,:) = new_coord(1,:) .* -1;
new_coord(2,:) = new_coord(2,:) .* -1;

for i = 1:length(orig_coord)
    [minVal(i), indVal(i)] = min(sum(abs(bsxfun(@minus,orig_coord(:,i),new_coord)).^2).^0.5);
    disp(i);
end

% sdepth_new = sdepth(indVal); 
% figure; SurfStatView(sdepth_new,fsa_reg);