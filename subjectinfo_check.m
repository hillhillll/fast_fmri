function [fname, start_line, SID, SessID] = subjectinfo_check(savedir, varargin)

% Get subject information, and check if the data file exists?
%
% :Usage:
% ::
%     [fname, start_line, SID] = subjectinfo_check(savedir, varargin)
%
%
% :Inputs:
%
%   **savedir:**
%       The directory where you save the data
%
% :Optional Inputs: 
%
%   **'task':** 
%       Check the data file for fast_task_main.m
%
%   **'survey':**
%       Check the data file for fast_survey_main.m
%
% ..
%    Copyright (C) 2017  Wani Woo (Cocoan lab)
% ..

%% SETUP: varargin
task = false;
survey = false;
word = false;

for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'word'}
                word = true;
            case {'task'}
                task = true;
            case {'survey'}
                survey = true;
        end
    end
end

%% Get subject ID    
fprintf('\n');
SID = input('Subject ID (number)? ', 's');
SessID = input('Session number? ', 's');
    
%% Check if the data file exists
if word
    fname = fullfile(savedir, ['a_worddata_sub' SID '_sess' SessID '.mat']);
elseif task
    fname = fullfile(savedir, ['c_taskdata_sub' SID '_sess' SessID '.mat']);
elseif survey
    fname = fullfile(savedir, ['d_surveydata_sub' SID '_sess' SessID '.mat']);
else
    error('Unknown input');
end

%% What to do if the file exists?
if ~exist(savedir, 'dir')
    
    mkdir(savedir);
    whattodo = 1;

else
    
    if exist(fname, 'file')
        str = ['The Subject ' SID ' data file exists. Press a button for the following options'];
        disp(str);
        whattodo = input('1:Save new file, 2:Save the data from where we left off, Ctrl+C:Abort? ');
    else
        whattodo = 1;
    end
    
end
    
%% If we want to start the task from where we left off

if (whattodo == 2 && task) || (whattodo == 2 && word)
    
    error('You need to start from the beginning. Please check the file, and choose 1:Save new file. next time');
    
elseif whattodo == 2 && survey
    
    temp = load(fname);
    temp_f = fields(temp);
    eval(['temp = temp.' temp_f{1} ';']);
    
    if task
        
        start_line(1) = numel(temp.audiodata);
        
    elseif survey
        
        start_line(1) = numel(temp.dat);
        start_line(2) = numel(temp.dat{start_line(2)});
        
    end
     
else
    start_line = 1;
end
   
end