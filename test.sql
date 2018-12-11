-- Entity Attribute Value Model in Postgres

CREATE TABLE public.entity (
	id      serial      NOT NULL,
	type    varchar(25) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE public.defined_attributes (
	key             varchar(25)   NOT NULL,
	description     varchar(1000) NOT NULL,
	PRIMARY KEY(key)
);

CREATE TABLE public.attribute (
	id      serial      NOT NULL references public.entity(id),
	key     varchar(25) NOT NULL references public.defined_attributes(key),
	value   varchar(25) NOT NULL,
	PRIMARY KEY (id, key, value)
);

CREATE TYPE key_value_pair AS (key varchar(25), value varchar(25));

CREATE OR REPLACE FUNCTION public.create_obj (c_type varchar(25), VARIADIC c_attributes key_value_pair[], OUT c_id integer)
RETURNS integer AS $$
DECLARE
	i int8;
BEGIN
	INSERT INTO eav.public.entity (type) VALUES (c_type) RETURNING id INTO c_id;

	FOR i IN SELECT generate_subscripts(c_attributes, 1)
	LOOP
		INSERT INTO eav.public.attribute (id, key, value)
			VALUES (c_id, c_attributes[i].key, c_attributes[i].value);
	END LOOP;
	RETURN;
END;
$$ LANGUAGE plpgsql;

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
