-- ParkingGPS API SQL
-- SQL inicial

CREATE TABLE tracking_key
(
  key_number character(5) NOT NULL PRIMARY KEY,
  device_id integer
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
			INSERT INTO tracking_key (key_number, device_id) VALUES (tkey, device);
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

-- INSERT INTO park (name, price_per_minute, area) VALUES ('Estacionamento da Fundação Cultural de Brusque', 0.10, 
-- st_geomfromtext('POLYGON((-27.098500 -48.913904, -27.098510 -48.913565, -27.098705 -48.913574, -27.098696 -48.913908, -27.098500 -48.913904))', 4326));

CREATE TABLE position (
	id serial PRIMARY KEY,
	tracking_key_number char(5) NOT NULL,
	point_date timestamp NOT NULL,
	accurracy decimal(10,2)
);

ALTER TABLE position ADD FOREIGN KEY (tracking_key_number) REFERENCES tracking_key(key_number);

SELECT addgeometrycolumn('position', 'actual_location', 4326, 'POINT', 2);

CREATE OR REPLACE FUNCTION get_actual_park(lat numeric, long numeric) RETURNS json AS
$BODY$
	DECLARE
		park RECORD;
	BEGIN
		FOR park IN (SELECT * FROM park) LOOP
			IF st_within(
				st_geomfromtext('POINT(' || lat || ' ' || long ')', 4326),
				park.area
			) THEN RETURN json_build_object('currentPark', park.name);
			END IF
		END LOOP
	END
$BODY$
	LANGUAGE plpgsql;

-- SELECT get_actual_park(-27.0986, -48.913905);
