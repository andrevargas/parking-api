-- ParkingGPS API SQL
-- SQL inicial

CREATE TABLE tracking_key
(
  device_id integer PRIMARY KEY,
  key_number character(5) NOT NULL,
  id serial NOT NULL
);

CREATE SEQUENCE tracking_key_number_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE tracking_key_number_seq
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION get_tracking_key(device integer) RETURNS character AS
$BODY$
	DECLARE
		tkey char(5);
	BEGIN
		SELECT key_number INTO tkey FROM tracking_key WHERE device_id = device;

		IF tkey IS NOT NULL THEN 
			RETURN tkey;
		ELSE
			tkey := to_char(nextval('tracking_key_number_seq'), 'FM00000');
			INSERT INTO tracking_key (device_id, key_number) VALUES (device, tkey);
			RETURN tkey;
		END IF;
	END
$BODY$
  LANGUAGE plpgsql;

CREATE TABLE park (
	id serial PRIMARY KEY,
	name varchar(255) NOT NULL,
	price_per_minute decimal(10,2)
);

SELECT addgeometrycolumn('park', 'area', 4326, 'POLYGON', 2);

CREATE TYPE park_detail AS (
	park varchar(255),
	price_per_minute decimal(10,2),
	distance decimal(10,2)
);

-- CREATE OR REPLACE FUNCTION get_parks(lat number long number) RETURNS setof park_detail AS
-- $BODY$
	
-- $BODY$
-- 	LANGUAGE plpgsql;