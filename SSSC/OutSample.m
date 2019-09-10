%% **************
% the code is provided to repduce our result reported in our paper [A2]. NOTE THAT [A2] is a journal extension of our AAAI'15 paper [A1].

% [A1] Xi Peng, Zhang Yi, and Huajin Tang,
%      Robust Subspace Clustering via Thresholding Ridge Regression,
%      The Twenty-Ninth AAAI Conference on Artificial Intelligence (AAAI), Austin, Texas, USA, January 25–29, 2015.
% [A2]Xi Peng, Huajin Tang, Lei Zhang, Zhang Yi, and Shijie Xiao,
%     A Unified Framework for Representation-based Subspace Clustering of Out-of-sample and Large-scale Data,
%     IEEE Trans. Neural Networks and Learning Systems, accepted.

% If the codes or data sets are helpful to you, please appropriately CITE our works. Thank you very much!

% More materials can be found from my website:
%            www.pengxi.me,
%     email: pangsaai [at] gmail [dot] com

% This file is used to handle out-of-sample data
%% **************


function Plabel=OutSample(Tr_dat, Tt_dat, Tr_plabel, lambda, tolerance,par)

if par.Classifier==1
    for i = 1:size(Tt_dat,2) % using SRC
        % -- get the sparse coeffient coefficient
        [tmp_x, tmp_iter] = SolveHomotopy(Tr_dat, Tt_dat(:,i), ...
            'maxIteration', par.maxIteration,...
            'isNonnegative', par.isNonnegative, ...
            'lambda', lambda, ...
            'tolerance', tolerance);        
        % -- perform SRC on the coef to produce the label for testing data
        Plabel(i) = SRC_IDcheck(Tr_dat,tmp_x,Tt_dat(:,i),Tr_plabel);
    end;
elseif par.Classifier==2 % using CRC
    kappa = 1e-6;
    Proj_M = (Tr_dat'*Tr_dat+kappa*eye(size(Tr_dat,2)))\Tr_dat';
    %         Proj_M = inv(Tr_dat'*Tr_dat+kappa*eye(size(Tr_dat,2)))*Tt_dat';
    for indTest = 1:size(Tt_dat,2)
        Plabel(indTest) = CRC_IDcheck(Tr_dat,Proj_M,Tt_dat(:,indTest),Tr_plabel);
    end    
end;