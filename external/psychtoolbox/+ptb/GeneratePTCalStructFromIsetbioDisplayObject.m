function PTBcal = GeneratePTCalStructFromIsetbioDisplayObject(display)

    % Start with a totally empty PTBcal
    PTBcal = ptb.GenerateEmptyPTBcalStruct();
    
    % Update key properties
    PTBcal = updateDisplayDescription(PTBcal,display);
    PTBcal = updateSpectralParams(PTBcal, display);
    PTBcal = updateGammaParams(PTBcal, display);
    PTBcal
    
end
    
function PTBcal = updateGammaParams(oldPTBcal, display)
    [gammaTable, gammaInput] = retrieveGammaTable(display);
    
    
    PTBcal = oldPTBcal;
    PTBcal.gammaInput = gammaInput';
    PTBcal.gammaTable = gammaTable;
    PTBcal.nDevices = size(gammaTable,2);
end

function PTBcal = updateSpectralParams(oldPTBcal, display)
    
    [wave, spd] = retrievePrimaries(display);
    spectralSamples  = size(wave,1);
    
    PTBcal = oldPTBcal;
    PTBcal.describe.S   = WlsToS(wave);
    PTBcal.S_ambient    = PTBcal.describe.S;
    PTBcal.P_device     = spd;
    PTBcal.P_ambient    = zeros(size(spectralSamples,1), 1);  % note: zero ambient
    PTBcal.T_ambient    = eye(spectralSamples);
    PTBcal.T_device     = eye(spectralSamples);
    
end


function PTBcal = updateDisplayDescription(oldPTBcal,display)

    % isetbio display struct does not store the number of pixels of a
    % display, only the ppi. So we will enter an arbitrarily number
    % just to have the correct dpi
    
    dotsPerMeter = displayGet(display, 'dots per meter');
    arbitraryScreenSizeInPixels = [1920 1080];
    phi = atan2(arbitraryScreenSizeInPixels(2), arbitraryScreenSizeInPixels(1));
    dotsPerMeter = dotsPerMeter * [cos(phi) sin(phi)];
    size(dotsPerMeter)
    size(arbitraryScreenSizeInPixels )
    screenSizeMM = 1000.0*arbitraryScreenSizeInPixels ./ dotsPerMeter;
    
    PTBcal = oldPTBcal;
    PTBcal.describe.displayDescription.screenSizePixel = arbitraryScreenSizeInPixels;
    PTBcal.describe.displayDescription.screenSizeMM    = screenSizeMM;
end


function [gammaTable, gammaInput] = retrieveGammaTable(display)
    % Gamma table, remove 4-th primary, if it exists
    gammaTable = displayGet(display, 'gTable');
    if (size(gammaTable,2) > 3)
        gammaTable = gammaTable(:,1:3);
    end
    gammaInput = linspace(0,1,size(gammaTable,1));
end

function [wave, spd] = retrievePrimaries(display)
    % Remove 4-th primary, if it exists, for testing purposes.
    wave = displayGet(display, 'wave');
    spd  = displayGet(display, 'spd primaries');
    if (size(spd ,2) > 3)
        spd = spd(:,1:3);
    end
end


