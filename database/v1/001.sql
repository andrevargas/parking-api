-- ParkingGPS API SQL
-- SQL inicial

-- Sequência utilizada para gerar a chave de rastreamento
CREATE SEQUENCE tracking_key_number_seq
	INCREMENT 1
  	MINVALUE 1
  	MAXVALUE 9223372036854775807
  	START 9
  	CACHE 1;

-- Tabela de chaves de rastreamento
CREATE TABLE tracking_key
(
  id serial NOT NULL,
  device_id integer NOT NULL,
  tracking_key_number character(5) NOT NULL DEFAULT to_char(nextval('tracking_key_number_seq'::regclass), 'FM00000'::text),
  CONSTRAINT tracking_key_pkey PRIMARY KEY (id)
);

-- Função que cria e/ou retorna uma chave de rastreamento
CREATE OR REPLACE FUNCTION get_tracking_key(id_device integer)
  RETURNS character AS
$BODY$
	declare
		tracking_key char(6);
	begin
		tracking_key := (select tk.tracking_key_number from tracking_key tk where tk.device_id = id_device);

		if tracking_key is not null then
			return tracking_key;
		else
			insert into tracking_key (device_id) values (id_device) returning tracking_key_number into tracking_key;
			return tracking_key;
		end if;
	end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;