function result = matchesColour(rgbToTest, rgbToMatch, tolerance)
% MATCHESCOLOUR Tests whether the two given colours (RGB vectors) match within the given tolerance.

    % Allows the result of the subtraction later to be negative (colours
    % read from images by MATLAB are unsigned 8-bit integers, so this
    % converts them to signed 16-bit integers)
    rgbToTest = int16(rgbToTest);
    rgbToMatch = int16(rgbToMatch);
    
    % Check the colours are of the expected RGB format
    if length(rgbToTest) ~= 3 || length(rgbToMatch) ~= 3
        error('Expected vector of length 3');
    end
    
    % Perform the actual test: sum the absolute difference between the two
    % colours for each RGB channel and return true if the result is within
    % the given tolerance
    result = sum(abs(rgbToTest-rgbToMatch)) < tolerance;
    
end