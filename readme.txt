2010/01/02   initial release




This programm show howto write a daemon with jruby.

What a daemon is can be read here :

http://www.netzmafia.de/skripten/unix/linux-daemon-howto.html


ExampleDaemon is a template which intention it is to copy and paste and to modify to your needs. Even adopt the sh files and the yml.
As You can read here http://www.ruby-forum.com/topic/178196
the daemonize gems out in the ruby-world can't be used with Jruby, because jruby can't fork a process.

So to make a jruby daemon a little trick is used:
To fork the process a bash script is used (start.sh) In this bash script all the environment stuff is set and the process is forked. 

The controll of the daemon works as follows :

There are three parameters the daemon gets :

-c  the config-file
-e  the environment (to specify the section in the config file)
-a  the action (stop or start) (default = start)

The example gets the rest from the config file, this can be anything to controll your daemon.
When starting a pid File with the processId is created.

When the script runs from time to time it is checked wether the pid file exists.
to stop the daemon call stop.sh which simply deletes the pid-file. Or do it by hand and kill the process somehow (the processid is in the pid-file)

Try to understand the code because you have to adopt it to your needs (There are my settings in the code).

Now you can call the start.sh and stop.sh from /etc/init.d scripts or manually or whatever




Licence : MIT. - No warrenty !





