-- Entity Attribute Value Model in Postgres
CREATE DATABASE eav_energy;

CREATE TABLE public.entity (
	id      serial      NOT NULL,
	type    varchar(25) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE public.power_plants (
	id        serial      NOT NULL references public.entity(id),
	plants    varchar(25) NOT NULL,
	PRIMARY KEY(plants)
);

CREATE TABLE public.defined_attributes (
	key             varchar(25)   NOT NULL,
	description     varchar(100) NOT NULL,
	PRIMARY KEY(key)
);
-- Таблица с текстовыми атрибутами
CREATE TABLE public.attribute_str (
	id      serial      NOT NULL references public.entity(id),
	plants  varchar(25) NOT NULL references public.power_plants(plants),
	key     varchar(25) NOT NULL references public.defined_attributes(key),
	value   varchar(25) ,
	PRIMARY KEY (id, plants, key)
);

-- Таблица с численными атрибутами (мощность электрическая, тепловая, мощность генераторов, высота плотины)
CREATE TABLE public.attribute_num (
	id      serial      NOT NULL references public.entity(id),
	plants  varchar(25) NOT NULL references public.power_plants(plants),
	key     varchar(25) NOT NULL references public.defined_attributes(key),
	value_n numeric ,
	PRIMARY KEY (id, plants, key)
);

CREATE OR REPLACE FUNCTION public.hashpoint(point) RETURNS integer
   LANGUAGE sql IMMUTABLE
   AS 'SELECT hashfloat8($1[0]) # hashfloat8($1[1])';

CREATE OPERATOR CLASS public.point_hash_ops DEFAULT FOR TYPE point USING hash AS
 OPERATOR 1 ~=(point,point),
 FUNCTION 1 public.hashpoint(point);

CREATE TABLE public.location (
    id  serial NOT NULL references public.entity(id),
	plants   varchar(25) NOT NULL references public.power_plants(plants),
	location point,
	PRIMARY KEY (id, plants)
);




-- CREATE TYPE key_value_pair AS (key varchar(25), value varchar(25));
--
-- CREATE OR REPLACE FUNCTION public.create_obj (c_type varchar(25), VARIADIC c_attributes key_value_pair[], OUT c_id integer)
-- RETURNS integer AS $$
-- DECLARE
-- 	i int8;
-- BEGIN
-- 	INSERT INTO eav.public.entity (type) VALUES (c_type) RETURNING id INTO c_id;
--
-- 	FOR i IN SELECT generate_subscripts(c_attributes, 1)
-- 	LOOP
-- 		INSERT INTO eav.public.attribute (id, key, value)
-- 			VALUES (c_id, c_attributes[i].key, c_attributes[i].value);
-- 	END LOOP;
-- 	RETURN;
-- END;
-- $$ LANGUAGE plpgsql;

-- Example usage

INSERT INTO public.defined_attributes (key, description)
	VALUES ('name', 'Name of the entity.');
INSERT INTO public.defined_attributes (key, description)
	VALUES ('joined', 'Date the entity joined the service.');
INSERT INTO public.defined_attributes (key, description)
	VALUES ('size', 'Size of the entity in bytes.');

SELECT public.create_obj('user', ('name', 'Alice'), ('joined', '2012-02-01'));
SELECT public.create_obj('user', ('name', 'Bob'), ('joined', '2012-01-01'));
SELECT public.create_obj('file', ('name', 'example.txt'), ('size', '20398'));
SELECT public.create_obj('file', ('name', 'example2.txt'));

SELECT e.id, name.value AS name FROM entity e
	INNER JOIN attribute name
		ON e.id = name.id
		AND name.key = 'name'
	WHERE e.type = 'user';

SELECT e.id, name.value AS name FROM entity e
	INNER JOIN attribute name
		ON e.id = name.id
		AND name.key = 'name'
	WHERE e.type = 'file';

SELECT e.id, name.value AS name FROM entity e
	INNER JOIN attribute name
		ON e.id = name.id
		AND name.key = 'name';
