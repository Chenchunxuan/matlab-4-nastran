function applyFlatPlateClamp(nastranBulkData,flatPlateSettingStruct)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Get the vector of Grid object in the position corresponding to the clamp
clampGridPointVector = nastranBulkData.GridArray(...
    [nastranBulkData.GridArray.X1]>=...
    (flatPlateSettingStruct.chord-flatPlateSettingStruct.clampWidth)/2 &...
    [nastranBulkData.GridArray.X1]<=...
    (flatPlateSettingStruct.chord-flatPlateSettingStruct.clampWidth)/2+...
    flatPlateSettingStruct.clampWidth &...
    [nastranBulkData.GridArray.X3]<=flatPlateSettingStruct.clampHeight);
% Generate Spc1 objcet
spc1 = Spc1(struct('sid',nastranBulkData.LastSetId.addId,...
    'c',123456,...
    'gridVector',clampGridPointVector));

%% Assign generated objects to NastranBulkData object
nastranBulkData.Spc1Array = [nastranBulkData.Spc1Array;spc1];
end
