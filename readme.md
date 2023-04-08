Bachelor's thesis: Creating a visualization of connections between network devices and end stations in network

Bakalárska práca: Tvorba vizualizácie vzájomných väzieb medzi sieťovými zariadeniami a koncovými stanicami v sieti

This branch contains version of the app which supports **custom data model** created specifically for this app. To use 
version of the app which supports data model produces by **libreNMS**, switch to branch _master_. 

### Usage:
1. git clone https://github.com/roman-durajka/topology_mapping
2. cd topology_mapping
3. git checkout custom_db
4. docker compose up --build
5. docker exec -i db_con mysql -uroot -ppassword -e "create database relations;"
6. docker exec -i db_con mysql -uroot -ppassword relations < dumps/data_model_dump_toad.sql
7. open localhost:8000 in web browser

This app uses tool called [NeXt](https://developer.cisco.com/site/neXt/) made by Cisco DevNet.