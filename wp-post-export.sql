select concat(u.display_name, ",",concat("/", year(p.post_date), "/", LPAD(MONTH(p.post_date), 2, '0'), "/", LPAD(DAYOFMONTH(p.post_date), 2, '0'), "/", p.post_name, "-", LPAD(SECOND(p.post_date), 2, '0'), p.id)) from wp_posts p left join wp_users u on u.id = p.post_author where p.post_date between '2023-09-01 00:00' AND '2023-10-01 00:00' AND p.post_status='publish' AND p.post_type='post' AND u.display_name != 'Redazione';
