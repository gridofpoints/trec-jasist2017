%% common_parameters
% 
% Sets up parameters common to the different scripts.
%
%% Information
% 
% * *Author*: <mailto:ferro@dei.unipd.it Nicola Ferro>
% * *Version*: 1.00
% * *Since*: 1.00
% * *Requirements*: MATTERS 1.0 or higher; Matlab 2015b or higher
% * *Copyright:* (C) 2016 <http://ims.dei.unipd.it/ Information 
% Management Systems> (IMS) research group, <http://www.dei.unipd.it/ 
% Department of Information Engineering> (DEI), <http://www.unipd.it/ 
% University of Padua>, Italy
% * *License:* <http://www.apache.org/licenses/LICENSE-2.0 Apache License, 
% Version 2.0>

%%
%{
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
      http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
%}

diary off;

%% General configuration

% if we are running on the cluster 
if (strcmpi(computer, 'GLNXA64'))
    addpath('/nas1/promise/ims/ferro/matters/base/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/analysis/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/io/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/measure/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/plot/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/util/')
end;

% The base path
if (strcmpi(computer, 'GLNXA64'))
    % if we are running on the cluster 
    EXPERIMENT.path.base = '/nas1/promise/ims/ferro/TKDE2016-FS/experiment/';
else
    %EXPERIMENT.path.base = '/Users/ferro/Documents/pubblicazioni/2016/TKDE2016-FS/experiment/';
    EXPERIMENT.path.base = '/Users/silvello/Dropbox/Papers/2016/zz_TKDE2016-FS_DEAD/experiment/';
end;

% The path for logs
EXPERIMENT.path.log = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'log', filesep);

% The path for measures
EXPERIMENT.path.measure = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'measure', filesep);

% The path for analyses
EXPERIMENT.path.analysis = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'analysis', filesep);

% The path for figures
EXPERIMENT.path.figure = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'figure', filesep);

% The path for reports
EXPERIMENT.path.report = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'report', filesep);

% Label of the paper this experiment is for
EXPERIMENT.label.paper = 'TKDE 2016 FS';

%% Overall Experiment Taxonomy

EXPERIMENT.taxonomy.component.list = {'stop', 'lug', 'model', 'ltr', 'query'};
EXPERIMENT.taxonomy.component.number = length(EXPERIMENT.taxonomy.component.list);

EXPERIMENT.taxonomy.stop.id = {'nostop', 'indri', 'lucene', 'smart', 'snowball', 'terrier'};
EXPERIMENT.taxonomy.stop.name = 'Stop Lists';
EXPERIMENT.taxonomy.stop.number = length(EXPERIMENT.taxonomy.stop.id);

EXPERIMENT.taxonomy.lug.list = {'stem', 'grams', 'lugall'};
EXPERIMENT.taxonomy.lug.number = length(EXPERIMENT.taxonomy.lug.list);

EXPERIMENT.taxonomy.lugall.id = {'nolug', 'krovetz', 'lovins', 'porter', 'snowballPorter', 'weakPorter', ...
    '4grams', '5grams', '6grams', '7grams', '8grams', '9grams', '10grams'};
EXPERIMENT.taxonomy.lugall.name = 'Stemmers and N-grams';
EXPERIMENT.taxonomy.lugall.number = length(EXPERIMENT.taxonomy.lugall.id);

EXPERIMENT.taxonomy.grams.id = {'nolug', '4grams', '5grams', '6grams', '7grams', '8grams', '9grams', '10grams'};
EXPERIMENT.taxonomy.grams.name = 'N-grams';
EXPERIMENT.taxonomy.grams.number = length(EXPERIMENT.taxonomy.grams.id);

EXPERIMENT.taxonomy.stem.id = {'nolug', 'krovetz', 'lovins', 'porter', 'snowballPorter', 'weakPorter'};
EXPERIMENT.taxonomy.stem.name = 'Stemmers';
EXPERIMENT.taxonomy.stem.number = length(EXPERIMENT.taxonomy.stem.id);

EXPERIMENT.taxonomy.model.id = {'bb2', 'bm25', 'dfiz', 'dfree', ...
    'dirichletlm', 'dlh', 'dph', 'hiemstralm', 'ifb2', 'inb2', 'inl2', ...
    'inexpb2', 'jskls', 'lemurtfidf', 'lgd',  'pl2', 'tfidf'};
EXPERIMENT.taxonomy.model.name = 'IR Models';
EXPERIMENT.taxonomy.model.number = length(EXPERIMENT.taxonomy.model.id);

EXPERIMENT.taxonomy.ltr.id = {'noltr'};
EXPERIMENT.taxonomy.ltr.name = 'Learning to Rank';
EXPERIMENT.taxonomy.ltr.number = length(EXPERIMENT.taxonomy.ltr.id);

EXPERIMENT.taxonomy.query.id = {'medium'};
EXPERIMENT.taxonomy.query.name = 'Query Length';
EXPERIMENT.taxonomy.query.number = length(EXPERIMENT.taxonomy.query.id);

%% Configuration for collections 

% TREC 07, 1998, Adhoc
EXPERIMENT.T07.id = 'T07';
EXPERIMENT.T07.name =  'TREC 07, 1998, Adhoc';

% TREC 08, 1999, Adhoc
EXPERIMENT.T08.id = 'T08';
EXPERIMENT.T08.name =  'TREC 08, 1999, Adhoc';

% TREC 07-08, 1998-1999, Adhoc
EXPERIMENT.T0708.id = 'T0708';
EXPERIMENT.T0708.name =  'TREC 07-08, 1998-1999, Adhoc';

% TREC 09, 2000, Web
EXPERIMENT.T09.id = 'T09';
EXPERIMENT.T09.name =  'TREC 09, 2000, Web';

% TREC 10, 2001, Web
EXPERIMENT.T10.id = 'T10';
EXPERIMENT.T10.name =  'TREC 10, 2001, Web';

% TREC 09-10, 2000-2001, Web
EXPERIMENT.T0910.id = 'T0910';
EXPERIMENT.T0910.name =  'TREC 09-10, 2000-2001, Web';

% TREC 13, 2004, Terabyte
EXPERIMENT.T13.id = 'T13';
EXPERIMENT.T13.name =  'TREC 13, 2004, Terabyte';

% TREC 14, 2004, Terabyte
EXPERIMENT.T14.id = 'T14';
EXPERIMENT.T14.name =  'TREC 14, 2004, Terabyte';

% TREC 14, 2004, Terabyte
EXPERIMENT.T15.id = 'T15';
EXPERIMENT.T15.name =  'TREC 15, 2005, Terabyte';


% TREC 13-14, 2004-2005, Terabyte
EXPERIMENT.T1314.id = 'T1314';
EXPERIMENT.T1314.name =  'TREC 13-15, 2004-2005, Terabyte';


%% Configuration for measures

% The list of measures under experimentation
EXPERIMENT.measure.list = {'ap', 'p10', 'rprec', 'rbp', 'ndcg20', 'ndcg', ...
    'err20', 'err', 'twist'};
EXPERIMENT.measure.number = length(EXPERIMENT.measure.list);

% Configuration for AP
EXPERIMENT.measure.ap.id = 'ap';
EXPERIMENT.measure.ap.shortName = 'AP';
EXPERIMENT.measure.ap.fullName = 'Average Precision (AP)';

% Configuration for P@10
EXPERIMENT.measure.p10.id = 'p10';
EXPERIMENT.measure.p10.shortName = 'P@10';
EXPERIMENT.measure.p10.fullName = 'Precision at 10 Retrieved Documents';

% Configuration for R-prec
EXPERIMENT.measure.rprec.id = 'rprec';
EXPERIMENT.measure.rprec.shortName = 'R-prec';
EXPERIMENT.measure.rprec.fullName = 'Precision at the Recall Base';

% Configuration for RBP
EXPERIMENT.measure.rbp.id = 'rbp';
EXPERIMENT.measure.rbp.shortName = 'RBP';
EXPERIMENT.measure.rbp.fullName = 'Rank-biased Precision (RBP)';

% Configuration for nDCG@20
EXPERIMENT.measure.ndcg20.id = 'ndcg20';
EXPERIMENT.measure.ndcg20.shortName = 'nDCG@20';
EXPERIMENT.measure.ndcg20.fullName = 'Normalized Discounted Cumulated Gain (nDCG) at 20 Retrieved Documents';

% Configuration for nDCG
EXPERIMENT.measure.ndcg.id = 'ndcg';
EXPERIMENT.measure.ndcg.shortName = 'nDCG';
EXPERIMENT.measure.ndcg.fullName = 'Normalized Discounted Cumulated Gain (nDCG) at Last Retrieved Document';

% Configuration for ERR@20
EXPERIMENT.measure.err20.id = 'err20';
EXPERIMENT.measure.err20.shortName = 'ERR@20';
EXPERIMENT.measure.err20.fullName = 'Expected Reciprocal Rank (ERR) at 20 Retrieved Documents';

% Configuration for ERR
EXPERIMENT.measure.err.id = 'err';
EXPERIMENT.measure.err.shortName = 'ERR';
EXPERIMENT.measure.err.fullName = 'Expected Reciprocal Rank (ERR) at Last Retrieved Document';

% Configuration for Twist
EXPERIMENT.measure.twist.id = 'twist';
EXPERIMENT.measure.twist.shortName = 'twist';
EXPERIMENT.measure.twist.fullName = 'Twist';

% Returns the identifier of a measure given its index in EXPERIMENT.measure.list
EXPERIMENT.measure.getID = @(idx) ( EXPERIMENT.measure.(EXPERIMENT.measure.list{idx}).id ); 

% Returns the name of a measure given its index in EXPERIMENT.measure.list
EXPERIMENT.measure.getShortName = @(idx) ( EXPERIMENT.measure.(EXPERIMENT.measure.list{idx}).shortName ); 

% Returns the full name of a measure given its index in EXPERIMENT.measure.list
EXPERIMENT.measure.getFullName = @(idx) ( EXPERIMENT.measure.(EXPERIMENT.measure.list{idx}).fullName ); 


%% Patterns for LOG files

% Pattern EXPERIMENT.path.base/log/<tag>Analysis_<trackID>.log
EXPERIMENT.pattern.logFile.analysis = @(tag, trackID) sprintf('%1$s%2$sAnalysis_%3$s.log', EXPERIMENT.path.log, tag, trackID);

% Pattern EXPERIMENT.path.base/log/<tag>AnalysisReport.log
EXPERIMENT.pattern.logFile.analysisReport = @(tag) sprintf('%1$s%2$sAnalysisReport.log', EXPERIMENT.path.log, tag);

% Pattern EXPERIMENT.path.base/log/<tag>AnalysisPlot.log
EXPERIMENT.pattern.logFile.analysisPlot = @(tag) sprintf('%1$s%2$sAnalysisPlot.log', EXPERIMENT.path.log, tag);


%% Patterns for files names

% Pattern EXPERIMENT.path.measure/<trackID>/<measureID>
EXPERIMENT.pattern.file.measure = @(trackID, measureID) ...
    sprintf('%1$s%2$s%3$s%4$s.mat', EXPERIMENT.path.measure, trackID, filesep, measureID);

% Pattern EXPERIMENT.path.analysis/<trackID>/<tag>_<lugType>_<measureID>
EXPERIMENT.pattern.file.anova = @(trackID, tag, lugType, measureID) ...
    sprintf('%1$s%2$s%3$s%4$s_%5$s_%6$s.mat', EXPERIMENT.path.analysis, trackID, filesep, tag, lugType, measureID);

% Pattern EXPERIMENT.path.report/<tag>AnalysisReport.tex
EXPERIMENT.pattern.file.analysisReport = @(tag) ...
    sprintf('%1$s%2$sAnalysisReport.tex', EXPERIMENT.path.report, tag);

% Pattern EXPERIMENT.path.figure/<trackID>/<figureID>
EXPERIMENT.pattern.file.figure = @(trackID, figureID) ...
    sprintf('%1$s%2$s%3$s%4$s.pdf', EXPERIMENT.path.figure, trackID, filesep, figureID);



%% Patterns for identifiers

% Pattern <measureID>_<trackID>
EXPERIMENT.pattern.identifier.measure =  @(measureID, trackID) sprintf('%1$s_%2$s', measureID, trackID);

% Pattern <tag>_<lugType>_table_<measureID>
EXPERIMENT.pattern.identifier.anovaTable =  @(tag, lugType, measureID) sprintf('%1$s_%2$s_table_%3$s', tag, lugType, measureID);

% Pattern <tag>_<lugType>_stats_<measureID>tag
EXPERIMENT.pattern.identifier.anovaStats =  @(tag,lugType, measureID) sprintf('%1$s_%2$s_stats_%3$s', tag, lugType, measureID);

% Pattern <tag>_<lugType>_soa_<measureID>
EXPERIMENT.pattern.identifier.anovaSoA =  @(analysis, lugType, measureID) sprintf('%1$s_%2$s_soa_%3$s', tag,lugType, measureID);

% Pattern <tag>_<lugType>_mainEffects_<measureID>_<trackID>
EXPERIMENT.pattern.identifier.figure.mainEffects = @(tag,lugType, measureID, trackID) ...
    sprintf('%1$s_%2$s_mainEffects_%3$s_%4$s', tag,  lugType, measureID, trackID);

% Pattern <tag>_<lugType>_interactionEffects_<measureID>_<trackID>
EXPERIMENT.pattern.identifier.figure.interactionEffects = @(tag,lugType, measureID, trackID) ...
    sprintf('%1$s_%2$s_interactionEffects_%3$s_%4$s', tag,  lugType, measureID, trackID);

% Pattern <tag>_<lugType>_<component>_multcompare_<measureID>_<trackID>
EXPERIMENT.pattern.identifier.figure.multcompare = @(tag, lugType, component, measureID, trackID) ...
    sprintf('%1$s_%2$s_%3$s_multcompare_%4$s_%5$s', tag,  lugType, component, measureID, trackID);

%% Configuration for analyses

% The significance level for the analyses
EXPERIMENT.analysis.alpha = 0.05;
EXPERIMENT.analysis.notSignificantColor = 'lightgrey';
EXPERIMENT.analysis.smallEffect.threshold = 0.06;
EXPERIMENT.analysis.smallEffect.color = 'verylightblue';
EXPERIMENT.analysis.mediumEffect.threshold = 0.14;
EXPERIMENT.analysis.mediumEffect.color = 'lightblue';
EXPERIMENT.analysis.largeEffect.color = 'blue';

% The maximum number of topics to consider in the analyses. If empty, all
% the topics will be considered
%EXPERIMENT.analysis.maxTopic = 5;
EXPERIMENT.analysis.maxTopic = [];

% Type of analyses (tag)
EXPERIMENT.analysis.tse.id = 'tse';
EXPERIMENT.analysis.tse.name = 'Topic/System Effects';
EXPERIMENT.analysis.tse.description = 'Single factor, repeated measures, mixed crossed effects GLMM: topics are random effects (repeated measures/within-subject), systems are fixed effects';
EXPERIMENT.analysis.tse.analyse = @(measures, lugType) tse_analysis(measures, lugType);
EXPERIMENT.analysis.tse.report = @(fid, anovaTable, soa) tse_report(fid, anovaTable, soa);

EXPERIMENT.analysis.tce.id = 'tce';
EXPERIMENT.analysis.tce.name = 'Topic/Component Effects';
EXPERIMENT.analysis.tce.description = 'Three factors, repeated measures, mixed crossed effects GLMM: topics are random effects (repeated measures/within-subject), stop lists, stemmers and/or n-grams, and IR models are fixed effects';
EXPERIMENT.analysis.tce.analyse = @(measures, lugType) tce_analysis(measures, lugType);
EXPERIMENT.analysis.tce.report = @(fid, anovaTable, soa) tce_report(fid, anovaTable, soa);
EXPERIMENT.analysis.tce.plot.mainEffects = @(measures, measureID, trackID, lugType) tce_plot_mainEffects(measures, measureID, trackID, lugType);
EXPERIMENT.analysis.tce.plot.interactionEffects = @(measures, measureID, trackID, lugType) tce_plot_interactionEffects(measures, measureID, trackID, lugType);
EXPERIMENT.analysis.tce.plot.multcompare = @(anovaStats, measureID, trackID, lugType) tce_plot_multcompare(anovaStats, measureID, trackID, lugType);

EXPERIMENT.analysis.tcme.id = 'tcme';
EXPERIMENT.analysis.tcme.name = 'Topic/Component/Measure Effects';
EXPERIMENT.analysis.tcme.description = 'Four factors, repeated measures, mixed crossed effects GLMM: topics are random effects (repeated measures/within-subject), stop lists, stemmers and/or n-grams, IR models, and measures are fixed effects';
EXPERIMENT.analysis.tcme.analyse = @(measures, lugType) tcme_analysis(lugType, measures{:});
EXPERIMENT.analysis.tcme.report = @(fid, anovaTable, soa) tcme_report(fid, anovaTable, soa);
EXPERIMENT.analysis.tcme.plot.mainEffects = @(trackID, lugType, measures) tcme_plot_mainEffects(trackID, lugType, measures{:});
EXPERIMENT.analysis.tcme.plot.interactionEffects = @(trackID, lugType, measures) tcme_plot_interactionEffects(trackID, lugType, measures{:});
EXPERIMENT.analysis.tcme.plot.multcompare = @(anovaStats, trackID, lugType) tcme_plot_multcompare(anovaStats, trackID, lugType);

