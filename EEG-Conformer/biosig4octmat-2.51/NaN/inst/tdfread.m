function S = tdfread(filename,del)
% TDFREAD reads data table into structure 
%   S = tdfread()
%   S = tdfread(filename)
%   S = tdfread(filename,delimiter)
% 
%  
%

%	$Id$
%	Copyright (C) 2009 by Alois Schloegl <a.schloegl@ieee.org>	
%       This function is part of the NaN-toolbox
%       http://biosig-consulting.com/matlab/NaN/

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 3
% of the  License, or (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

if nargin<2, del = char(9); end; 
if nargin<1, 
        if exist('OCTAVE_VERSION','builtin')
                warning('uigetfile not implemented yet, use explicit input argument to tdfread');
        end; 
        [f,p] = uigetfile('', 'select file'); 
        filename = fullfile(p,f); 
end; 

fid = fopen(filename); 
h   = fgetl(fid); 
s   = fread(fid,[1,inf],'uint8=>char'); 
fclose(fid); 

[n,v,f]  = str2double(h, del);
[n,v,sa] = str2double(s, del);       
if nargout>0, S = []; end; 
for k=1:length(f)
        if any(v(:,k))
                val = sa(:,k);  
        else
                val = n(:,k);  
        end        
        if nargout>0,
                S = setfield(S,f{k},val);
        else        
                assignin('caller',f{k},val);
        end;         
end;

