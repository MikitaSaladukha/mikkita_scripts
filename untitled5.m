%ipaddress='10.160.113.48'

setenv('ROS_DOMAIN_ID','25')
%device = ros2device(ipaddress); 
device = ros2device('localhost')
test1 = ros2node("/test1")
%exampleHelperROS2CreateSampleNetwork

%open_system("performCoSimulationWithGazebo")
% test1 = ros2node("/test1")
% ros2 node list
gzinit("192.168.0.107",14581)




% gzinit(ipaddress,14581)
% gzworld("reset")


% velocity = 0.1;     % meters per second
% robotCmd = rospublisher("/cmd_vel","DataFormat","struct") ;
% velMsg = rosmessage(robotCmd);
% velMsg.Linear.X = velocity;
% send(robotCmd,velMsg)

ros2 msg show geometry_msgs/Twist
% controlNode = ros2node("/base_station");
% poseSub = ros2subscriber(controlNode,"/pose","geometry_msgs/Twist")

twist = ros2message("geometry_msgs/Twist")
twist.linear.y = 5;
twist.linear
twist.angular.x=5;

ros2 msg show geometry_msgs/Vector3

fprintf('service list: \n');
% rosinit(ipaddress)
% tbot = turtlebot(ipaddress)
% setVelocity(tbot, 0.3);
ros2 service list
fprintf('node list: \n');
ros2 node list
fprintf('topic list: \n');
ros2 topic list
ros2 topic list -t
fprintf('msg list: \n');
ros2 msg list
% ros2 bag info

