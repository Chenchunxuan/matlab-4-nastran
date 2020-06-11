function applyDisplacement(nastranBulkData,gridPoint,componentNo,...
    enforcedMotion)
%applyDisplacement Summary of this function goes here
%   Detailed explanation goes here

% Generate Spcd object for bulk data
nastranBulkData.Spcd = Spcd(struct(...
    'sid',nastranBulkData.LastSetId.addId,...
    'gridVector',gridPoint,...
    'ci',componentNo,...
    'di',enforcedMotion));
end
