function goToE    
    exactness=1
    odomSub = rossubscriber("/odom","DataFormat","struct");
    odomMsg = receive(odomSub,3);
    pose = odomMsg.Pose.Pose;
    quat = pose.Orientation;
    angles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]));
    angleCurrent=angles(1);

    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    velMsg.Angular.Z=exactness*0.3*sign(-90-angleCurrent);
    send(robotCmd,velMsg);
    while abs(angleCurrent+90)>1.5*exactness 

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
    while toc<5
    end
    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    velMsg.Angular.Z=0;   
    velMsg.Linear.X = 0;   
    send(robotCmd,velMsg)
end