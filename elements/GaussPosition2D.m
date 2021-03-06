% GaussStimulus2D (COSIVINA toolbox)
%   Connective element that performs a 2D convolution with a Gaussian kernel.
%
% Constructor call:
% GaussStimulus2D(label, size, sigmaY, sigmaX, amplitude, positionY, ...
%     positionX, circularY, circularX, normalized)
%   label - element label
%   size - size of input and output of the convolution
%   sigmaY, sigmaX - vertical and horizontal width parameter of the Gaussian
%   amplitude - amplitude of the Gaussian
%   positionY, positionX - vertical and horizontal center of the Gaussian
%   circularY, circularX - flags indicating whether Gaussian is defined
%     circularly (default value is true)
%   normalized - flag indicating whether Gaussian is normalized before
%     scaling with amplitude (default value is false)



classdef GaussPosition2D < Element
  
  properties (Constant)
    parameters = struct('size', ParameterStatus.Fixed, 'sigmaX', ParameterStatus.InitRequired, ...
      'sigmaY', ParameterStatus.InitRequired, 'amplitude', ParameterStatus.InitRequired, ...
      'positionX', ParameterStatus.InitRequired, 'positionY', ParameterStatus.InitRequired, ...
      'circularX', ParameterStatus.InitRequired, 'circularY', ParameterStatus.InitRequired, ...
      'normalized', ParameterStatus.InitRequired);
    components = {'output','positionX','positionY'};
    defaultOutputComponent = 'output';
  end
  
  properties
    % parameters
    size = [1, 1];
    sigmaX = 1;
    sigmaY = 1;
    amplitude = 0;
    positionX = 1;
    positionY = 1;
    circularX = true;
    circularY = true;
    normalized = false;
    
    % accessible structures
    output
  end
  
  methods
    % constructor
    function obj = GaussPosition2D(label, size, sigmaY, sigmaX, amplitude, positionY, positionX, ...
        circularY, circularX, normalized)
      if nargin > 0
        obj.label = label;
        obj.size = size;
      end
      if nargin >= 4
        obj.sigmaY = sigmaY;
        obj.sigmaX = sigmaX;
      end
      if nargin >= 5
        obj.amplitude = amplitude;
      end
      if nargin >= 7
        obj.positionY = positionY;
        obj.positionX = positionX;
      end
      if nargin >= 9
        obj.circularY = circularY;
        obj.circularX = circularX;
      end
      if nargin >= 10
        obj.normalized = normalized;
      end
      
      if numel(obj.size) == 1
        obj.size = [1, obj.size];
      end
    end
    
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSD>
      if obj.nInputs > 0
        position = obj.inputElements{1}.(obj.inputComponents{1});
        if position(1) ~= obj.positionY || position(2) ~= obj.positionX
          obj.positionX = position(2);
          obj.positionY = position(1);
          obj.init;
        end
      end
    end
    
    
    % initialization
    function obj = init(obj)
      obj.output = circularGauss2d(1:obj.size(1), 1:obj.size(2), obj.positionY, obj.positionX, ...
        obj.sigmaY, obj.sigmaX, [], obj.circularY, obj.circularX);
      if obj.normalized && sum(obj.output) > 0
        obj.output = obj.amplitude * obj.output / sum(obj.output);
      else
        obj.output = obj.amplitude * obj.output;
      end
    end
  end
  
end
