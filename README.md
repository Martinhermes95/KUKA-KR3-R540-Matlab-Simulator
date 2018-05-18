# KUKA-KR3-R540-Matlab-Simulator
This is a simulator of KUKA KR3 R540. The code was projected in Matlab using the Peter Corke's Robotics tool. It was made for the Robotic's class at UFSC (Federal University of Santa Catarina). 

Owners: André Granemann, Martin H. Anschau

Automation and Control Engineering - UFSC

How it works:

The whole program was made with Robotic Toolbox (v13) designed by Peter Corke. And we used some pre made functions of it. 

(1) part one:

At the beggining we just create the manipulator links with the function Link(). To use it we have to get the Denavit Hartenberg parameters of the manipulator. By this, to create the link we put parameters like theta, d, a and alpha just as shown below, for example

Link_one = ('theta','d',1,'a',1,'alhpa',0, 'qlim', [0 pi ]);

At this example we haven't a theta offset, so the joint angle is just theta1, for example. The offset distance 'd' is 1 (1mm, for ex.). The lenght of the link 'a' is 1 too. The link twist 'alpha' is 0 degrees and theta is limited by 'qlim' from 0 to 180 degrees.

For the KR3 R540 manipulator we have 6 links and the parameters were took by its specification's manual. It has 5 rotational joints and the tool. L1, L2, L3, L4 and L5 represent the first 5 five links and L6 represent the tool link. 

(2) part two:

After the first step we use the SerialLink() function. With this we can create a Serial link robot with the links previously created. To use this function we must create a column vector with the links, well as shown below

Links = [L1;L2]

the next step is to use the function, so as

Robot = SerialLink(Links, 'name', 'CristianoRonaldo');

By this we've just created a robot with two rotational links. For other link types the user can find some help typing "help Link" in the command window.

(3) part three:

After all of this we have just to plot the robot. In the code it was done with the function plot() and teach(). 

To use plot() we have to put the thetas initial conditions. Like as

q = [pi 0]

Robot.plot(q)

So the robot starts with the first joint at 180 degrees and the second joint at 0 degrees in the graphic.

With teach() the user can change the joint angles manually. To plot the graphic just type 

Robot.teach

After all of this we revert the axes Z and Y. It's made because of some Denavit Hartenberg parameters of the manipulator like the -20 a's of the first link. Without this inversions the robot is plotted upside down and it's not interesting.

Have fun.
