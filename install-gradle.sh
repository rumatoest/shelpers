#!/bin/bash

GV=2.3

echo "INSTALLING gradle v$GV"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "ERROR! This script must be run as root." 1>&2
   exit 1
fi

GRADLE_ZIP=`mktemp`

wget -O $GRADLE_ZIP http://services.gradle.org/distributions/gradle-$GV-all.zip
unzip -u $GRADLE_ZIP -d /opt
rm $GRADLE_ZIP

chmod -R 0775 /opt/gradle-$GV
ln -s /opt/gradle-$GV /opt/gradle

cat > /etc/profile.d/gradle.sh << GPF
#!/bin/bash
GRADLE_HOME=/opt/gradle
PATH=\$PATH:\$GRADLE_HOME/bin

#JVM options for running Gradle can be set via environment variables.
#You can use GRADLE_OPTS or JAVA_OPTS. Those variables can be used together.
#JAVA_OPTS is by convention an environment variable shared by many Java applications.
#A typical use case would be to set the HTTP proxy in JAVA_OPTS
#and the memory options in GRADLE_OPTS.
#Those variables can also be set at the beginning of the gradle or gradlew script.
GPF

echo "Installation complete. You should restart your shell or run command \"source /etc/profile.d/gradle.sh\""
