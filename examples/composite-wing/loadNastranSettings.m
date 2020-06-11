function nastranSettingStruct = loadNastranSettings(excelFilePath)
%loadNastranSettings Structure with settings for the generation of the
%Nastran model.
%   nastranSettingStruct = loadNastranSettings(excelInputName) reads the
%   input excel file and retrieve the user specified settings for the
%   generation of the Nastran model. An output structure is created adding
%   also an automatic name of the nastran model and the initial ids of the
%   various nastran cards.

% Get Nastran settings from excel sheet
numericDataArray = xlsread(excelFilePath,'NastranSettings');
% If only two values are found, then assume no flange
if length(numericDataArray)==3
    flangeSize = numericDataArray(1);           % [m]
    structuralEdgeSize = numericDataArray(2);   % [m]
    aerodynamicEdgeSize = numericDataArray(3);  % [m]
else
    flangeSize = 0;                             % [m]
    structuralEdgeSize = numericDataArray(1);   % [m]
    aerodynamicEdgeSize = numericDataArray(2);  % [m]
end

% Get ribs information from excel sheet
numericDataArray = xlsread(excelFilePath,'NastranRibsModelling');
el = numericDataArray(1,1)*1e9;                 % [Pa]
et = numericDataArray(2,1)*1e9;                 % [Pa]
glt = numericDataArray(3,1)*1e9;                % [Pa]
nult = numericDataArray(4,1);
rho = numericDataArray(5,1);                    % [kg/m^3]
t = numericDataArray(6,1)*1e-3;                 % [m]
plyOrientationVector = numericDataArray(:,3);   % [deg]

% Generate NastranIdCounter object for all the id types needed for the
% nastran model
lastGridId = NastranIdCounter;
lastElementId = NastranIdCounter;
lastPropertyId = NastranIdCounter;
lastMaterialId = NastranIdCounter;
lastSetId = NastranIdCounter;
lastCoordinateId = NastranIdCounter;
lastTableId = NastranIdCounter;

% Generate output structure
nastranSettingStruct = struct(...
    'name',sprintf('StructEdge%dmmAeroEdge%dmm',...
    round(structuralEdgeSize*1e3),round(aerodynamicEdgeSize*1e3)),...
    'flangeSize',flangeSize,...
    'structuralEdgeSize',structuralEdgeSize,...
    'aerodynamicEdgeSize',aerodynamicEdgeSize,...
    'ribsModelling',struct(...
    'el',el,...
    'et',et,...
    'glt',glt,...
    'nult',nult,...
    'rho',rho,...
    'thickness',t,...
    'orientationVector',...
    plyOrientationVector(~isnan(plyOrientationVector))),...
    'lastGridId',lastGridId,...
    'lastElementId',lastElementId,...
    'lastPropertyId',lastPropertyId,...
    'lastMaterialId',lastMaterialId,...
    'lastSetId',lastSetId,...
    'lastCoordinateId',lastCoordinateId,...
    'lastTableId',lastTableId);
end
