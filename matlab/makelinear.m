%
% converts any input matrix
% into a 1D vector (output)
%
function data = makelinear(im)

data = zeros(numel(im),1);
data(:) = im(:);
