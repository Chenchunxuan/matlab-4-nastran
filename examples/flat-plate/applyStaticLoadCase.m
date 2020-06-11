function applyStaticLoadCase(nastranBulkData,flatPlateSettingStruct)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Generate Aestat object
nastranBulkData.AestatArray = Aestat(struct(...
    'id',nastranBulkData.LastGridId.addId,...
    'label','ANGLEA'));
% Create input structure for Trim object
[~,a,~,rho] = atmosisa(0);
trimStruct = struct(...
    'sid',nastranBulkData.LastSetId.addId,...
    'mach',flatPlateSettingStruct.staticLoadCaseVelocity/a,...
    'q',0.5*rho*flatPlateSettingStruct.staticLoadCaseVelocity^2,...
    'labeli',nastranBulkData.AestatArray.Label,...
    'uxi',deg2rad(flatPlateSettingStruct.staticLoadCaseAlpha));
% Generate Trim object vector
nastranBulkData.TrimArray = Trim(trimStruct);
end
