function [V] = get_COUNT (TS)
% determine the count of observed and computed pairs

if isempty(TS), V = 0; return, end;
V = length(TS(:,1));

end
