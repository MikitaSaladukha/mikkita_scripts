function angleOutput = getAngle  
    odomSub = rossubscriber("/odom","DataFormat","struct");
    odomMsg = receive(odomSub,3);
    pose = odomMsg.Pose.Pose;
    xCurrent = pose.Position.X;
    yCurrent = pose.Position.Y;
    xTarget=round(xCurrent);
    yTarget=round(yCurrent);
    angleOutput=atand((yTarget-yCurrent)/(xTarget-xCurrent));
end