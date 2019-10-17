JARPATH=$(PWD)/ui/target/ui-2.0.5-jar-with-dependencies.jar
ICONPATH=$(PWD)/ui/src/main/resources/dat3m.png

.PHONY: all install linux

all: install linux

install:
	mvn install:install-file -Dfile=lib/z3-4.3.2.jar -DgroupId=com.microsoft -DartifactId="z3" -Dversion=4.3.2 -Dpackaging=jar
	mvn clean install -DskipTests

linux:
	echo '[Desktop Entry]' > ./dat3m.desktop
	echo 'Type=Application' >> ./dat3m.desktop
	echo 'Name=Dat3M' >> ./dat3m.desktop
	echo 'Comment=Dat3M' >> ./dat3m.desktop
	echo 'Terminal=false' >> ./dat3m.desktop
	echo 'Exec=java -jar -Djava.library.path='$(PWD)'/lib '$(JARPATH) >> ./dat3m.desktop
	echo 'Icon='$(ICONPATH) >> ./dat3m.desktop
	chmod +x "./dat3m.desktop" 
