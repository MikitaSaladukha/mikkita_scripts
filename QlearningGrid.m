GW = createGridWorld(17,17,'Kings');
GW.CurrentState = '[12,8]';
GW.TerminalStates = '[2,12]';
GW.ObstacleStates = ["[6,1]";"[6,2]";"[6,3]";"[6,4]";"[6,5]";"[6,6]";"[6,7]";"[6,8]";"[6,9]";"[6,10]";"[6,11]";"[6,12]";"[6,13]";"[7,1]";"[7,2]";"[7,3]";"[7,4]";"[7,5]";"[7,6]";"[7,7]";"[7,8]";"[7,9]";"[7,10]";"[7,11]";"[7,12]";"[7,13]";"[5,1]";"[5,2]";"[5,3]";"[5,4]";"[5,5]";"[5,6]";"[5,7]";"[5,8]";"[5,9]";"[5,10]";"[5,11]";"[5,12]";"[5,13]"];
updateStateTranstionForObstacles(GW);
nS = numel(GW.States);
nA = numel(GW.Actions);
GW.R = -1*ones(nS,nS,nA);
GW.R(:,state2idx(GW,GW.TerminalStates),:) = 500;
% 
% GW.R(:,state2idx(GW,'[6,15]'),:) = 1;
% GW.R(:,state2idx(GW,'[6,16]'),:) = 3;
 GW.R(state2idx(GW,"[6,16]"),state2idx(GW,"[5,16]"),:) =20; %SARSA all commented, Q-learning - 1.75, DQN - 20
  GW.R(state2idx(GW,"[6,16]"),state2idx(GW,"[5,15]"),:) = 20; %SARSA all commented, Q-learning - 1.75, DQN - 20
% GW.R(:,state2idx(GW,'[6,17]'),:) = 1;

env = rlMDPEnv(GW);
%plot(env)
env.ResetFcn = @() 131;
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
% trainOpts.MaxStepsPerEpisode = 1499;
% trainOpts.MaxEpisodes= 3000;
% trainOpts.StopTrainingCriteria = "AverageReward";
% trainOpts.StopTrainingValue = 450;
% trainOpts.ScoreAveragingWindowLength = 30;
% trainingStats = train(qAgent,env,trainOpts)
% plot(env);
% env.Model.Viewer.ShowTrace = true;
% env.Model.Viewer.clearTrace;
% mysim=sim(qAgent,env)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% agentOpts = rlSARSAAgentOptions;
% agentOpts.EpsilonGreedyExploration.Epsilon = .04;
% qAgent = rlSARSAAgent(qRepresentation,agentOpts);
% trainOpts = rlTrainingOptions;
% trainOpts.MaxStepsPerEpisode = 1499;
% trainOpts.MaxEpisodes= 3000;
% trainOpts.StopTrainingCriteria = "AverageReward";
% trainOpts.StopTrainingValue = 450;
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
    'UseDoubleDQN',true, ...
    'TargetSmoothFactor',5e-3, ...
    'ExperienceBufferLength',1e6, ...
    'SequenceLength',20);
agentOptions.EpsilonGreedyExploration.EpsilonDecay = 1e-4;

qAgent = rlDQNAgent(critic,agentOptions);
% 
% %agentOpts =rlDQNAgentOptions;
% %agentOpts.EpsilonGreedyExploration.Epsilon = .04;
% %agentOpts.SequenceLength=2;
% %initOpts=rlAgentInitializationOptions;
% %initOpts.UseRNN=true;
% %qAgent = rlDQNAgent(getObservationInfo(env),getActionInfo(env),initOpts);
% %qAgent=rlDQNAgent(getCritic(qAgent),agentOpts);
% %net=googlenet('Weights','none');
% %critic = rlQValueRepresentation(net,getObservationInfo(env),getActionInfo(env),'ObservationNames',net.Layers(1));
% %qAgent=rlDQNAgent(critic,agentOpts);


trainOpts = rlTrainingOptions;
trainOpts.MaxStepsPerEpisode = 1499;%16000;
trainOpts.MaxEpisodes= 1000;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 450;
trainOpts.ScoreAveragingWindowLength = 30;
trainingStats = train(qAgent,env,trainOpts)
plot(env);
env.Model.Viewer.ShowTrace = true;
env.Model.Viewer.clearTrace;
mysim=sim(qAgent,env)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 
%%TimeIsdoneData=mysim.IsDone.Time
% TimeIsdoneDataInfo=mysim.IsDone.TimeInfo
%%TimeActionData=mysim.Action.MDPActions.Time
% TimeActionDataInfo=mysim.Action.MDPActions.TimeInfo
lengthmy1=length(mysim.IsDone.Time)
lengthmy2=length(mysim.Action.MDPActions.Time) %кол-во шагов действий 
%isdoneData=mysim.IsDone.Data
%isdoneDataInfo=mysim.IsDone.DataInfo
actionData=mysim.Action.MDPActions.Data % действия
% действия ['N';'S';'E';'W';'NE';'NW';'SE';'SW'] = [1='N';2='S';3='E';4='W';5='NE';6='NW';7='SE';8='SW']


%actionDataInfo=mysim.Action.MDPActions.DataInfo

%events=mysim.Observation.MDPObservations.Events.Data
%observations=mysim.Observation.MDPObservations
%simInfo=mysim.SimulationInfo
%simInfoTrain=trainingStats.SimulationInfo



