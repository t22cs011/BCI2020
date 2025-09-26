

%# -*- texinfo -*-
%# @deftypefn {Function File} {[Pxx,w]} = periodogram (@var{x})
%# For a data matrix @var{x} from a sample of size @var{n}, return the
%# periodogram. w returns the angular frequency. 
%#
%#   [Pxx,w] = periodogram(@var{x}).
%#
%#   [Pxx,w] = periodogram(@var{x},win).
%#
%#   [Pxx,w] = periodogram(@var{x},win,nfft).
%#
%#   [Pxx,f] = periodogram(@var{x},win,nfft,Fs).
%#
%#   [Pxx,f] = periodogram(@var{x},win,nfft,Fs,'range').
%#   
%#   x      data; if real-valued a one-sided spectrum is estimated, if complex-valued or range indicates 'twosided', the full spectrum is estimated. 
%#
%#   win    weight data with window, x.*win is used for further computation, if window is empty, a rectangular window is used. 
%#
%#   nfft   number of frequency bins, default max(256, 2.^ceil(log2(length(x)))).
%#
%#   Fs     sampleing rate, default 1.
%#
%#   range: 'onesided' computes spectrum from [0..nfft/2+1].
%#          'twosided' computes spectrum from [0..nfft-1].  
%#          these strings can appear at any position in the list input arguments after window. 
%#   
%#   Pxx    one-, or two-sided power spectrum.
%#
%#   w      angular frequency [0..2*pi) (two-sided) or [0..pi] one-sided.
%#
%#   f      frequency [0..Fs) (two-sided) or [0..Fs/2] one-sided.
%#
%#
%# @end deftypefn
 
%# Author: FL <Friedrich.Leisch@ci.tuwien.ac.at>
%# Description: Compute the periodogram

function [pxx,f] = periodogram (x,varargin)

  %#### check input arguments ######

  if nargin < 1 || nargin > 5, 
    print_usage ;
  end % if 

  nfft = []; fs = []; range = []; window = [];
  j = 1; 
  for k = 1:length(varargin)       
    if ischar(varargin{k}) 
      range = varargin{k};  
    else 
      switch j
      case 1 
        window = varargin{k}; 
      case 2 
        nfft   = varargin{k}; 
      case 3 
        fs     = varargin{k}; 
      case 4 
        range  = varargin{k}; 
      end % switch
      j = j+1;
    end % if 
  end % for 
  
  [r, c] = size(x);
  if (r == 1)
    r = c;
  end % if

  if ischar(window)
    range = window; 
    window = [];
  end % if;   
  if ischar(nfft)
    range = nfft; 
    nfft = [];
  end % if;   
  if ischar(fs)
    range = fs; 
    fs = [];
  end % if; 

  if ~isempty(window)
    if all(size(x)==size(window))
      x = x .* window;
    elseif size(x,1)==size(window,1) && size(window,2)==1,
      x = x .* window(:,ones(1,c));
    end % if;   
  end % if         

  if numel(nfft)>1,
    error('nfft must be scalar');
  end % if
  if isempty(nfft)
    nfft = max(256, 2.^ceil(log2(r)));
  end % if         

  if strcmp(range,'onesided')
    range = 1;
  elseif strcmp(range,'twosided')
    range = 2;
  else 
    range = [];  
  end % if    
  if isempty(range) 
    range = 2-isreal(x);  
  end % if

  %#### compute periodogram ######
  
  if r>nfft,
    Pxx = 0;    
    rr = rem(length(x),nfft);
    if rr,
    	x = [x(:);zeros(nfft-rr,1)];
    end;
    x = sum(reshape(x,nfft,[]),2);
  end % if 
  Pxx = (abs (fft (x, nfft))) .^ 2 / r;
  
  if nargin<4,
    Pxx = Pxx/(2*pi);
  elseif ~isempty(fs)
    Pxx = Pxx/fs;
  end % if  
  
  %#### generate output arguments ######

  if range==1,  % onesided
    Pxx = Pxx(1:nfft/2+1) + [0;Pxx(end:-1:(nfft/2+2));0];
  end % if

  if nargout~=1,  
    if range==1,
      f = (0:nfft/2)'/nfft;
    elseif range==2,
      f = (0:nfft-1)'/nfft;
    end % if  
    if nargin<4,
      f = 2*pi*f; % generate w=2*pi*f
    elseif ~isempty(fs)
      f = f*fs;
    end % if
  end % if
  
  if nargout==0,
    if nargin<4,
      plot(f/(2*pi), 10*log10(Pxx));
      xlabel('normalized frequency [x pi rad]');
      ylabel('Power density [dB/rad/sample]');
    else
      plot(f, 10*log10(Pxx));
      xlabel('frequency [Hz]');
      ylabel('Power density [dB/Hz]');
    end  
    grid on;
    title('Periodogram Power Spectral Density Estimate');
  else 
    pxx = Pxx;   
  end % if
  
end % function

%# Copyright (C) 1995, 1996, 1997, 1998, 1999, 2000, 2002, 2005, 2007
%#               Friedrich Leisch
%# Copyright (C) 2010 Alois Schloegl 
%#
%# This file is part of Octave.
%#
%# Octave is free software; you can redistribute it and/or modify it
%# under the terms of the GNU General Public License as published by
%# the Free Software Foundation; either version 3 of the License, or (at
%# your option) any later version.
%#
%# Octave is distributed in the hope that it will be useful, but
%# WITHOUT ANY WARRANTY; without even the implied warranty of
%# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%# General Public License for more details.
%#
%# You should have received a copy of the GNU General Public License
%# along with Octave; see the file COPYING.  If not, see
%# <http://www.gnu.org/licenses/>.
