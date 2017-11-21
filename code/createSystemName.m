%% createSystemName
% 
% Creates the name of a system from its components.

%% Synopsis
%
%   [name] = createSystemName(stop, stem, model, ltr, query)
%  
% *Parameters*
%
% * *|stop|* - the stop list; 
% * *|stem|* - the stemmer; 
% * *|model|* - the IR model; 
% * *|ltr|* - the learning to rank model; 
% * *|query|* - the type of query (short, medium, long); 
%
% *Returns*
%
% * *|name|*  - the name of the system.

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

function [name] = createSystemName(stop, stem, model, ltr, query)
    name = sprintf('%1$s_%2$s_%3$s_%4$s_%5$s', stop, stem, model, ltr, query);
end