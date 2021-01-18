function imgout = mask(img, colour, threshold)
% MASK Masks the given image, resulting in a black-and-white 2D logical
% matrix where 1 represents pixels that match the given colour within the
% given threshold.

% Reads the image dimensions
dimensions = size(img);

% Black-and-white 2D array; initially everything is false/0 (black)
imgout = false(dimensions(1:2));

% Loop through all the pixels
for y = 1:dimensions(1)
    for x = 1:dimensions(2)
        % If the pixel matches the colour...
        if matchesColour(permute(img(y, x, :), [3, 1, 2]), colour, threshold)
            imgout(y, x) = true; % ... make it true/1 (white)
        end
    end
end

end