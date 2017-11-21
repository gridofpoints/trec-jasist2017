%% tcme_analysis
% 
% Computes a four factors, mixed effects, repeated measures GLMM
% considering topics as random factor (repeated measures/within-subject) 
% and system components and measures as fixed factors.

%% Synopsis
%
%   [tbl, stats, soa] = tcme_analysis(lugType, varargin)
%  
% *Parameters*
%
% * *|lugType|* - the type of the lexical unit generator which has to be 
% used to  list systems. The following values can be used: _|lugall|_ to 
% list all the systems; _|stem|_ to list only systems using stemmers;  
% _|grams|_ to list only systems using n-grams.
% * *|varargin|* - a variable number of sets of measures. 
%
% *Returns*
%
% * *|tbl|*  - the ANOVA table corresponding to the computed GLMM; 
% * *|stats|* - a struct summarizing statistics about the computed GLMM;
% * *|soa|* - the strength of association for the systems effect.

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

function [tbl, stats, soa] = tcme_analysis(lugType, varargin)

    % check the number of input arguments
    narginchk(1, inf);
    
    % load common parameters
    common_parameters
    
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

    % number of measures
    s = length(varargin);
    
    % check input tables 
    for v = 1:s        
        % ensure we have a table of measures as input
        validateattributes(varargin{v}, {'table'}, {'nonempty'}, '', 'measures', 1);
            
        measures = varargin{v};
        
        % if a maximum number of topics to be analysed is speficied, reduce 
        % the dataset to that number
        if ~isempty(EXPERIMENT.analysis.maxTopic)                                    
            measures = measures(1:EXPERIMENT.analysis.maxTopic, : );                        
        end;
        
        % normalize with respect to their maximum to make them comparable
        measures{:, :} = measures{:, :}/max(max(measures{:, :}));
        
        varargin{v} = measures;
                
    end;
    
    % get the labels of the topics (subjects/cell contents)
    topics = varargin{1}.Properties.RowNames;
    topics = topics(:).';
    m = length(topics);
  
    switch lugType
        
        case 'lugall'
            % total number of elements in the list
            N = EXPERIMENT.taxonomy.stop.number *  EXPERIMENT.taxonomy.lugall.number * EXPERIMENT.taxonomy.model.number * ...
                EXPERIMENT.taxonomy.ltr.number * EXPERIMENT.taxonomy.query.number * m * s;
            
            % preallocate vectors
            data = NaN(1, N);      % the data
            subject = cell(1, N);  % grouping variable for the subjects (topics)
            factorA = cell(1, N);  % grouping variable for factorA (stop list)
            factorB = cell(1, N);  % grouping variable for factorB (lugall)
            factorC = cell(1, N);  % grouping variable for factorC (model)
            factorD = cell(1, N);  % grouping variable for factorD (measure)
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number % factorA
                for lugall = 1:EXPERIMENT.taxonomy.lugall.number % factorB
                    for model = 1:EXPERIMENT.taxonomy.model.number % factorC
                        for ltr = 1:EXPERIMENT.taxonomy.ltr.number
                            for query = 1:EXPERIMENT.taxonomy.query.number
                                for measure = 1:s % factorD
                                    
                                    range = (currentElement-1)*m+1:currentElement*m;
                                    
                                    % copy the measures in the correct range of the data
                                    data(range) = varargin{measure}{:, createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                                        EXPERIMENT.taxonomy.lugall.id{lugall}, EXPERIMENT.taxonomy.model.id{model}, ...
                                        EXPERIMENT.taxonomy.ltr.id{ltr}, EXPERIMENT.taxonomy.query.id{query})};
                                    
                                    % set the correct grouping variables
                                    subject(range) = topics;
                                    factorA(range) = EXPERIMENT.taxonomy.stop.id(stop);
                                    factorB(range) = EXPERIMENT.taxonomy.lugall.id(lugall);
                                    factorC(range) = EXPERIMENT.taxonomy.model.id(model);
                                    factorD(range) = {varargin{measure}.Properties.UserData.name};
                                    
                                    % increment the current element counter
                                    currentElement = currentElement + 1;
                                    
                                end % measure
                            end; % query
                        end; % ltr
                    end; % model
                end; % stem
            end; % stop
            
        case 'stem'
            
            % total number of elements in the list
            N = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.stem.number * EXPERIMENT.taxonomy.model.number * ...
                EXPERIMENT.taxonomy.ltr.number * EXPERIMENT.taxonomy.query.number * m * s;
            
            % preallocate vectors
            data = NaN(1, N);      % the data
            subject = cell(1, N);  % grouping variable for the subjects (topics)
            factorA = cell(1, N);  % grouping variable for factorA (stop list)
            factorB = cell(1, N);  % grouping variable for factorB (stemmer)
            factorC = cell(1, N);  % grouping variable for factorC (model)
            factorD = cell(1, N);  % grouping variable for factorD (measure)
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number % factorA
                for stem = 1:EXPERIMENT.taxonomy.stem.number % factorB
                    for model = 1:EXPERIMENT.taxonomy.model.number % factorC
                        for ltr = 1:EXPERIMENT.taxonomy.ltr.number
                            for query = 1:EXPERIMENT.taxonomy.query.number
                                for measure = 1:s % factorD
                                    
                                    range = (currentElement-1)*m+1:currentElement*m;
                                    
                                    % copy the measures in the correct range of the data
                                    data(range) = varargin{measure}{:, createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                                        EXPERIMENT.taxonomy.stem.id{stem}, EXPERIMENT.taxonomy.model.id{model}, ...
                                        EXPERIMENT.taxonomy.ltr.id{ltr}, EXPERIMENT.taxonomy.query.id{query})};
                                    
                                    % set the correct grouping variables
                                    subject(range) = topics;
                                    factorA(range) = EXPERIMENT.taxonomy.stop.id(stop);
                                    factorB(range) = EXPERIMENT.taxonomy.stem.id(stem);
                                    factorC(range) = EXPERIMENT.taxonomy.model.id(model);
                                    factorD(range) = {varargin{measure}.Properties.UserData.name};
                                    
                                    % increment the current element counter
                                    currentElement = currentElement + 1;
                                    
                                end % measure
                            end; % query
                        end; % ltr
                    end; % model
                end; % stem
            end; % stop
            
        case 'grams'
            % total number of elements in the list
            N = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.grams.number * EXPERIMENT.taxonomy.model.number  * ...
                EXPERIMENT.taxonomy.ltr.number * EXPERIMENT.taxonomy.query.number * m * s;
            
            % preallocate vectors
            data = NaN(1, N);      % the data
            subject = cell(1, N);  % grouping variable for the subjects (topics)
            factorA = cell(1, N);  % grouping variable for factorA (stop list)
            factorB = cell(1, N);  % grouping variable for factorB (grams)
            factorC = cell(1, N);  % grouping variable for factorC (model)
            factorD = cell(1, N);  % grouping variable for factorD (measure)
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number % factorA
                for grams = 1:EXPERIMENT.taxonomy.grams.number % factorB
                    for model = 1:EXPERIMENT.taxonomy.model.number % factorC
                        for ltr = 1:EXPERIMENT.taxonomy.ltr.number
                            for query = 1:EXPERIMENT.taxonomy.query.number
                                for measure = 1:s % factorD
                                    
                                    range = (currentElement-1)*m+1:currentElement*m;
                                    
                                    % copy the measures in the correct range of the data
                                    data(range) = varargin{measure}{:, createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                                        EXPERIMENT.taxonomy.grams.id{grams}, EXPERIMENT.taxonomy.model.id{model}, ...
                                        EXPERIMENT.taxonomy.ltr.id{ltr}, EXPERIMENT.taxonomy.query.id{query})};
                                    
                                    % set the correct grouping variables
                                    subject(range) = topics;
                                    factorA(range) = EXPERIMENT.taxonomy.stop.id(stop);
                                    factorB(range) = EXPERIMENT.taxonomy.grams.id(grams);
                                    factorC(range) = EXPERIMENT.taxonomy.model.id(model);
                                    factorD(range) = {varargin{measure}.Properties.UserData.name};
                                    
                                    % increment the current element counter
                                    currentElement = currentElement + 1;
                                    
                                end % measure
                            end; % query
                        end; % ltr
                    end; % model
                end; % stem
            end; % stop
            
        otherwise
            error('Unexpected component type');
    end;
    
    % the model = Topic + Stop + Stem + Model + Measure + Stop*Stem + Stop*Model +
    % Stop*Measure + Stem*Model + Stem*Measure + Model*Measure 
    m = [1 0 0 0 0; ...
         0 1 0 0 0; ...
         0 0 1 0 0; ...
         0 0 0 1 0; ...
         0 0 0 0 1; ...
         0 1 1 0 0; ...
         0 1 0 1 0; ...
         0 1 0 0 1; ...
         0 0 1 1 0; ...
         0 0 1 0 1; ...
         0 0 0 1 1];
    
    
    % compute a 4-way ANOVA with repeated measures and mixed effects, 
    % considering topics as random effects and stop lists, stemmers, 
    % models, and measures as fixed effects
    [~, tbl, stats] = anovan(data, {subject, factorA, factorB, factorC, factorD}, 'Model', m, ...
        'VarNames', {'Topics', EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugType).name, EXPERIMENT.taxonomy.model.name, 'Measures'}, ...
        'alpha', EXPERIMENT.analysis.alpha, 'display', 'off');
    
    df_stop = tbl{3,3};
    ss_stop = tbl{3,2};
    F_stop = tbl{3,6};
    
    df_stem = tbl{4,3};
    ss_stem = tbl{4,2};
    F_stem = tbl{4,6};
    
    df_model = tbl{5,3};
    ss_model = tbl{5,2};
    F_model = tbl{5,6};
    
    df_measure = tbl{6,3};
    ss_measure = tbl{6,2};
    F_measure = tbl{6,6};
    
    df_stop_stem = tbl{7,3};
    ss_stop_stem = tbl{7,2};
    F_stop_stem = tbl{7,6};
    
    df_stop_model = tbl{8,3};
    ss_stop_model = tbl{8,2};
    F_stop_model = tbl{8,6};
    
    df_stop_measure = tbl{9,3};
    ss_stop_measure = tbl{9,2};
    F_stop_measure = tbl{9,6};
    
    df_stem_model = tbl{10,3};
    ss_stem_model = tbl{10,2};
    F_stem_model = tbl{10,6};
    
    df_stem_measure = tbl{11,3};
    ss_stem_measure = tbl{11,2};
    F_stem_measure = tbl{11,6};
    
    df_model_measure = tbl{12,3};
    ss_model_measure = tbl{12,2};
    F_model_measure = tbl{12,6};
    
    ss_error = tbl{13, 2};
    df_error = tbl{13, 3};
    
    ss_total = tbl{14, 2};
    
    % compute the strength of association
    soa.omega2.stop = df_stop * (F_stop - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
    soa.omega2.stem = df_stem * (F_stem - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
    soa.omega2.model = df_model * (F_model - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
    soa.omega2.measure = df_measure * (F_measure - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
    soa.omega2.stop_stem = df_stop_stem * (F_stop_stem - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
    soa.omega2.stop_model = df_stop_model * (F_stop_model - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
    soa.omega2.stop_measure = df_stop_measure * (F_stop_measure - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
    soa.omega2.stem_model = df_stem_model * (F_stem_model - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
    soa.omega2.stem_measure = df_stem_measure * (F_stem_measure - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
    soa.omega2.model_measure = df_model_measure * (F_model_measure - 1) / (df_stop * F_stop + df_stem * F_stem + df_model * F_model + df_measure * F_measure + df_stop_stem * F_stop_stem + df_stop_model * F_stop_model + df_stop_measure * F_stop_measure + df_stem_model * F_stem_model +  df_stem_measure * F_stem_measure + df_model_measure * F_model_measure + df_error + 1);
        
    soa.omega2p.stop = df_stop * (F_stop - 1) / (df_stop * (F_stop - 1) + N);
    soa.omega2p.stem =  df_stem * (F_stem - 1) / (df_stem * (F_stem - 1) + N);
    soa.omega2p.model = df_model * (F_model - 1) / (df_model * (F_model - 1) + N);
    soa.omega2p.measure = df_measure * (F_measure - 1) / (df_measure * (F_measure - 1) + N);
    soa.omega2p.stop_stem = df_stop_stem * (F_stop_stem - 1) / (df_stop_stem * (F_stop_stem - 1) + N);
    soa.omega2p.stop_model = df_stop_model * (F_stop_model - 1) / (df_stop_model * (F_stop_model - 1) + N);
    soa.omega2p.stop_measure = df_stop_measure * (F_stop_measure - 1) / (df_stop_measure * (F_stop_measure - 1) + N);
    soa.omega2p.stem_model = df_stem_model * (F_stem_model - 1) / (df_stem_model * (F_stem_model - 1) + N);
    soa.omega2p.stem_measure = df_stem_measure * (F_stem_measure - 1) / (df_stem_measure * (F_stem_measure - 1) + N);
    soa.omega2p.model_measure = df_model_measure * (F_model_measure - 1) / (df_model_measure * (F_model_measure - 1) + N);

    soa.eta2.stop = ss_stop / ss_total;
    soa.eta2.stem = ss_stem / ss_total;
    soa.eta2.model = ss_model / ss_total;
    soa.eta2.measure = ss_measure / ss_total;
    soa.eta2.stop_stem = ss_stop_stem / ss_total;
    soa.eta2.stop_model = ss_stop_model / ss_total;
    soa.eta2.stop_measure = ss_stop_measure / ss_total;
    soa.eta2.stem_model = ss_stem_model / ss_total;
    soa.eta2.stem_measure = ss_stem_measure / ss_total;
    soa.eta2.model_measure = ss_model_measure / ss_total;
        
    soa.eta2p.stop = ss_stop / (ss_stop + ss_error);
    soa.eta2p.stem = ss_stem / (ss_stem + ss_error);
    soa.eta2p.model = ss_model / (ss_model + ss_error);
    soa.eta2p.measure = ss_measure / (ss_measure + ss_error);
    soa.eta2p.stop_stem = ss_stop_stem / (ss_stop_stem + ss_error);
    soa.eta2p.stop_model = ss_stop_model / (ss_stop_model + ss_error);
    soa.eta2p.stop_measure = ss_stop_measure / (ss_stop_measure + ss_error);
    soa.eta2p.stem_model = ss_stem_model / (ss_stem_model  + ss_error);
    soa.eta2p.stem_measure = ss_stem_measure / (ss_stem_measure  + ss_error);
    soa.eta2p.model_measure = ss_model_measure / (ss_model_measure  + ss_error);    
end

