
clear all
close all

%% Defining Participants 
cd /Users/administrator/Documents/Data/Placebo_1/Phone_data

Subjects = textread(['/Users/administrator/Documents/Postdoc/Matlab/Matlab/list/Subjects.txt'],'%s'); %all participants
is = length(Subjects);


for i = 1:is;
%% Importing Data
PainRatings = importdata(['/Users/administrator/Documents/Data/Placebo_1/Phone_data/' Subjects{i} '/visit6/PainRatings.txt']);
Timeline = importdata(['/Users/administrator/Documents/Data/Placebo_1/Phone_data/' Subjects{i} '/visit6/timeline.txt']);

%% Organizing the Data
Period{1} = find(PainRatings(:,1) < Timeline(2,1));%Baseline
Period{2} = find(PainRatings(:,1) < Timeline(3,1) & PainRatings(:,1) > Timeline(2,1));%Tx1_all
x = length(Period{2})/2;
Period{3} = Period{2}(1:x,1);%Tx1_bin1
Period{4} = Period{2}(x+1:end,1);%Tx1_bin2
Period{5} = find(PainRatings(:,1) < Timeline(4,1) & PainRatings(:,1) > Timeline(3,1));%Washout1
Period{6} = find(PainRatings(:,1) < Timeline(5,1) & PainRatings(:,1) > Timeline(4,1));%Tx2_all
x2 = length(Period{6})/2;
Period{7} = Period{6}(1:x2,1);%Tx2_bin1
Period{8} = Period{6}(x2+1:end,1);%Tx2_bin2
Period{9} = find(PainRatings(:,1) < Timeline(5,2) & PainRatings(:,1) > Timeline(5,1));%Washout


%% Comparing Tx with baseline using permutation test
data_tx1{1}= PainRatings(Period{1},2);%Baseline pain ratings
data_tx1{2}= PainRatings(Period{3},2);%Tx1 pain ratings

[stats(i,1), df(i,1), pvals(i,1), surrog] = statcond(data_tx1, 'paired','off','mode', 'perm', 'naccu', 10000); % This is using the Resampling statistical toolkit
end
