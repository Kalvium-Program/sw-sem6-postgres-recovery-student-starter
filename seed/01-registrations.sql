CREATE TABLE registrations (
  id serial PRIMARY KEY,
  name text NOT NULL,
  event text NOT NULL,
  registered_on date NOT NULL DEFAULT CURRENT_DATE
);
INSERT INTO registrations (name, event) VALUES
  ('Alex', 'Design Sprint'),
  ('Sam', 'Robotics Workshop'),
  ('Taylor', 'Photo Walk');
