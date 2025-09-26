

%# usage:  [P, w] = __power (b, a, [, nfft [, Fs]] [, range] [, units])
%# 
%# Plot the power spectrum of the given ARMA model.
%#
%# b, a: filter coefficients (b=numerator, a=denominator)
%# nfft is number of points at which to sample the power spectrum
%# Fs is the sampling frequency of x
%# range is 'half' (default) or 'whole'
%# units is  'squared' or 'db' (default)
%# range and units may be specified any time after the filter, in either
%# order
%#
%# Returns P, the magnitude vector, and w, the frequencies at which it
%# is sampled.  If there are no return values requested, then plot the power
%# spectrum and don't return anything.

%# TODO: consider folding this into freqz --- just one more parameter to
%# TODO:    distinguish between 'linear', 'log', 'logsquared' and 'squared'

function [varargout] = o2m_tmp___power (b, a, varargin)
  usagestr = '[P w] = o2m_tmp___power(b, a [,nfft [,Fs]] [,range] [, units])';
  if (nargin < 2 || nargin > 6) error(usagestr); end

  nfft = [];
  Fs = [];
  range = [];
  range_fact = 1.0;
  units = [];

  pos = 0;
  for i=1:length(varargin)
    arg = varargin{i};
    if strcmp(arg, 'squared') || strcmp(arg, 'db')
      units = arg;
    elseif strcmp(arg, 'whole')
      range = arg;
      range_fact = 1.0;
    elseif strcmp(arg, 'half')
      range = arg;
      range_fact = 2.0;
    elseif ischar(arg)
      error(usagestr);
    elseif pos == 0
      nfft = arg;
      pos = pos + 1;
    elseif pos == 1
      Fs = arg;
      pos = pos + 1;
    else
      error(usagestr);
    end
  end
  
  if isempty(nfft); nfft = 256; end
  if isempty(Fs); Fs = 2; end
  if isempty(range)
    range = 'half';
    range_fact = 2.0;
    end
  
  [P, w] = freqz(b, a, nfft, range, Fs);

  P = (range_fact/Fs)*(P.*conj(P));
  if nargout == 0,
    if strcmp(units, 'squared')
      plot(w, P, ';;');
    else
      plot(w, 10.0*log10(abs(P)), ';;');
    end
  end
  if nargout >= 1, varargout{1} = P; end
  if nargout >= 2, varargout{2} = w; end




%# Copyright (C) 1999 Paul Kienzle
%#
%# This program is free software; you can redistribute it and/or modify
%# it under the terms of the GNU General Public License as published by
%# the Free Software Foundation; either version 2 of the License, or
%# (at your option) any later version.
%#
%# This program is distributed in the hope that it will be useful,
%# but WITHOUT ANY WARRANTY; without even the implied warranty of
%# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%# GNU General Public License for more details.
%#
%# You should have received a copy of the GNU General Public License
%# along with this program; If not, see <http://www.gnu.org/licenses/>.
