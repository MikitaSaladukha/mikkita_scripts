% rosshutdown
% ipaddress = "http://localhost:11311";
% rosinit(ipaddress)
% rostopic list
 gzinit("localhost",14581)
% gzworld("reset")

% ros2 topic list
setenv('ROS_DOMAIN_ID','25')
ros2('topic','list')
domainID = 25;
n = ros2node("matlab_example_robot",domainID);
imgSub = ros2subscriber(n, "/camera/image_raw","sensor_msgs/Image","Reliability","besteffort","Durability","volatile","Depth",5);

odomSub = ros2subscriber(n, "/odom","nav_msgs/Odometry","Reliability","besteffort","Durability","volatile","Depth",5);

[velPub, velMsg] = ros2publisher(n, "/cmd_vel", "geometry_msgs/Twist","Reliability","besteffort","Durability","volatile","Depth",5);
    velMsg.linear.x = 10;
    velMsg.angular.z =0;
    send(velPub,velMsg);
% rospublisher('/cmd_vel')


% velocity = 0.1;     % meters per second
% robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
% velMsg = rosmessage(robotCmd);
% velMsg.Linear.X = velocity;
% send(robotCmd,velMsg)

% 
% setenv('ROS_DOMAIN_ID','25')
% ros2('topic','list')
% domainID = 25;
% robotDataProcessingNode = ros2node("/robotDataProcessingNode",domainID);
% humanOperatorNode = ros2node("/humanOperatorNode",domainID);
% velPub = ros2publisher(humanOperatorNode,"/cmd_vel","geometry_msgs/Twist","Reliability","reliable","Durability","transientlocal","Depth",5);
% imageSub = ros2subscriber(robotDataProcessingNode,"/camera/image_raw","sensor_msgs/Image","Reliability","besteffort","Durability","volatile","Depth",5);
% laserSub = ros2subscriber(robotDataProcessingNode,"/scan","sensor_msgs/LaserScan","Reliability","besteffort","Durability","volatile","Depth",5);
% odomSub = ros2subscriber(robotDataProcessingNode,"/odom","nav_msgs/Odometry","Reliability","reliable","Durability","volatile","Depth",5);
% stagePub = ros2publisher(robotDataProcessingNode,"/signCounter","std_msgs/Int8","Reliability","reliable","Durability","transientlocal","Depth",100);
% 

