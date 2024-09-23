function [hax,hf] = multiaxes(varargin)
% function hax = multiaxes(hf,nrows,ncols,[rowleft,rowright],[coltop,colbot],[spacerows,spacecols])

% defaults
rowmarg = [0.10,0.05];
colmarg = [0.05,0.10];
spaces  = [0.05,0.05];


if nargin==2
    hf = figure;
    nrows = varargin{1};
    ncols = varargin{2};
elseif nargin == 3
    hf = varargin{1};
    assert(ishandle(hf),'hf must be a handle')
    nrows    = varargin{2};
    ncols    = varargin{3};
elseif nargin == 5
    hf = figure;
    nrows = varargin{1};
    ncols = varargin{2};
    if ~isempty(varargin{3})
        rowmarg = varargin{3};
    end
    if ~isempty(varargin{4})
        colmarg = varargin{4};
    end
    if ~isempty(varargin{5})
        spaces = varargin{5};
    end
elseif nargin == 6
    hf = varargin{1};
    nrows = varargin{2};
    ncols = varargin{3};
    if ~isempty(varargin{4})
        rowmarg = varargin{4};
    end
    if ~isempty(varargin{5})
        colmarg = varargin{5};
    end
    if ~isempty(varargin{6})
        spaces = varargin{6};
    end
else
    error('wrong number of input arguments')
end

rowleft = rowmarg(1);
rowright = rowmarg(2);
coltop = colmarg(1);
colbot = colmarg(2);
srows = spaces(1);
scols = spaces(2);

drows = ((1-rowleft-rowright) - srows*(nrows-1))/nrows;
dcols = ((1-coltop-colbot) - scols*(ncols-1))/ncols;

for irow = 1:nrows;
    for icol = 1:ncols;
        prow = rowleft+(drows+srows)*(irow-1);
        pcol = 1-coltop-icol*dcols - scols*(icol-1);
        hax(irow,icol) = axes('parent',hf,'position',[prow,pcol,drows,dcols]);
    end
end
