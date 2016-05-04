-- ParkingGPS API SQL
-- SQL inicial

CREATE TABLE trackingkey
(
  deviceid integer NOT NULL,
  keynumber character(5) NOT NULL,
  id serial NOT NULL,
  CONSTRAINT trackingkey_pkey PRIMARY KEY (id)
)

CREATE SEQUENCE tracking_key_number_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE tracking_key_number_seq
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION get_tracking_key(device_id integer) RETURNS character AS
$BODY$
	DECLARE
		tkey char(5);
	BEGIN
		SELECT keynumber INTO tkey FROM trackingkey WHERE deviceid = device_id;

		IF tkey IS NOT NULL THEN 
			RETURN tkey;
		ELSE
			tkey := to_char(nextval('tracking_key_number_seq'), 'FM00000');
			INSERT INTO trackingkey (deviceid, keynumber) VALUES (device_id, tkey);
			RETURN tkey;
		END IF;
	END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;