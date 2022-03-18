#TIP:
##New laptop?

#Download tomcat server.
Go to Edit Configurations and choose a new template -> Tomcat Local -> and point it to the directory of where you have it installed
for example C:\Users\name\apache-tomcat-8.5.47

##Download mysql.
#be able to type 'mysql' in the command prompt:
##Open command prompt (Windows) and type dir mysqld.exe /s /p
##copy that directory, probably C:\Program Files\MySQL\MySQL Server 8.0\bin
open up the control panel -> system and security -> System -> Advanced system settings -> Environment Variables -> under System Variables ->
 click Path (edit) and add a new path at the bottom for "C:\Program Files\MySQL\MySQL Server 8.0\bin"

 Now open up the command prompt and login: mysql -u root -p (password is the root password you setup during initial mysql install)
 Then create the database trainingapp_db;
 then create a user for that database, trainingapp_user and give them a password

CREATE USER 'trainingapp_user' identified by 'password';
GRANT ALL PRIVILEGES ON trainingapp_db. * TO 'trainingapp_user'@'%';

Then head over to Database area in the right of Intellij add (+) a new Data Source -> MySQL
and type in the user and database names you made in mysql and Test Connection;
Then run the application and this should build the entities and the schema table!