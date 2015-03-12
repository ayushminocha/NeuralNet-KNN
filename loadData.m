function dataPoints = loadData(Dataset_folder)

%Dataset_folder = 'outDataClassLDL/';
dataFiles = dir([Dataset_folder '*.csv']);

dataPoints = struct;

for i = 1:length(dataFiles)
    dataVal = csvread([Dataset_folder dataFiles(i).name],1,1);
    dataPoints(i).name = [Dataset_folder dataFiles(i).name];
    dataPoints(i).points = dataVal;
    filename = dataFiles(i).name;
    filename = strsplit(filename,'_');
    filename = filename{end};
    class = strsplit(filename,'.');
    class = class{1};
    dataPoints(i).class = str2num(class);
end

end