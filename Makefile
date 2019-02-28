APPPATH=$(HOME)/share/dat3m
JARPATH=./ui/target/ui-2.0.2-jar-with-dependencies.jar
JARNAME=dat3m.jar
ICONPATH=./ui/src/main/resources/dat3m.png

.PHONY: all install

all: install

install:
	mvn install:install-file -Dfile=lib/z3-4.3.2.jar -DgroupId=com.microsoft -DartifactId="z3" -Dversion=4.3.2 -Dpackaging=jar
	mvn clean install -DskipTests
	mkdir -p $(APPPATH)
	cp $(JARPATH) $(APPPATH)/$(JARNAME)
	cp $(ICONPATH) $(APPPATH)
	echo '[Desktop Entry]' > ./dat3m.desktop
	echo 'Type=Application' >> ./dat3m.desktop
	echo 'Name=Dat3M' >> ./dat3m.desktop
	echo 'Comment=Dat3M' >> ./dat3m.desktop
	echo 'Terminal=false' >> ./dat3m.desktop
	echo 'Exec=java -jar -Djava.library.path=./Dat3M/lib '$(APPPATH)/$(JARNAME) >> ./dat3m.desktop
	echo 'Icon='$(APPPATH)'/dat3m.png' >> ./dat3m.desktop
	chmod +x "./dat3m.desktop" 
