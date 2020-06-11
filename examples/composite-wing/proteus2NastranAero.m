function proteus2NastranAero(nastranBulkData,proteusDataStruct,...
    nastranSettingStruct)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Aero mesh parameters
chordVector = arrayfun(@(x) norm(...
    proteusDataStruct.constant.Coord3D.Wing_TE_xyz(x,:)-...
    proteusDataStruct.constant.Coord3D.Wing_LE_xyz(x,:)),...
    1:size(proteusDataStruct.constant.Coord3D.Wing_LE_xyz,1))';
span = proteusDataStruct.constant.general.span;
wingArea = proteusDataStruct.constant.general.planformArea;
meanAerodynamicChord = 2/wingArea*...
    trapz(proteusDataStruct.constant.Coord3D.Wing_TE_xyz(:,2),...
    chordVector.^2);

%% Generate Aeros object
nastranBulkData.AerosArray =...
    Aeros(struct('refc',meanAerodynamicChord,'refb',span,'refs',wingArea));

%% Generate Paero1 object
nastranBulkData.Paero1Array =...
    Paero1(struct('pid',nastranBulkData.LastPropertyId.addId));

%% Geneate Caero1 object
% Update last element id as the last node id, this is necessary to
% avoid conflict between aerodynamic and structural elements and nodes
nastranBulkData.LastElementId = NastranIdCounter(...
    nastranBulkData.LastGridId.IdNo);
% Iterate through the planform sections defined by the fixed points in
% Proteus
for i = size(proteusDataStruct.constant.Coord3D.Wing_LE_xyz,1)-1:-1:1
    % Leading edge xyz coordinate of first side of the aerodynamic macro
    % element
    xyz1 = proteusDataStruct.constant.Coord3D.Wing_LE_xyz(i,:);
    % Leading edge xyz coordinate of second side of the aerodynamic macro
    % element
    xyz4 = proteusDataStruct.constant.Coord3D.Wing_LE_xyz(i+1,:);
    % Chord lengths of the two sides of the aerodynamic macro element
    x12 = chordVector(i);
    x43 = chordVector(i+1);
    % Number of spanwise and chordwise aerodynamic boxes
    nSpanwiseBoxes = ceil(norm(xyz4-xyz1)/...
        nastranSettingStruct.aerodynamicEdgeSize);
    nChordwiseBoxes = ceil(chordVector(i)/...
        nastranSettingStruct.aerodynamicEdgeSize);
    % Generate input structure for Caero1 object
    caero1Struct(1,i) = struct(...
        'eid',nastranBulkData.LastElementId.addId,...
        'pid',nastranBulkData.Paero1Array.Pid,'nspan',nSpanwiseBoxes,...
        'nchord',nChordwiseBoxes,'x1',xyz1(1),'y1',xyz1(2),...
        'z1',xyz1(3),'x12',x12,'x4',xyz4(1),...
        'y4',xyz4(2),'z4',xyz4(3),'x43',x43);
    % Update last node and element id, keeping into account the aerodynamic
    % elements generated
    nastranBulkData.LastGridId.addId(...
        (nSpanwiseBoxes+1)*(nChordwiseBoxes+1));
    nastranBulkData.LastElementId.addId(...
        nSpanwiseBoxes*nChordwiseBoxes);
end
% Generate Caero1 object and assign it to NastranBulkData object
nastranBulkData.Caero1Array = Caero1(caero1Struct);

%% Generate load reference axis with RBE2 and RBE3 elements
generateNastranLoadReferenceAxis(nastranBulkData,proteusDataStruct);

%% Generate Spline1 objects
for i = length(nastranBulkData.Caero1Array):-1:1
    nastranBulkData.Spline1Array(i) = Spline1(struct(...
        'eid',nastranBulkData.LastElementId.addId,...
        'caero',nastranBulkData.Caero1Array(i).Eid,...
        'box1',nastranBulkData.Caero1Array(i).Eid,...
        'box2',nastranBulkData.Caero1Array(i).Eid+...
        nastranBulkData.Caero1Array(i).Nspan*...
        nastranBulkData.Caero1Array(i).Nchord-1,...
        'setg',nastranBulkData.Set1Array.Sid));
end
end
