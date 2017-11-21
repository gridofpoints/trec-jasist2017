%% tse_analysis
% 
% Computes a single factor, mixed crossed effects, repeated measures GLMM
% considering topics as random factor (repeated measures/within-subject) 
% and systems as fixed factor.

%% Synopsis
%
%   [tbl, stats, soa] = tse_analysis(measures, lugType)
%  
% *Parameters*
%
% * *|measures|* - a set of measures. 
% * *|lugType|* - the type of the lexical unit generator which has to be 
% used to  list systems. The following values can be used: _|lugall|_ to 
% list all the systems; _|stem|_ to list only systems using stemmers; 
%
% *Returns*
%
% * *|tbl|*  - the ANOVA table corresponding to the computed GLMM; 
% * *|stats|* - a struct summarizing statistics about the computed GLMM;
% * *|soa|* - the strength of association for the systems effects.

%% References
% 
% * Doncaster, C. P. and Davey, A. J. H. (2007). _Analysis of Variance and Covariance. 
%   How to Choose and Construct Models for the Life Sciences_. Cambridge University Press, Cambridge, UK.
% * Maxwell, S. and Delaney, H. D. (2004). _Designing Experiments and Analyzing Data. 
%   A Model Comparison Perspective_. Lawrence Erlbaum Asso- ciates, Mahwah (NJ), USA, 2nd edition.
% * Rutherford, A. (2011). _ANOVA and ANCOVA. A GLMM Approach_. John Wiley & Sons, New York, USA, 2nd edition.

%% Information
% 
% * *Author*: <mailto:ferro@dei.unipd.it Nicola Ferro>
% * *Version*: 1.00
% * *Since*: 1.00
% * *Requirements*: Matlab 2015b or higher
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

%%

function [tbl, stats, soa] = tse_analysis(measures, lugType)

    % check the number of input arguments
    narginchk(2, 2);
    
    % load common parameters
    common_parameters
        
    % check that measures is a non-empty table
    validateattributes(measures, {'table'}, {'nonempty'}, '', 'measures', 1);
    
    % check that lugType is a non-empty string
    validateattributes(lugType, ...
        {'char', 'cell'}, {'nonempty', 'vector'}, '', ...
        'lugType');
    
    % check that lugType assumes a valid value
    validatestring(lugType, ...
        EXPERIMENT.taxonomy.lug.list, '', 'lugType');
    
    % remove useless white spaces, if any, and ensure it is a char row
    lugType = char(lower(strtrim(lugType)));
    lugType = lugType(:).'; 
    
    % create the list of systems to be analyzed for the selected LUG type
    switch lugType
        
        case 'lugall'
            % total number of elements in the list
            els = EXPERIMENT.taxonomy.stop.number *  EXPERIMENT.taxonomy.lugall.number * EXPERIMENT.taxonomy.model.number * ...
                EXPERIMENT.taxonomy.ltr.number * EXPERIMENT.taxonomy.query.number;
            
            % the list of systems
            list = cell(1, els);
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number
                for lugall = 1:EXPERIMENT.taxonomy.lugall.number
                    for model = 1:EXPERIMENT.taxonomy.model.number
                        for ltr = 1:EXPERIMENT.taxonomy.ltr.number
                            for query = 1:EXPERIMENT.taxonomy.query.number
                        
                                list{1, currentElement} = createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                                    EXPERIMENT.taxonomy.lugall.id{lugall}, EXPERIMENT.taxonomy.model.id{model}, ...
                                    EXPERIMENT.taxonomy.ltr.id{ltr}, EXPERIMENT.taxonomy.query.id{query});
                                
                                currentElement = currentElement + 1;
                        
                            end; % query
                        end; % ltr
                    end; % model
                end; % lexical units
            end; % stop
            
        case 'stem'
            % total number of elements in the list
            els = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.stem.number * EXPERIMENT.taxonomy.model.number * ...
                EXPERIMENT.taxonomy.ltr.number * EXPERIMENT.taxonomy.query.number;
            
            % the list of systems
            list = cell(1, els);
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number
                for stem = 1:EXPERIMENT.taxonomy.stem.number
                    for model = 1:EXPERIMENT.taxonomy.model.number
                        for ltr = 1:EXPERIMENT.taxonomy.ltr.number
                            for query = 1:EXPERIMENT.taxonomy.query.number
                                
                                list{1, currentElement} = createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                                    EXPERIMENT.taxonomy.stem.id{stem}, EXPERIMENT.taxonomy.model.id{model}, ...
                                    EXPERIMENT.taxonomy.ltr.id{ltr}, EXPERIMENT.taxonomy.query.id{query});
                                
                                currentElement = currentElement + 1;
                                
                            end; % query
                        end; % ltr
                    end; % model
                end; % stem
            end; % stop
            
        case 'grams'
            % total number of elements in the list
            els = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.grams.number * EXPERIMENT.taxonomy.model.number  * ...
                EXPERIMENT.taxonomy.ltr.number * EXPERIMENT.taxonomy.query.number;
            
            % the list of systems
            list = cell(1, els);
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number
                for grams = 1:EXPERIMENT.taxonomy.grams.number
                    for model = 1:EXPERIMENT.taxonomy.model.number
                        for ltr = 1:EXPERIMENT.taxonomy.ltr.number
                            for query = 1:EXPERIMENT.taxonomy.query.number
                                
                                list{1, currentElement} = createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                                    EXPERIMENT.taxonomy.grams.id{grams}, EXPERIMENT.taxonomy.model.id{model}, ...
                                    EXPERIMENT.taxonomy.ltr.id{ltr}, EXPERIMENT.taxonomy.query.id{query});
                                
                                currentElement = currentElement + 1;
                                
                            end; % query
                        end; % ltr
                    end; % model
                end; % grams
            end; % stop
            
        otherwise
            error('Unexpected lexical unit generator type.');
    end;
    
    
    % select only the requested systems
    measures = measures(:, list);
    
    % if a maximum number of topics to be analysed is speficied, reduce the 
    % dataset to that number 
    if ~isempty(EXPERIMENT.analysis.maxTopic)
        measures = measures(1:EXPERIMENT.analysis.maxTopic, : );
    end;
    
    % get the labels of the topics
    topics = measures.Properties.RowNames;
    topics = topics(:).';
    m = length(topics);
    
    % get the labels of the systems
    systems = measures.Properties.VariableNames;
    systems = systems(:).';
    p = length(systems);
    
    % extract all the data as a row vector
    data = measures{:, :}(:);
    
    N = length(data);
    
    % define the grouping variables
    topics = repmat(topics, 1, p);
    systems = repmat(systems, m, 1);
    systems = reshape(systems, 1, m*p);

    % compute a 1-way ANOVA with repeated measures and mixed effects, 
    % considering topics as random effects and systems as fixed effects
    [~, tbl, stats] = anovan(data, {topics, systems}, 'Model', 'linear', ...
        'VarNames', {'Topics', 'Systems'}, ...
        'alpha', EXPERIMENT.analysis.alpha, 'display', 'off');
    
    df_topics = tbl{2, 3};
    ss_topics = tbl{2, 2};
    F_topics = tbl{2, 6};
    
    df_systems = tbl{3, 3};
    ss_systems = tbl{3, 2};
    F_systems = tbl{3, 6};
    
    ss_error = tbl{4, 2};
    df_error = tbl{4, 3};
    
    ss_total = tbl{5, 2};
    
    % compute the strength of association
    soa.omega2.topics = df_topics * (F_topics - 1) / (df_topics * F_topics + df_error + 1);
    soa.omega2p.topics = df_topics * (F_topics - 1) / (df_topics * (F_topics - 1) + N);
    
    soa.eta2.topics = ss_topics / ss_total;
    soa.eta2p.topics = ss_topics / (ss_topics + ss_error);    
    
    
    soa.omega2.systems = df_systems * (F_systems - 1) / (df_systems * F_systems + df_error + 1);
    soa.omega2p.systems = df_systems * (F_systems - 1) / (df_systems * (F_systems - 1) + N);
    
    soa.eta2.systems = ss_systems / ss_total;
    soa.eta2p.systems = ss_systems / (ss_systems + ss_error);    
end

