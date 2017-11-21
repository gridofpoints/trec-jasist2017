function loadDataAndCreateCSV(collectionName, filename)
%LOADDATAANDCREATECSV Summary of this function goes here
%   Detailed explanation goes here


path = sprintf('%1$s%2$s%3$s%4$s%5$s%6$s', '/Users/silvello/Dropbox/Grid-of-points/TREC/2016_10/', collectionName, filesep, 'ap_', collectionName, '.mat');
varname = sprintf('%1$s_%2$s', 'ap', collectionName);
serload(path);

eval(sprintf('ap = %s;', varname));

path = sprintf('%1$s%2$s%3$s%4$s%5$s%6$s', '/Users/silvello/Dropbox/Grid-of-points/TREC/2016_10/', collectionName, filesep, 'err_', collectionName, '.mat');
varname = sprintf('%1$s_%2$s', 'err', collectionName);
serload(path);

eval(sprintf('err = %s;', varname));


path = sprintf('%1$s%2$s%3$s%4$s%5$s%6$s', '/Users/silvello/Dropbox/Grid-of-points/TREC/2016_10/', collectionName, filesep, 'p10_', collectionName, '.mat');

varname = sprintf('%1$s_%2$s', 'p10', collectionName);
serload(path);

eval(sprintf('p10 = %s;', varname));


path = sprintf('%1$s%2$s%3$s%4$s%5$s%6$s', '/Users/silvello/Dropbox/Grid-of-points/TREC/2016_10/', collectionName, filesep, 'rbp_', collectionName, '.mat');

varname = sprintf('%1$s_%2$s', 'rbp', collectionName);
serload(path);

eval(sprintf('rbp = %s;', varname));


path = sprintf('%1$s%2$s%3$s%4$s%5$s%6$s', '/Users/silvello/Dropbox/Grid-of-points/TREC/2016_10/', collectionName, filesep, 'twist_', collectionName, '.mat');

varname = sprintf('%1$s_%2$s', 'twist', collectionName);
serload(path);

eval(sprintf('twistMeasure = %s;', varname));


path = sprintf('%1$s%2$s%3$s%4$s%5$s%6$s', '/Users/silvello/Dropbox/Grid-of-points/TREC/2016_10/', collectionName, filesep, 'ndcg_', collectionName, '.mat');

varname = sprintf('%1$s_%2$s', 'ndcg', collectionName);
serload(path);

eval(sprintf('ndcg = %s;', varname));

format short;

measures= gop_data_export(ap, 'stem', 'ap');
rbp_tmp = gop_data_export(rbp, 'stem', 'rbp');
err_tmp = gop_data_export(err, 'stem', 'err');
p10_tmp = gop_data_export(p10, 'stem', 'p10');
twist_tmp = gop_data_export(twistMeasure, 'stem', 'twist');
ndcg_tmp = gop_data_export(ndcg, 'stem', 'ndcg');


measures = [measures rbp_tmp(:, 5) p10_tmp(:, 5) ndcg_tmp(:, 5) twist_tmp(:, 5) err_tmp(:, 5)];

writetable(measures,filename);

end

