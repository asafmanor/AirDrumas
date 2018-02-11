function vprintf(verbosity, varargin)
% prints according to a global verbosity parameter

global VERB
if VERB == 'none'
    return
elseif strcmp(VERB, 'low') && (strcmp(verbosity,'low') || strcmp(verbosity,'high'))
    fprintf(varargin{:});
elseif strcmp(VERB, 'high') && (strcmp(verbosity,'high'))
    fprintf(varargin{:});
end
end