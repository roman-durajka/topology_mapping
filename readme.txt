How to run:
 - 1. docker compose up --build
 - 2. docker exec -i db_con mysql -uuser -ppassword librenms < dumps/data_model_dump_librenms.sql
 - 3. open localhost:8000 in web browser