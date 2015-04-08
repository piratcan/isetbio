function object = initDefaultSpectrum(object, spectralType, wave)
% Create default wavelength spectrum and attach it to an ISET object
%
%  object = initDefaultSpectrum(object,spectralType,wave)
%
%  The spectrum structure specifies the sample wavelengths.
%
%  We use only three spectral types at present.  These are
%
%  Multispectral:  400:10:700 nm
%  Monochrome:     550 nm
%  Custom:         The user supplies the wavelength samples
%
% Examples
%  scene = initDefaultSpectrum(scene, 'monochrome');
%  scene = initDefaultSpectrum(scene, 'multispectral');
%  scene = initDefaultSpectrum(scene, 'custom', 400:50:700);
%
% Copyright ImagEval Consultants, LLC, 2003.

if notDefined('object'), error('Object required.'); end
if notDefined('spectralType'), spectralType = 'hyperspectral'; end

switch lower(spectralType)
    case {'spectral', 'multispectral', 'hyperspectral'}
        object.wave = (400:10:700)';
        
    case 'monochrome'
        object.wave = 550;
        
    case 'custom'
        if notDefined('wave')
            error('wave required for custom spectrum');
        end
        object.wave = wave(:);
        
    otherwise,
        error('spectralType not yet defined.');
end

end