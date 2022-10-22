fid = fopen('sealeveldata.txt');

% Takes the value and reads them into a 2 dimensional array
% %f takes the value and stores/converts it into a floating point
% 'headerlines', 7 tells textscan to skip 7 lines (to not include the
% header in the values/dataset)
SL = textscan(fid,'%f %f %f %f %f %f %f %f','headerlines',7);

fclose(fid);

% SL is a 2d array so S{1} is the entire first column
% SL{4} is the entire 4th column
% This creates a 2d array/list of all the values, going from top of one
% column to the very bottom, then incrementing to the next list with values
% for all of column 2
sl = [SL{1} SL{2} SL{3} SL{4} SL{5} SL{6} SL{7} SL{8}]';

% Whenever the data point is equal to 999 then it sets it equal to "null or 0" 
sl(sl==999)=NaN;

% Reshaping 2d matrix to [lon][lat] so row column form
sl = (reshape(sl,[1440 716]))';

% linspace creates 716 points between 89.5 and -89.5 (one for each data point)
% This is the "input array", which is then horizontally stacked
% 1 is rows, 1440 is columns
% So 1 long row with 716 values, which is then copied and laid out 1440
% times laterally (repeats those 716 values 1440 times in the same row)
% ex. 54 36 24 54 36 24 54 36 24 continued...
lat = repmat(linspace(89.5,-89.5,716)',1,1440);

% linspace creates 1440 points between 0 and 360 (one for each data point)
% This is the "input array", which is then vertically stacked
% 716 is rows, 1 is columns
% So 1 long column with 1440 values, which is then copied and laid out 716
% times vertically (repeats those 1440 values 716 times in the same column)
% ex. 54 36 24
% ex. 54 36 24
% ex. 54 36 24
% continued...
lon = repmat(linspace(0,360,1440),716,1);

% Creates map
figure
ax = worldmap('World');
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land, 'FaceColor', 'k');

% plots sea level data
pcolorm(lat,lon,sl)  

cb = colorbar('location','southoutside');
caxis([-15 15])
title(ax,'Rising Sea Levels across the Globe','FontWeight','bold','FontSize',24)
xlabel(cb,'Sea level rise (mm/yr)','FontWeight','bold','FontSize',12)
