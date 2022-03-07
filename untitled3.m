exactness=1;

    angle=getAngle;

    odomSub = rossubscriber("/odom","DataFormat","struct");
    odomMsg = receive(odomSub,3);
    pose = odomMsg.Pose.Pose;
    quat = pose.Orientation;
    angles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]));
    angleCurrent=angles(1);
    

    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);

    velMsg.Angular.Z=exactness*0.3*sign(angle-angleCurrent);
    send(robotCmd,velMsg);
    [angle angleCurrent]
    while abs(angle-angleCurrent)>1.5*exactness 

        odomSub = rossubscriber("/odom","DataFormat","struct");
        odomMsg = receive(odomSub,3);
        pose = odomMsg.Pose.Pose;
        quat = pose.Orientation;
        angles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]));
        angleCurrent=angles(1);
        angle=getAngle;
        

    end
    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    velMsg.Angular.Z=0;
    send(robotCmd,velMsg);
    [angle angleCurrent]
    
    odomSub = rossubscriber("/odom","DataFormat","struct");
    odomMsg = receive(odomSub,3);
    pose = odomMsg.Pose.Pose;
    xCurrent = pose.Position.X;
    yCurrent = pose.Position.Y;
    xTarget=round(xCurrent);
    yTarget=round(yCurrent);
    
    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg = rosmessage(robotCmd);
    
       
    
    if ((xTarget-xCurrent)<0)
        velMsg.Linear.X = -0.1*exactness;
    else
        velMsg.Linear.X = 0.1*exactness;
    end
    send(robotCmd,velMsg);
    [xCurrent yCurrent xTarget yTarget] 
    while (abs(xCurrent-xTarget)>0.1*exactness || abs(yCurrent-yTarget)>0.1*exactness)

        odomSub = rossubscriber("/odom","DataFormat","struct");
        odomMsg = receive(odomSub,3);
        pose = odomMsg.Pose.Pose;
        xCurrent = pose.Position.X;
        yCurrent = pose.Position.Y;
        xTarget=round(xCurrent);
        yTarget=round(yCurrent);
        %[xCurrent yCurrent xTarget yTarget velMsg.Linear.X]    

    end
    robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
    velMsg.Linear.X = 0;
    send(robotCmd,velMsg);
    [xCurrent yCurrent xTarget yTarget] 
