
GW = createGridWorld(33,33,'Kings');
GW.CurrentState = '[23,15]';
GW.TerminalStates = '[7,21]';
GW.ObstacleStates = ["[12,1]";"[12,2]";"[12,3]";"[12,4]";"[12,5]";"[12,6]";"[12,7]";"[12,8]";"[12,9]";"[12,10]";"[12,11]";"[12,12]";"[12,13]";"[12,14]";"[12,15]";"[12,16]";"[12,17]";"[12,18]";"[12,19]";"[12,20]";"[12,21]";"[12,22]";"[12,23]";"[12,24]";"[13,1]";"[13,2]";"[13,3]";"[13,4]";"[13,5]";"[13,6]";"[13,7]";"[13,8]";"[13,9]";"[13,10]";"[13,11]";"[13,12]";"[13,13]";"[13,14]";"[13,15]";"[13,16]";"[13,17]";"[13,18]";"[13,19]";"[13,20]";"[13,21]";"[13,22]";"[13,23]";"[13,24]";"[11,1]";"[11,2]";"[11,3]";"[11,4]";"[11,5]";"[11,6]";"[11,7]";"[11,8]";"[11,9]";"[11,10]";"[11,11]";"[11,12]";"[11,13]";"[11,14]";"[11,15]";"[11,16]";"[11,17]";"[11,18]";"[11,19]";"[11,20]";"[11,21]";"[11,22]";"[11,23]";"[11,24]"]
updateStateTranstionForObstacles(GW);
nS = numel(GW.States);
nA = numel(GW.Actions);
GW.R = -1*ones(nS,nS,nA);
GW.R(:,state2idx(GW,GW.TerminalStates),:) = 500;
% 
% 
GW.R(state2idx(GW,"[14,22]"),state2idx(GW,"[14,23]"),:) =25;%075; 
GW.R(state2idx(GW,"[14,23]"),state2idx(GW,"[14,24]"),:) =25;%1,75625;%075; 
GW.R(state2idx(GW,"[14,24]"),state2idx(GW,"[14,25]"),:) =25;%1.75625;%075; 
GW.R(state2idx(GW,"[14,25]"),state2idx(GW,"[14,26]"),:) =25;%1.75625;%075;

GW.R(state2idx(GW,"[12,25]"),state2idx(GW,"[11,26]"),:) =25;%1.75625;%075; 
GW.R(state2idx(GW,"[13,26]"),state2idx(GW,"[12,26]"),:) =25;%1.75625;%075;
GW.R(state2idx(GW,"[13,25]"),state2idx(GW,"[12,25]"),:) =25;%1.75625;%075;

GW.R(state2idx(GW,"[16,21]"),state2idx(GW,"[16,22]"),:) =25; % 1.001 for Q
GW.R(state2idx(GW,"[16,21]"),state2idx(GW,"[15,22]"),:) =25; % 1.001 for Q
GW.R(state2idx(GW,"[16,20]"),state2idx(GW,"[15,21]"),:) =25; % 1.001 for Q
GW.R(state2idx(GW,"[17,19]"),state2idx(GW,"[16,20]"),:) = 25; % 1.001 for Q
GW.R(state2idx(GW,"[17,18]"),state2idx(GW,"[16,19]"),:) = 25; % 1.001 for Q
% GW.R(:,state2idx(GW,'[6,17]'),:) = 1;

env = rlMDPEnv(GW);
%plot(env)
env.ResetFcn = @() 485;
rng(0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% qTable = rlTable(getObservationInfo(env),getActionInfo(env));
% qRepresentation = rlQValueRepresentation(qTable,getObservationInfo(env),getActionInfo(env));
% qRepresentation.Options.LearnRate = 1;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% agentOpts = rlQAgentOptions;
% agentOpts.EpsilonGreedyExploration.Epsilon = .04;
% qAgent = rlQAgent(qRepresentation,agentOpts);
% trainOpts = rlTrainingOptions;
% trainOpts.MaxStepsPerEpisode = 9900;
% trainOpts.MaxEpisodes= 800;
% trainOpts.StopTrainingCriteria = "AverageReward";
% trainOpts.StopTrainingValue = 470;
% trainOpts.ScoreAveragingWindowLength = 30;
% trainingStats = train(qAgent,env,trainOpts)
% plot(env);
% env.Model.Viewer.ShowTrace = true;
% env.Model.Viewer.clearTrace;
% mysim=sim(qAgent,env)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% agentOpts = rlSARSAAgentOptions;
% agentOpts.EpsilonGreedyExploration.Epsilon = .04;
% qAgent = rlSARSAAgent(qRepresentation,agentOpts);
% trainOpts = rlTrainingOptions;
% trainOpts.MaxStepsPerEpisode = 9900;
% trainOpts.MaxEpisodes= 1600;
% trainOpts.StopTrainingCriteria = "AverageReward";
% trainOpts.StopTrainingValue = 470;
% trainOpts.ScoreAveragingWindowLength = 30;
% trainingStats = train(qAgent,env,trainOpts)
% plot(env);
% env.Model.Viewer.ShowTrace = true;
% env.Model.Viewer.clearTrace;
% mysim=sim(qAgent,env)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
criticNetwork = [
    sequenceInputLayer(obsInfo.Dimension(1),'Normalization','none','Name','state')
    fullyConnectedLayer(50, 'Name', 'CriticStateFC1')
    reluLayer('Name','CriticRelu1')
    lstmLayer(20,'OutputMode','sequence','Name','CriticLSTM');
    fullyConnectedLayer(20,'Name','CriticStateFC2')
    reluLayer('Name','CriticRelu2')
    fullyConnectedLayer(numel(actInfo.Elements),'Name','output')];

criticOptions = rlRepresentationOptions('LearnRate',1e-3,'GradientThreshold',1);
critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,...
    'Observation','state',criticOptions);

agentOptions = rlDQNAgentOptions(...
    'UseDoubleDQN',false, ...    
    'ExperienceBufferLength',1e6, ...
    'SequenceLength',33);
agentOptions.EpsilonGreedyExploration.EpsilonDecay = 1e-4;

qAgent = rlDQNAgent(critic,agentOptions);



% 
% agentOpts =rlDQNAgentOptions;
% agentOpts.EpsilonGreedyExploration.Epsilon = .04;
% agentOpts.SequenceLength=2;
% agentOpts.UseDoubleDQN=false;
% initOpts=rlAgentInitializationOptions;
% initOpts.UseRNN=true;
% qAgent = rlDQNAgent(getObservationInfo(env),getActionInfo(env),initOpts);
% qAgent=rlDQNAgent(getCritic(qAgent),agentOpts);
% %net=googlenet('Weights','none');
% %critic = rlQValueRepresentation(net,getObservationInfo(env),getActionInfo(env),'ObservationNames',net.Layers(1));
% %qAgent=rlDQNAgent(critic,agentOpts);


trainOpts = rlTrainingOptions;
trainOpts.MaxStepsPerEpisode = 39900;%16000;
trainOpts.MaxEpisodes= 2000;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 430;
trainOpts.ScoreAveragingWindowLength = 30;
trainingStats = train(qAgent,env,trainOpts)
plot(env);
env.Model.Viewer.ShowTrace = true;
env.Model.Viewer.clearTrace;
mysim=sim(qAgent,env)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% lengthmy1=length(mysim.IsDone.Time)
% lengthmy2=length(mysim.Action.MDPActions.Time) %кол-во шагов действий 
% actionData=mysim.Action.MDPActions.Data % действия
% % действия ['N';'S';'E';'W';'NE';'NW';'SE';'SW'] = [1='N';2='S';3='E';4='W';5='NE';6='NW';7='SE';8='SW']




