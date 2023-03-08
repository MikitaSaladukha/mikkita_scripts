% clear
rosshutdown
ipaddress = "http://localhost:11311";
rosinit(ipaddress)
rostopic list


% folderPath = fullfile(pwd,'customMessage')
% mkdir(folderPath)
% messageDefinition = {'message/home/mikkita/MATLAB/bin/matlab MyPose'
%                      '{'
%                      '   required double x = 1;'
%                      '   required double y = 2;'
%                      '   required double z = 3;'
%                      '}'};
% fileID = fopen(fullfile(folderPath,'MyPose.proto'),'w');
% fprintf(fileID,'%s\n',messageDefinition{:});
% fclose(fileID);
% gazebogenmsg(folderPath)
% addpath(fullfile(folderPath,'install'))
% savepath
%open_system("performCoSimulationWithGazebo")

%packaddpath('/home/mikkita/customMessage/install')
%savepathageGazeboPlugin(fullfile(folderPath,'MyPlugin'),folderPath)

%packageGazeboPlugin('GazeboPlugin')
% 
% open_system("performCoSimulationWithGazebo");
% hilite_system('performCoSimulationWithGazebo/Gazebo Pacer');
% open_system('performCoSimulationWithGazebo/Gazebo Pacer');
%gzinit("192.168.0.105",14581)
gzinit("localhost",14581)
gzworld("reset")

% velocity = 0.1;     % meters per second
% robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
% velMsg = rosmessage(robotCmd);
% velMsg.Linear.X = velocity;
% send(robotCmd,velMsg)