function r=checkStop()
velocity = 0.08;     % meters per second
robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
velMsg = rosmessage(robotCmd);
%velMsg.Linear.Y = velocity;
velMsg.Linear.X = velocity;
send(robotCmd,velMsg);
tic
while toc<1
end

velocity = 0;     % meters per second
robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
velMsg = rosmessage(robotCmd);
%velMsg.Linear.Y = velocity;
velMsg.Linear.X = velocity;
send(robotCmd,velMsg);

laserSub = rossubscriber("/scan","DataFormat","struct");
scanMsg = receive(laserSub);
scan = rosReadLidarScan(scanMsg);
    %plot(scan);
ranges=scan.Ranges;
angles=rad2deg(scan.Angles);
minR=min(ranges);
index=find(ranges==minR);
checkSize=length(index)>3;
checkMin=minR>0.23;
if xor(checkSize,checkMin)
    velocity = -0.08;     % meters per second
    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    %velMsg.Linear.Y = velocity;
    velMsg.Linear.X = velocity;
    send(robotCmd,velMsg);
    tic
    while toc<1
    end
    velocity = 0;     % meters per second
    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    %velMsg.Linear.Y = velocity;
    velMsg.Linear.X = velocity;
    send(robotCmd,velMsg);
end
%plot(scan)
    exactness=1;
    odomSub = rossubscriber("/odom","DataFormat","struct");
    odomMsg = receive(odomSub,3);
    pose = odomMsg.Pose.Pose;
    quat = pose.Orientation;
    angles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]));
    angleCurrent=angles(1);

    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    velMsg.Angular.Z=exactness*0.3*sign(0-angleCurrent);
    send(robotCmd,velMsg);
    while abs(angleCurrent)>1.5*exactness 

        odomSub = rossubscriber("/odom","DataFormat","struct");
        odomMsg = receive(odomSub,3);
        pose = odomMsg.Pose.Pose;
        quat = pose.Orientation;
        angles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]));
        angleCurrent=angles(1);
           

    end
    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    velMsg.Angular.Z=0;   
    velMsg.Linear.X = 0;   
    send(robotCmd,velMsg)

    laserSub = rossubscriber("/scan","DataFormat","struct");
    scanMsg = receive(laserSub);
    scan = rosReadLidarScan(scanMsg);
    %plot(scan);
    ranges=scan.Ranges;
    angles=rad2deg(scan.Angles);
    minR=min(ranges);
    index=find(ranges<0.27);
    angle=angles(index);
    result="";
    error=15;
    for i=1:length(angle)
        myAngle=angles(i);
        
            if abs(angle(i))<error
                result=result+"N";
            end
            if ((angle(i)>0)&& (abs(angle(i)-180)<error))     
                result=result+"S";
            end
            if ( (angle(i)<0) && (abs(angle(i)+180)<error) )      
                result=result+"S";
            end
            if ((angle(i)<0) && (abs(angle(i)+90)<error))    
                result=result+"E";
            end
            if ((angle(i)>0) && (abs(angle(i)-90)<error))     
                result=result+"W";                
            end
        
    end

r=result;
end
