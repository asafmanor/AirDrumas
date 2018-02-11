function vprintf(verbosity, varargin)
% prints according to a global verbosity parameter

global VERB
if strcmp(VERB, 'none')
    return
elseif strcmp(VERB, 'low') && strcmp(verbosity,'low')
    fprintf(varargin{:});
elseif strcmp(VERB, 'high') && ((strcmp(verbosity,'low')) || strcmp(verbosity,'high'))
    fprintf(varargin{:});
end
end