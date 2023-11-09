#!/bin/bash
  
db_name=dbname
db_user=username
db_password="password"
  
MAIL_TO="user1@mail.com user2@mail.com"
F_DAY=`date +"%Y-%m-01 00:00" -d "1 month ago"`
L_DAY=`date +"%Y-%m-01 00:00"`
SQL="select concat(u.display_name, \",\",concat(\"/\", year(p.post_date), \"/\", LPAD(MONTH(p.post_date), 2, '0'), \"/\", LPAD(DAYOFMONTH(p.post_date), 2, '0'), \"/\", p.post_name, \"-\", LPAD(SECOND(p.post_date), 2, '0'), p.id)) from wp_posts p left join wp_users u on u.id = p.post_author where p.post_date between '$F_DAY' AND '$L_DAY' AND p.post_status='publish' AND p.post_type='post' AND u.display_name != 'Redazione';";
SQL_FILE=export_posts.sql
CSV_FILE=export_posts.csv
TEMPLATE_FILE=SN_Report.xlsx
echo $SQL > $SQL_FILE
echo "Lancio della query: " $SQL;
mysql -u $db_user -N -B -D $db_name -p$db_password < $SQL_FILE > $CSV_FILE
echo "CSV Report creato con successo dal $F_DAY al $L_DAY nel file $CSV_FILE"
/usr/bin/mail -s "Report Mensile" -a $CSV_FILE -a $TEMPLATE_FILE -r "target@mail.com" $MAIL_TO <<< "In allegato il report estratto per il periodo che va dal $F_DAY al $L_DAY"
echo "Invio email a $MAIL_TO"
