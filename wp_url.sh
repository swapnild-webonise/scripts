#!/bin/bash
echo "Enter Current url"
read OLD_URL

echo "Enter New url"
read NEW_URL

echo Enter Database Name
read DB_NAME

echo $OLD_URL && echo $NEW_URL

mysql -u root -p'royalparkdata' $DB_NAME --verbose -e  "UPDATE wp_rp_links SET    link_url = replace(link_url, '$OLD_URL', '$NEW_URL') WHERE  link_url LIKE '%$OLD_URL%';"

mysql -u root -p'royalparkdata' $DB_NAME --verbose -e  "UPDATE wp_rp_options SET    option_value = replace(option_value, '$OLD_URL', '$NEW_URL') WHERE  option_value LIKE '%$OLD_URL%';"


mysql -u root -p'royalparkdata' $DB_NAME --verbose -e  "UPDATE wp_rp_postmeta SET  meta_value = replace(meta_value, '$OLD_URL', '$NEW_URL') WHERE  meta_value LIKE '%$OLD_URL%';"


mysql -u root -p'royalparkdata' $DB_NAME --verbose -e  "UPDATE wp_rp_links SET    link_url = replace(link_url, '$OLD_URL', '$NEW_URL') WHERE  link_url LIKE '%$OLD_URL%';"


mysql -u root -p'royalparkdata' $DB_NAME --verbose -e  "UPDATE wp_rp_posts SET guid = replace(guid, '$OLD_URL', '$NEW_URL') WHERE  guid LIKE '%$OLD_URL%';"
