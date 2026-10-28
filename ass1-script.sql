DROP VIEW IF EXISTS assessment_total;
DROP TABLE IF EXISTS item_response, assessment, severity_band, item, doctor, patient CASCADE;

CREATE TABLE patient (
  id   INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);
 
CREATE TABLE doctor (
  id   INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE item (
  code        VARCHAR(20) PRIMARY KEY,
  instrument  VARCHAR(10) NOT NULL CHECK (instrument IN ('PHQ9','GAD7','HAMD17')),
  num         INT NOT NULL,
  description VARCHAR(255),
  min_score   INT NOT NULL,
  max_score   INT NOT NULL,
  symptom     VARCHAR(50) NOT NULL
);

CREATE TABLE assessment (
  id         INT PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES patient(id),
  doctor_id  INT NOT NULL REFERENCES doctor(id),
  instrument VARCHAR(10) NOT NULL CHECK (instrument IN ('PHQ9','GAD7','HAMD17')),
  assessed_at TIMESTAMP NOT NULL
);

CREATE TABLE item_response (
  id            INT PRIMARY KEY,
  assessment_id INT NOT NULL REFERENCES assessment(id),
  item_code     VARCHAR(20) NOT NULL REFERENCES item(code),
  score         INT NOT NULL,
  UNIQUE (assessment_id, item_code)
);

CREATE TABLE severity_band (
  instrument VARCHAR(10) NOT NULL,
  min_score  INT NOT NULL,
  max_score  INT NOT NULL,
  level      VARCHAR(10) NOT NULL CHECK (level IN ('None','Mild','Moderate','Severe')),
  PRIMARY KEY (instrument, level)
);

CREATE VIEW assessment_total AS
  SELECT assessment_id, SUM(score) AS total
  FROM item_response
  GROUP BY assessment_id;

  INSERT INTO patient VALUES
  (1, 'John Smith'),
  (2, 'Mary Jones'),
  (3, 'Miguel Silva'),
  (4, 'Martim Costa'),
  (5, 'Eva Martins');
 
INSERT INTO doctor VALUES
  (1, 'Dr. Mark Smith'),
  (2, 'Dr. Peter Marks');
 
INSERT INTO item VALUES
  ('PHQ9Item1', 'PHQ9', 1, 'Little interest or pleasure', 0, 3, 'Anhedonia'),
  ('PHQ9Item2', 'PHQ9', 2, 'Feeling down', 0, 3, 'DepressedMood'),
  ('PHQ9Item3', 'PHQ9', 3, 'Sleep problems', 0, 3, 'Insomnia'),
  ('PHQ9Item4', 'PHQ9', 4, 'Tiredness, low energy', 0, 3, 'Fatigue'),
  ('PHQ9Item5', 'PHQ9', 5, 'Appetite changes', 0, 3, 'AppetiteChange'),
  ('PHQ9Item6', 'PHQ9', 6, 'Feeling bad about oneself', 0, 3, 'Guilt'),
  ('PHQ9Item7', 'PHQ9', 7, 'Trouble concentrating', 0, 3, 'ConcentrationProblems'),
  ('PHQ9Item8', 'PHQ9', 8, 'Moving slowly or restless', 0, 3, 'PsychomotorChange'),
  ('PHQ9Item9', 'PHQ9', 9, 'Thoughts of self-harm', 0, 3, 'SuicidalIdeation'),
  ('GAD7Item1', 'GAD7', 1, 'Feeling nervous or on edge', 0, 3, 'Nervousness'),
  ('GAD7Item2', 'GAD7', 2, 'Unable to stop worrying', 0, 3, 'Worry'),
  ('GAD7Item3', 'GAD7', 3, 'Worrying too much', 0, 3, 'Worry'),
  ('GAD7Item4', 'GAD7', 4, 'Trouble relaxing', 0, 3, 'Restlessness'),
  ('GAD7Item5', 'GAD7', 5, 'Being restless', 0, 3, 'Restlessness'),
  ('GAD7Item6', 'GAD7', 6, 'Easily irritated', 0, 3, 'Irritability'),
  ('GAD7Item7', 'GAD7', 7, 'Feeling afraid', 0, 3, 'Fear'),
  ('HAMD17Item1', 'HAMD17', 1, 'Depressed mood', 0, 4, 'DepressedMood'),
  ('HAMD17Item2', 'HAMD17', 2, 'Feelings of guilt', 0, 4, 'Guilt'),
  ('HAMD17Item3', 'HAMD17', 3, 'Suicide', 0, 4, 'SuicidalIdeation'),
  ('HAMD17Item4', 'HAMD17', 4, 'Insomnia: early', 0, 2, 'Insomnia'),
  ('HAMD17Item5', 'HAMD17', 5, 'Insomnia: middle', 0, 2, 'Insomnia'),
  ('HAMD17Item6', 'HAMD17', 6, 'Insomnia: late', 0, 2, 'Insomnia'),
  ('HAMD17Item7', 'HAMD17', 7, 'Work and activities', 0, 4, 'Anhedonia'),
  ('HAMD17Item8', 'HAMD17', 8, 'Retardation', 0, 4, 'PsychomotorChange'),
  ('HAMD17Item9', 'HAMD17', 9, 'Agitation', 0, 4, 'Agitation'),
  ('HAMD17Item10', 'HAMD17', 10, 'Anxiety: psychic', 0, 4, 'Nervousness'),
  ('HAMD17Item11', 'HAMD17', 11, 'Anxiety: somatic', 0, 4, 'SomaticComplaints'),
  ('HAMD17Item12', 'HAMD17', 12, 'Somatic: gastrointestinal', 0, 2, 'AppetiteChange'),
  ('HAMD17Item13', 'HAMD17', 13, 'Somatic: general', 0, 2, 'Fatigue'),
  ('HAMD17Item14', 'HAMD17', 14, 'Genital symptoms', 0, 2, 'LowLibido'),
  ('HAMD17Item15', 'HAMD17', 15, 'Hypochondriasis', 0, 4, 'Hypochondriasis'),
  ('HAMD17Item16', 'HAMD17', 16, 'Loss of weight', 0, 2, 'WeightLoss'),
  ('HAMD17Item17', 'HAMD17', 17, 'Insight', 0, 2, 'LackOfInsight');
 
INSERT INTO severity_band VALUES
  ('PHQ9', 0, 4, 'None'),
  ('PHQ9', 5, 9, 'Mild'),
  ('PHQ9', 10, 14, 'Moderate'),
  ('PHQ9', 15, 27, 'Severe'),
  ('GAD7', 0, 4, 'None'),
  ('GAD7', 5, 9, 'Mild'),
  ('GAD7', 10, 14, 'Moderate'),
  ('GAD7', 15, 21, 'Severe'),
  ('HAMD17', 0, 7, 'None'),
  ('HAMD17', 8, 16, 'Mild'),
  ('HAMD17', 17, 23, 'Moderate'),
  ('HAMD17', 24, 52, 'Severe');

INSERT INTO assessment VALUES
  (1, 1, 1, 'PHQ9', TIMESTAMP '2026-09-01 10:00:00'),
  (2, 1, 2, 'HAMD17', TIMESTAMP '2026-09-03 15:00:00'),
  (3, 2, 1, 'GAD7', TIMESTAMP '2026-09-05 09:30:00'),
  (4, 2, 1, 'PHQ9', TIMESTAMP '2026-09-05 09:45:00'),
  (5, 3, 1, 'PHQ9', TIMESTAMP '2026-09-22 11:00:00'),
  (6, 4, 1, 'PHQ9', TIMESTAMP '2026-09-12 14:00:00'),
  (7, 5, 2, 'PHQ9', TIMESTAMP '2026-08-15 16:00:00'),
  (8, 5, 2, 'PHQ9', TIMESTAMP '2026-10-15 16:00:00'),
  (9, 5, 2, 'HAMD17', TIMESTAMP '2026-10-15 16:30:00'),
  (10, 3, 2, 'GAD7', TIMESTAMP '2026-10-06 11:00:00');

INSERT INTO item_response VALUES
  (1, 1, 'PHQ9Item1', 3),
  (2, 1, 'PHQ9Item2', 3),
  (3, 1, 'PHQ9Item3', 2),
  (4, 1, 'PHQ9Item4', 3),
  (5, 1, 'PHQ9Item5', 2),
  (6, 1, 'PHQ9Item6', 2),
  (7, 1, 'PHQ9Item7', 2),
  (8, 1, 'PHQ9Item8', 2),
  (9, 1, 'PHQ9Item9', 1),
  (10, 2, 'HAMD17Item1', 3),
  (11, 2, 'HAMD17Item2', 3),
  (12, 2, 'HAMD17Item3', 1),
  (13, 2, 'HAMD17Item4', 2),
  (14, 2, 'HAMD17Item5', 2),
  (15, 2, 'HAMD17Item6', 1),
  (16, 2, 'HAMD17Item7', 3),
  (17, 2, 'HAMD17Item8', 2),
  (18, 2, 'HAMD17Item9', 1),
  (19, 2, 'HAMD17Item10', 2),
  (20, 2, 'HAMD17Item11', 2),
  (21, 2, 'HAMD17Item12', 1),
  (22, 2, 'HAMD17Item13', 1),
  (23, 2, 'HAMD17Item14', 1),
  (24, 2, 'HAMD17Item15', 1),
  (25, 2, 'HAMD17Item16', 0),
  (26, 2, 'HAMD17Item17', 0),
  (27, 3, 'GAD7Item1', 2),
  (28, 3, 'GAD7Item2', 2),
  (29, 3, 'GAD7Item3', 2),
  (30, 3, 'GAD7Item4', 2),
  (31, 3, 'GAD7Item5', 1),
  (32, 3, 'GAD7Item6', 2),
  (33, 3, 'GAD7Item7', 1),
  (34, 4, 'PHQ9Item1', 1),
  (35, 4, 'PHQ9Item2', 1),
  (36, 4, 'PHQ9Item3', 2),
  (37, 4, 'PHQ9Item4', 1),
  (38, 4, 'PHQ9Item5', 1),
  (39, 4, 'PHQ9Item6', 0),
  (40, 4, 'PHQ9Item7', 1),
  (41, 4, 'PHQ9Item8', 0),
  (42, 4, 'PHQ9Item9', 0),
  (43, 5, 'PHQ9Item1', 2),
  (44, 5, 'PHQ9Item2', 3),
  (45, 5, 'PHQ9Item3', 2),
  (46, 5, 'PHQ9Item4', 2),
  (47, 5, 'PHQ9Item5', 2),
  (48, 5, 'PHQ9Item6', 2),
  (49, 5, 'PHQ9Item7', 2),
  (50, 5, 'PHQ9Item8', 1),
  (51, 5, 'PHQ9Item9', 1),
  (52, 6, 'PHQ9Item1', 0),
  (53, 6, 'PHQ9Item2', 1),
  (54, 6, 'PHQ9Item3', 0),
  (55, 6, 'PHQ9Item4', 1),
  (56, 6, 'PHQ9Item5', 0),
  (57, 6, 'PHQ9Item6', 0),
  (58, 6, 'PHQ9Item7', 0),
  (59, 6, 'PHQ9Item8', 0),
  (60, 6, 'PHQ9Item9', 0),
  (61, 7, 'PHQ9Item1', 2),
  (62, 7, 'PHQ9Item2', 2),
  (63, 7, 'PHQ9Item3', 2),
  (64, 7, 'PHQ9Item4', 2),
  (65, 7, 'PHQ9Item5', 1),
  (66, 7, 'PHQ9Item6', 1),
  (67, 7, 'PHQ9Item7', 2),
  (68, 7, 'PHQ9Item8', 1),
  (69, 7, 'PHQ9Item9', 0),
  (70, 8, 'PHQ9Item1', 1),
  (71, 8, 'PHQ9Item2', 1),
  (72, 8, 'PHQ9Item3', 1),
  (73, 8, 'PHQ9Item4', 1),
  (74, 8, 'PHQ9Item5', 1),
  (75, 8, 'PHQ9Item6', 0),
  (76, 8, 'PHQ9Item7', 1),
  (77, 8, 'PHQ9Item8', 0),
  (78, 8, 'PHQ9Item9', 0),
  (79, 9, 'HAMD17Item1', 1),
  (80, 9, 'HAMD17Item2', 1),
  (81, 9, 'HAMD17Item3', 0),
  (82, 9, 'HAMD17Item4', 1),
  (83, 9, 'HAMD17Item5', 1),
  (84, 9, 'HAMD17Item6', 0),
  (85, 9, 'HAMD17Item7', 1),
  (86, 9, 'HAMD17Item8', 0),
  (87, 9, 'HAMD17Item9', 0),
  (88, 9, 'HAMD17Item10', 1),
  (89, 9, 'HAMD17Item11', 1),
  (90, 9, 'HAMD17Item12', 1),
  (91, 9, 'HAMD17Item13', 1),
  (92, 9, 'HAMD17Item14', 0),
  (93, 9, 'HAMD17Item15', 0),
  (94, 9, 'HAMD17Item16', 1),
  (95, 9, 'HAMD17Item17', 0),
  (96, 10, 'GAD7Item1', 3),
  (97, 10, 'GAD7Item2', 3),
  (98, 10, 'GAD7Item3', 3),
  (99, 10, 'GAD7Item4', 2),
  (100, 10, 'GAD7Item5', 2),
  (101, 10, 'GAD7Item6', 3),
  (102, 10, 'GAD7Item7', 2);

SELECT a.id, a.patient_id, a.instrument, t.total, b.level
FROM assessment a
JOIN assessment_total t ON t.assessment_id = a.id
JOIN severity_band b ON b.instrument = a.instrument AND t.total BETWEEN b.min_score AND b.max_score
ORDER BY a.id;