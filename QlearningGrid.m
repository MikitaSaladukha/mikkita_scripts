GW = createGridWorld(17,17,'Kings');
GW.CurrentState = '[12,8]';
GW.TerminalStates = '[2,7]';
GW.ObstacleStates = ["[6,1]";"[6,2]";"[6,3]";"[6,4]";"[6,5]";"[6,6]";"[6,7]";"[6,8]";"[6,9]";"[6,10]";"[6,11]";"[6,12]";"[7,1]";"[7,2]";"[7,3]";"[7,4]";"[7,5]";"[7,6]";"[7,7]";"[7,8]";"[7,9]";"[7,10]";"[7,11]";"[7,12]";"[5,1]";"[5,2]";"[5,3]";"[5,4]";"[5,5]";"[5,6]";"[5,7]";"[5,8]";"[5,9]";"[5,10]";"[5,11]";"[5,12]"];
updateStateTranstionForObstacles(GW);
nS = numel(GW.States);
nA = numel(GW.Actions);
GW.R = -1*ones(nS,nS,nA);
GW.R(:,state2idx(GW,GW.TerminalStates),:) = 500;
env = rlMDPEnv(GW);
%plot(env)
env.ResetFcn = @() 131;
rng(0);
qTable = rlTable(getObservationInfo(env),getActionInfo(env));
qRepresentation = rlQValueRepresentation(qTable,getObservationInfo(env),getActionInfo(env));
qRepresentation.Options.LearnRate = 1;
agentOpts = rlQAgentOptions;
agentOpts.EpsilonGreedyExploration.Epsilon = .04;
qAgent = rlQAgent(qRepresentation,agentOpts);
trainOpts = rlTrainingOptions;
trainOpts.MaxStepsPerEpisode = 15000;
trainOpts.MaxEpisodes= 1000;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 400;
trainOpts.ScoreAveragingWindowLength = 30;
trainingStats = train(qAgent,env,trainOpts)
plot(env)
env.Model.Viewer.ShowTrace = true;
env.Model.Viewer.clearTrace;
sim(qAgent,env)