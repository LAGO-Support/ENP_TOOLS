function [] = generate_latex_files_by_area(MO,MS,INI)
%021812 - changed to only using INI
% added (currently unused) INI to input args in prepaation of future changes rjf 12/19/2011

fprintf('\n\n--Generating the LATEX files by area:');
fidTEX = generate_latex_head(INI);

FILEDATA = INI.FILESAVE_TS;
fprintf('\n\n--Loading Computed and observed data from file:\n\t%s', char(FILEDATA));
load(FILEDATA, '-mat');

mapAreas = getMapAreas(MAP_ALL_DATA,MS); % use this map to print by areas

% for M = keys(MO)
fprintf('\n\n--Generating figures and tables:');
for M = mapAreas.keys   
    STATION_LIST = mapAreas(char(M));        
    
    generate_page_figures(M, STATION_LIST,MAP_ALL_DATA,INI,fidTEX);
    %     if INI.MAKE_STATISTICS_TABLE
    %     fprintf('... Including statistics in the LATEX file\n');
    generate_area_tables(M, MS, STATION_LIST,INI,fidTEX);
    %     end
end
generate_latex_tail(fidTEX);


end

function mapAreas = getMapAreas(MAP_ALL_DATA,MS)
% this function creates a map of subdomain areas : N_AREAS and lists 
% all stations within each subdomain area
mapAreas = containers.Map;

for K = MS.keys
    I_AREA = MAP_ALL_DATA(char(K)).I_AREA;
    N_AREA = MAP_ALL_DATA(char(K)).N_AREA;
    if isKey(mapAreas,N_AREA)
        V_STATIONS = mapAreas(char(N_AREA));
        V_STATIONS = [V_STATIONS K];
    else 
        V_STATIONS = K;
    end
        mapAreas(char(N_AREA)) = V_STATIONS;
end

end 