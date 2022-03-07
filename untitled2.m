velocity = 0;     % meters per second
robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
velMsg = rosmessage(robotCmd);
%velMsg.Linear.Y = velocity;
velMsg.Linear.X = velocity;
velMsg.Angular.Z=0;
send(robotCmd,velMsg);
%gzworld("reset")
%goToExact(1);
%checkStop;


% laserSub = rossubscriber("/scan","DataFormat","struct");
% scanMsg = receive(laserSub);
% scan = rosReadLidarScan(scanMsg);
% plot(scan);
% ranges=scan.Ranges;
% angles=rad2deg(scan.Angles);
% minR=min(ranges)
% index=find(ranges<0.23)
% angles(index)
% ranges(index)

% for i=1:360
%     if (ranges(i)<1)
%        fprintf('too close: angle = %f\n',  angles(i));
%     end
% end

%     tic
%     while toc<100
%         odomSub = rossubscriber("/odom","DataFormat","struct");
%         odomMsg = receive(odomSub,3);
%         pose = odomMsg.Pose.Pose;
%         quat = pose.Orientation;
%         angles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]));
%         angleCurrent=angles(1);
%         if angleCurrent<0 
%             angleCurrent2=360+angleCurrent;
%         else
%             angleCurrent2=angleCurrent;
%         end
%         ang=getAngle;
% 
%         [angleCurrent angleCurrent2 ang]
%     end
