function flatPlateSettingStruct = loadFlatPlateSettings(excelFilePath)
%loadNastranSettings Structure with settings for the generation of the
%Nastran model.
%   nastranSettingStruct = loadNastranSettings(excelInputName) reads the
%   input excel file and retrieve the user specified settings for the
%   generation of the Nastran model. An output structure is created adding
%   also an automatic name of the nastran model and the initial ids of the
%   various nastran cards.

% Get geometrical parameters
numericDataArray = xlsread(excelFilePath,'Geometry');
span = numericDataArray(1);         % [m]
chord = numericDataArray(2);        % [m]
thickness = numericDataArray(3);    % [m]
clampHeight = numericDataArray(4);  % [m]
clampWidth = numericDataArray(5);   % [m]

% Get material properties
numericDataArray = xlsread(excelFilePath,'Material');
e = numericDataArray(1);    % Young Modulus [Pa]
g = numericDataArray(2);    % Shear Modulus [Pa]
nu = numericDataArray(3);   % Poisson Ratio
rho = numericDataArray(4);  % Density [kg/m^3]

% Get load case definition
numericDataArray = xlsread(excelFilePath,'LoadCase');
staticLoadCaseVelocity = numericDataArray(1,1);     % [m/s]
staticLoadCaseAlpha = numericDataArray(2,1);        % [deg]
gustLoadCaseType = numericDataArray(1,end);
gustLoadCaseFrequency = numericDataArray(2,end);    % [Hz]
gustLoadCaseDeltaAlpha = numericDataArray(3,end);   % [deg]
gustLoadCaseCutOffFrequency = numericDataArray(4,end);  % [Hz]

% Get discretization settings
numericDataArray = xlsread(excelFilePath,'Discretization');
structuralEdgeSize = numericDataArray(1);   % [m]
aerodynamicEdgeSize = numericDataArray(2);  % [m]

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
flatPlateSettingStruct = struct(...
    'name',matlab.lang.makeValidName(sprintf(...
    'span%.3fmChord%dmmThickness%.1fmm',...
    span,chord*1e3,thickness*1e3)),...
    'structuralEdgeSize',structuralEdgeSize,...
    'aerodynamicEdgeSize',aerodynamicEdgeSize,...
    'span',span,...
    'chord',chord,...
    'thickness',thickness,...
    'clampHeight',clampHeight,...
    'clampWidth',clampWidth,...
    'e',e,...
    'g',g,...
    'nu',nu,...
    'rho',rho,...
    'staticLoadCaseVelocity',staticLoadCaseVelocity,...
    'staticLoadCaseAlpha',staticLoadCaseAlpha,...
    'gustLoadCaseType',gustLoadCaseType,...
    'gustLoadCaseFrequency',gustLoadCaseFrequency,...
    'gustLoadCaseDeltaAlpha',gustLoadCaseDeltaAlpha,...
    'gustLoadCaseCutOffFrequency',gustLoadCaseCutOffFrequency,...
    'lastGridId',lastGridId,...
    'lastElementId',lastElementId,...
    'lastPropertyId',lastPropertyId,...
    'lastMaterialId',lastMaterialId,...
    'lastSetId',lastSetId,...
    'lastCoordinateId',lastCoordinateId,...
    'lastTableId',lastTableId);
end
