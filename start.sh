#! /bin/bash


#export PATH=$PATH:/home/erhard/.rvm/rubies/jruby-1.5.1/bin/jruby/bin
#export JAVA_HOME=/usr/bin/java
cd /home/erhard/Daten/programmierung/current/exampleDeamon
jruby -S exampleDaemon.rb -e test -c testConfig.yml start &
sleep 2
