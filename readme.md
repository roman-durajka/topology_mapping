Bachelor's thesis: Creating a visualization of connections between network devices and end stations in network

Bakalárska práca: Tvorba vizualizácie vzájomných väzieb medzi sieťovými zariadeniami a koncovými stanicami v sieti

This branch contains version of the app which supports data model produced by **libreNMS**. To use version of the app 
which supports **custom data model**, switch to branch _custom_db_. 

### Usage:
1. git clone https://github.com/roman-durajka/topology_mapping
2. cd topology_mapping
3. git checkout master
4. docker compose up --build
5. docker exec -i db_con mysql -uroot -ppassword -e "create database librenms;"
6. docker exec -i db_con mysql -uroot -ppassword librenms < dumps/data_model_dump_librenms.sql
7. open localhost:8000 in web browser

This app uses tool called [NeXt](https://developer.cisco.com/site/neXt/) made by Cisco DevNet.