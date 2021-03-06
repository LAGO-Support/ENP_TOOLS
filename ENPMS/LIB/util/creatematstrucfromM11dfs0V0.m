function [DATA_OBSERVED] = creatematstrucfromM11dfs0V0(stationname, DFS0file)



datatype = 'M11';

NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;
import DHI.Generic.MikeZero.DFS.dfs0.*;


if (~exist('stationname','var')),stationname = 'S12D_Q'; end;
if (~exist('DFS0file','var')),DFS0file = 'E:\APPS\MODELS\DHIMODEL\INPUTFILES\M11\TIMESERIES\S12D_Q.dfs0'; end;



%Define a handle with file properties
MyDfsFile=DfsFileFactory.DfsGenericOpen(DFS0file);
%No of dimensions: dfs0 is 0
%MyDfsFileDim = MyDfsFile.ItemInfo.Item(0).SpatialAxis.Dimension;
% this gives column of data and column of zeros?
AllFileData = double(Dfs0Util.ReadDfs0DataDouble(MyDfsFile)); % read all data in file

   
TimeseriesData = AllFileData(:,2); % parse out item timeseries data from array
TimesInSeconds = AllFileData(:,1);     % parse out timestamp array (seconds since startdate)


   % set up start date vector
sd=MyDfsFile.FileInfo.TimeAxis.StartDateTime;
dfsstartdatetime=datenum(double([sd.Year sd.Month sd.Day sd.Hour sd.Minute sd.Second]));
   
   % transfer timestamp array (in seconds since startdate) to time vectors
for t=1:length(TimesInSeconds)
      DfsTime = datenum(double([0 0 0 0 0 TimesInSeconds(t)]));
      TimeVector(t,:) = datevec(DfsTime + dfsstartdatetime);
end

% put data into a 1-D array
ValueVector = TimeseriesData(:);
     
%selstat= xldata(1:numrowsadd,1);
%0= water level; 1= discharge
%type = xldata(1:numrowsadd,2);
%branch = xldata(1:numrowsadd,3);
%chain = xldata(1:numrowsadd,4);
%filename1 = xldata(1:numrowsadd,5);
%the properties
DATA_OBSERVED.NAME = stationname;
DATA_OBSERVED.TIMEVECTOR= TimeVector;
DATA_OBSERVED.DOBSERVED = ValueVector;
DATA_OBSERVED.DFSTYPE=char(MyDfsFile.ItemInfo.Item(0).Quantity.ItemDescription);
DATA_OBSERVED.UNIT =char(MyDfsFile.ItemInfo.Item(0).Quantity.UnitDescription);
DATA_OBSERVED.X_UTM = MyDfsFile.ItemInfo.Item(0).ReferenceCoordinateX;
DATA_OBSERVED.Y_UTM = MyDfsFile.ItemInfo.Item(0).ReferenceCoordinateY;
DATA_OBSERVED.Z_GRID =  MyDfsFile.ItemInfo.Item(0).ReferenceCoordinateZ;
DATA_OBSERVED.Z = NaN;
DATA_OBSERVED.Z_SURF = NaN;
DATA_OBSERVED.Z_SURVEY = NaN;


DATA_OBSERVED.STARTDATE = datevec(dfsstartdatetime);
DATA_OBSERVED.ENDDATE = datevec(dfsstartdatetime + length(TimeVector) - 1);
DATA_OBSERVED.DATATYPE = datatype;


DATA_OBSERVED.DOBSERVED((DATA_OBSERVED.DOBSERVED > -1.000000e-010) &  (DATA_OBSERVED.DOBSERVED < -1.000000e-040)) = NaN;


%fn_structdisp(DATA_OBSERVED);


return;
