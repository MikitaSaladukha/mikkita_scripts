function goToSE    
    exactness=0.3
    odomSub = rossubscriber("/odom","DataFormat","struct");
    odomMsg = receive(odomSub,3);
    pose = odomMsg.Pose.Pose;
    quat = pose.Orientation;
    angles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]));
    angleCurrent=angles(1);

    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    if angleCurrent>0
        velMsg.Angular.Z=-exactness*0.3*sign(-135-angleCurrent);
    else
        velMsg.Angular.Z=-exactness*0.3*sign(-135-angleCurrent);
    send(robotCmd,velMsg);
    while abs(angleCurrent+135)>1.5*exactness 

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
    velMsg.Linear.X = 0.2;   
    send(robotCmd,velMsg)
    tic
    while toc<sqrt(2)*5
    end
    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    velMsg.Angular.Z=0;   
    velMsg.Linear.X = 0;   
    send(robotCmd,velMsg)
end