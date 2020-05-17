***************
** SECTION A **
***************

CREATE TABLE Aliases (
Alias_ID	NUMBER (6),
Criminal_ID NUMBER (6),
Alias 		VARCHAR2 (10)
);

CREATE TABLE Criminals (
Criminal_ID		NUMBER (6),
Last			VARCHAR2 (15),
First			VARCHAR2 (10),
Street			VARCHAR2 (30),
City			VARCHAR2 (20),
State			CHAR (2),
ZIP				CHAR (5),
PHONE			CHAR (10),
V_status		CHAR (1) DEFAULT 'N',
P_status		CHAR (1) DEFAULT 'N'
);

CREATE TABLE Crimes (
Crime_ID		NUMBER (9),
Criminal_ID		NUMBER (6),
Classification	CHAR (1),
Date_Charged	Date,
Status 			CHAR (2),
Hearing_Date	Date,
Appeal_cut_date	Date
);

CREATE TABLE Sentences (
Sentence_ID		NUMBER (6),
Criminal_ID		NUMBER (6),
Type			CHAR (1),
Prob_ID			NUMBER (5),
Start_date		Date,
End_date		Date,
Violations		NUMBER (3)
);

CREATE TABLE Prob_officers (
Prob_ID			NUMBER (5),
Last			VARCHAR2 (15),
First			VARCHAR2 (10),
Street			VARCHAR2 (30),
City			VARCHAR2 (20),
State 			CHAR (2),
ZIP				CHAR (5),
Email			VARCHAR2 (30),
Status 			CHAR (1) DEFAULT 'A'
);

CREATE TABLE Crime_charges (
Charge_ID		NUMBER (10),
Crime_ID		NUMBER (9),
Crime_code		NUMBER (3),
Charge_status	CHAR (2),
Fine_amount		NUMBER (7),
Court_fee		NUMBER (7),
Pay_due_date	Date
);

CREATE TABLE Crime_officers (
Crime_ID		NUMBER (9),
Officer_ID		NUMBER (8)
);

CREATE TABLE Officers (
Officer_ID		NUMBER (8),
Last			VARCHAR (15),
First			VARCHAR (10),
Precinct		CHAR (4),
Badge			VARCHAR (14),
Phone 			CHAR (10),
Status 			CHAR (1) DEFAULT 'A'
);

CREATE TABLE Appeals (
Appeal_ID		NUMBER (5),
Crime_ID		NUMBER (9),
Filing_date		Date,
Hearing_Date	Date,
Status 			CHAR (1) DEFAULT 'P'
);

CREATE TABLE Crime_codes (
Crime_code 			NUMBER (3),
Code_description	VARCHAR (30)
);


***************
** SECTION B **
***************

ALTER TABLE Crimes
MODIFY (Classification DEFAULT 'U');

ALTER TABLE Crimes
ADD (Date_Recorded Date);

ALTER TABLE Prob_officers
ADD (Pager# CHAR (10));

ALTER TABLE Aliases
MODIFY (Alias VARCHAR2 (20));

DROP TABLE Appeals PURGE;
DROP TABLE Crime_officers PURGE;
DROP TABLE Crime_charges PURGE;

ALTER TABLE Aliases
ADD CONSTRAINT aliases_pk PRIMARY KEY (alias_id);

ALTER TABLE Criminals
ADD CONSTRAINT criminals_pk PRIMARY KEY (criminal_id);

ALTER TABLE Crimes
ADD CONSTRAINT crimes_pk PRIMARY KEY (crime_id);

ALTER TABLE Sentences
ADD CONSTRAINT sentences_pk PRIMARY KEY (sentence_id);

ALTER TABLE Prob_officers
ADD CONSTRAINT prob_officers_pk PRIMARY KEY (prob_id);

ALTER TABLE Officers
ADD CONSTRAINT officers_pk PRIMARY KEY (officer_id);

ALTER TABLE Crime_codes
ADD CONSTRAINT crime_codes_pk PRIMARY KEY (crime_code);

ALTER TABLE Aliases
ADD CONSTRAINT aliases_fk FOREIGN KEY (criminal_id)
	REFERENCES Criminals (criminal_id);

ALTER TABLE Criminals
MODIFY (Last CONSTRAINT criminals_nn NOT NULL);

ALTER TABLE Criminals
MODIFY (First CONSTRAINT first_nn NOT NULL);

ALTER TABLE Criminals
MODIFY (Street CONSTRAINT street_nn NOT NULL);

ALTER TABLE Criminals
MODIFY (City CONSTRAINT city_nn NOT NULL);

ALTER TABLE Criminals
MODIFY (State CONSTRAINT state_nn NOT NULL);

ALTER TABLE Criminals
MODIFY (ZIP CONSTRAINT zip_nn NOT NULL);

ALTER TABLE Criminals
ADD CONSTRAINT criminals_ck CHECK (V_status IN ('Y', 'N'));

ALTER TABLE Criminals
ADD CONSTRAINT criminals_pstatus_ck CHECK (P_status IN ('Y', 'N'));

ALTER TABLE Crimes
ADD CONSTRAINT crimes_fk FOREIGN KEY (criminal_id)
	REFERENCES Criminals (criminal_id);

ALTER TABLE Crimes
ADD CONSTRAINT crimes_ck CHECK (classification IN ('F', 'M', 'O', 'U'));

ALTER TABLE Crimes
MODIFY (Classification CONSTRAINT crimes_nn NOT NULL);

ALTER TABLE Crimes
MODIFY (Date_charged CONSTRAINT datecharged_nn NOT NULL);

ALTER TABLE Crimes
ADD CONSTRAINT crimes_status_ck CHECK (status IN ('CL', 'CA', 'IA'));

ALTER TABLE Crimes
MODIFY (Status CONSTRAINT crimes_status_nn NOT NULL);

ALTER TABLE Sentences
ADD CONSTRAINT sentences_fk FOREIGN KEY (criminal_id)
	REFERENCES Criminals (criminal_id);

ALTER TABLE Sentences
ADD CONSTRAINT sentences_prob_id_fk FOREIGN KEY (prob_id)
	REFERENCES Prob_officers (prob_id);

ALTER TABLE Sentences
ADD CONSTRAINT sentences_ck CHECK (type IN ('J', 'H', 'P'));

ALTER TABLE Sentences
MODIFY (Type CONSTRAINT sentences_type_nn NOT NULL);

ALTER TABLE Sentences
MODIFY (Start_date CONSTRAINT sentences_startdate_nn NOT NULL);

ALTER TABLE Sentences
MODIFY (Violations CONSTRAINT sentences_violation_nn NOT NULL);

ALTER TABLE Prob_officers
MODIFY (Last CONSTRAINT prob_officers_last_nn NOT NULL);

ALTER TABLE Prob_officers
MODIFY (First CONSTRAINT prob_officers_first_nn NOT NULL);

ALTER TABLE Prob_officers
MODIFY (Street CONSTRAINT prob_officers_street_nn NOT NULL);

ALTER TABLE Prob_officers
MODIFY (City CONSTRAINT prob_officers_city_nn NOT NULL);

ALTER TABLE Prob_officers
MODIFY (State CONSTRAINT prob_officers_state_nn NOT NULL);

ALTER TABLE Prob_officers
MODIFY (Status CONSTRAINT prob_officers_status_nn NOT NULL);

ALTER TABLE Prob_officers
ADD CONSTRAINT prob_officers_ck CHECK (status IN ('A', 'I'));

ALTER TABLE Officers
MODIFY (Last CONSTRAINT officers_last_nn NOT NULL);

ALTER TABLE Officers
MODIFY (First CONSTRAINT officers_first_nn NOT NULL);

ALTER TABLE Officers
MODIFY (Precinct CONSTRAINT officers_precinct_nn NOT NULL);

ALTER TABLE Officers
MODIFY (Phone CONSTRAINT officers_phone_nn NOT NULL);

ALTER TABLE Officers
ADD CONSTRAINT officers_uk UNIQUE (badge);

ALTER TABLE Officers
ADD CONSTRAINT officers_ck CHECK (status IN ('A', 'I'));

ALTER TABLE Officers
MODIFY (Status CONSTRAINT officers_status_nn NOT NULL);

ALTER TABLE Crime_codes
MODIFY (code_description CONSTRAINT code_description_nn NOT NULL);

CREATE TABLE Appeals (
Appeal_ID		NUMBER (5),
Crime_ID 		NUMBER (9),
Filing_date 	Date NOT NULL,
Hearing_Date 	Date NOT NULL,
Status 			CHAR (1) DEFAULT 'P',
CONSTRAINT appeals_pk PRIMARY KEY (appeal_id),
CONSTRAINT appeals_fk FOREIGN KEY (crime_id)
	REFERENCES Crimes (crime_id),
CONSTRAINT appeals_status_ck CHECK (status IN ('P', 'A', 'D'))
);

CREATE TABLE Crime_officers (
Crime_ID 	NUMBER (9),
Officer_ID 	NUMBER (8),
CONSTRAINT crime_officers_crimeid_fk FOREIGN KEY (crime_id)
	REFERENCES Crimes (crime_id),
CONSTRAINT crime_officers_officerid_fk FOREIGN KEY (officer_id)
	REFERENCES Officers (officer_id)
);

CREATE TABLE Crime_charges (
Charge_ID		NUMBER (10),
Crime_ID		NUMBER (9),
Crime_code		NUMBER (3),
Charge_status	CHAR (2) NOT NULL,
Fine_amount		NUMBER (7) NOT NULL,
Court_fee		NUMBER (7) NOT NULL,
Pay_due_date	Date NOT NULL,
CONSTRAINT crime_charges_pk PRIMARY KEY (charge_id),
CONSTRAINT crime_charges_crimeid_fk FOREIGN KEY (crime_id)
	REFERENCES Crimes (crime_id),
CONSTRAINT crime_charges_crimecode_fk FOREIGN KEY (crime_code)
	REFERENCES Crime_codes (crime_code),
CONSTRAINT crime_charges_ck CHECK (charge_status IN ('PD', 'GL', 'NG'))
);


***************
** Chapter 5 **
***************

1.
INSERT INTO Criminals VALUES (
		'&Criminal_ID',
		'&last',
		'&first',
		'&street',
		'&city',
		'&state',
		'&zip',
		'&Phone',
		'&v_status',
		'&p_status'
		);

ALTER TABLE Criminals
ADD Mail_flag CHAR(1);

UPDATE Criminals
SET Mail_flag = 'Y';

UPDATE Criminals
SET Mail_flag = 'N'
WHERE Street is null;

UPDATE Criminals
SET Phone = '7225659032'
WHERE Criminal_ID = '1015';

DELETE FROM Criminals
WHERE Criminal_ID = '1017';

2.
INSERT INTO Crimes (Crime_ID, Criminal_ID, Classification, Date_charged, Status)
VALUES ('100', '1010', 'M', '7-JUL-2009', 'PD');
SQL Error: ORA-02290: check constraint (SYSTEM.CRIMES_STATUS_CK) violated
The error is caused because the data in the 'Status' column must be one of the following values: CL, CA, IA. The constraint on this column checks data input to ensure the data matches.
There should also have been an error because the foreign key Criminal_ID is not listed in the Criminals table.

INSERT INTO Crimes (Crime_ID, Criminal_ID, Classification, Date_charged, Status)
VALUES ('130', '1016', 'M', '15-JUL-2009', 'PD');
SQL Error: ORA-02290: check constraint (SYSTEM.CRIMES_STATUS_CK) violated
The error is caused because the data in the 'Status' column must be one of the following values: CL, CA, IA. The constraint on this column checks data input to ensure the data matches.

INSERT INTO Crimes (Crime_ID, Criminal_ID, Classification, Date_charged, Status)
VALUES ('130', '1016', 'P', '15-JUL-2009', 'CL');
SQL Error: ORA-02290: check constraint (SYSTEM.CRIMES_CK) violated
The error is caused because the data in the 'Classification' column must be one of the following values: F,M,O,U. The constraint on this column checks data input to ensure the data matches.

************
*** CS 6 ***
************

CREATE SEQUENCE criminals_criminalid_seq
INCREMENT BY 1
START WITH 1017
NOCYCLE;

CREATE SEQUENCE crimes_crimeid_seq
INCREMENT BY 1
START WITH 1
NOCYCLE;

INSERT INTO Criminals (criminal_id, last, first, street, city, state, zip, phone, V_status, P_status, mail_flag)
VALUES (criminals_criminalid_seq.NEXTVAL, 'Norris', 'Scott', '157 Ash St', 'Richmond', 'VA', '23226', '8046661827', 'Y', 'N', 'N');

INSERT INTO Crimes (crime_id, criminal_id, classification, date_charged, status, hearing_date, appeal_cut_date, date_recorded)
VALUES (crimes_crimeid_seq.NEXTVAL, criminals_criminalid_seq.CURRVAL, 'F', '25-FEB-2018', 'CA', '12-MAR-2018', '25-APR-2018', '03-MAR-2018');

CREATE INDEX criminals_nameaddressinfo_idx
ON criminals (last, street, phone);

************
*** CS 7 ***
************

USER CREATION:
CREATE USER CrimRec01
IDENTIFIED BY Password1
PASSWORD EXPIRE;
GRANT create session
TO CrimRec01;

USER CREATION:
CREATE USER CrimRec01
IDENTIFIED BY Password1
PASSWORD EXPIRE;
GRANT create session
TO CrimRec01;

USER CREATION:
CREATE USER CrimRec01
IDENTIFIED BY Password1
PASSWORD EXPIRE;
GRANT create session
TO CrimRec01;

USER CREATION:
CREATE USER CrimRec01
IDENTIFIED BY Password1
PASSWORD EXPIRE;
GRANT create session
TO CrimRec01;

USER CREATION:
CREATE USER CrimRec01
IDENTIFIED BY Password1
PASSWORD EXPIRE;
GRANT create session
TO CrimRec01;

USER CREATION:
CREATE USER CrimRec01
IDENTIFIED BY Password1
PASSWORD EXPIRE;
GRANT create session
TO CrimRec01;

USER CREATION:
CREATE USER CrimRec01
IDENTIFIED BY Password1
PASSWORD EXPIRE;
GRANT create session
TO CrimRec01;

USER CREATION:
CREATE USER CrimRec01
IDENTIFIED BY Password1
PASSWORD EXPIRE;
GRANT create session
TO CrimRec01;

USER CREATION:
CREATE USER CourtRec011
IDENTIFIED BY Password9
PASSWORD EXPIRE;
GRANT create session
TO CourtRec01;

USER CREATION:
CREATE USER CourtRec011
IDENTIFIED BY Password9
PASSWORD EXPIRE;
GRANT create session
TO CourtRec01;

USER CREATION:
CREATE USER CourtRec011
IDENTIFIED BY Password9
PASSWORD EXPIRE;
GRANT create session
TO CourtRec01;

USER CREATION:
CREATE USER CourtRec011
IDENTIFIED BY Password9
PASSWORD EXPIRE;
GRANT create session
TO CourtRec01;

USER CREATION:
CREATE USER CourtRec011
IDENTIFIED BY Password9
PASSWORD EXPIRE;
GRANT create session
TO CourtRec01;

USER CREATION:
CREATE USER CourtRec011
IDENTIFIED BY Password9
PASSWORD EXPIRE;
GRANT create session
TO CourtRec01;

USER CREATION:
CREATE USER CourtRec011
IDENTIFIED BY Password9
PASSWORD EXPIRE;
GRANT create session
TO CourtRec01;

USER CREATION:
CREATE USER CrimeAn01
IDENTIFIED BY Password16
PASSWORD EXPIRE;
GRANT create session
TO CrimeAn01;

USER CREATION:
CREATE USER CrimeAn01
IDENTIFIED BY Password16
PASSWORD EXPIRE;
GRANT create session
TO CrimeAn01;

USER CREATION:
CREATE USER CrimeAn01
IDENTIFIED BY Password16
PASSWORD EXPIRE;
GRANT create session
TO CrimeAn01;

USER CREATION:
CREATE USER CrimeAn01
IDENTIFIED BY Password16
PASSWORD EXPIRE;
GRANT create session
TO CrimeAn01;

USER CREATION:
CREATE USER DataOfc
IDENTIFIED BY Password20
PASSWORD EXPIRE;
GRANT create session
TO DataOfc;

SELECT *
FROM Aliases
WHERE Alias LIKE 'B%';

SELECT Crime_ID, Criminal_ID, Date_Charged, Status
FROM Crimes
WHERE Date_Charged BETWEEN '01-OCT-08' AND '31-OCT-08';

SELECT Crime_ID, Criminal_ID, Date_Charged, Classification
FROM Crimes
WHERE Status = 'CA' OR Status = 'IA';

SELECT Crime_ID, Criminal_ID, Date_Charged, Classification
FROM Crimes
WHERE Classification = 'F';

SELECT Crime_ID, Criminal_ID, Date_Charged, Hearing_Date
FROM Crimes
WHERE Hearing_Date - Date_Charged > 14;

SELECT Criminal_ID, Last, ZIP
FROM Criminals
WHERE ZIP = 23510;

SELECT Crime_ID, Criminal_ID, Date_Charged, Hearing_Date
FROM Crimes
WHERE Hearing_Date IS NULL;

SELECT Sentence_ID, Criminal_ID, Prob_ID
FROM Sentences
WHERE Prob_ID IS NOT NULL
ORDER BY Prob_ID, Criminal_ID;

SELECT Crime_ID, Criminal_ID, Classification, Status
FROM Crimes
WHERE Classification = 'M' AND Status = 'IA';

SELECT Charge_ID, Crime_ID, Fine_Amount, Court_Fee, Amount_Paid, Fine_Amount + Court_Fee - Amount_Paid Amount_Owed
FROM crime_charges 
WHERE Fine_Amount + Court_Fee - Amount_Paid > 0;

SELECT Officer_ID, Last, Precinct, Status
FROM Officers
WHERE Precinct IN ('OCVW','GHNT')
	AND Status = 'A'
ORDER BY 3, 1;

1. List criminals with crime charges filed
SELECT c.Criminal_ID, c.last, c.first, cc.Crime_code, cc.Fine_amount
FROM Criminals c, Crimes c2, Crime_charges cc
WHERE c.Criminal_ID = c2.Criminal_ID
AND c2.Crime_id = cc.Crime_id
AND cc.Fine_amount IS NOT NULL;
SELECT c.Criminal_ID, c.last, c.First, cc.Crime_code, cc.Fine_amount
FROM Criminals c JOIN Crimes c2 USING (Criminal_ID)
JOIN Crimes c2 ON Crime_ID
JOIN Crime_charges cc USING (Crime_ID)
AND cc.Fine_amount is NOT NULL;

2.  List all criminals with crime status and appeal status. Show all, no matter if they filed an appeal
SELECT c.Criminal_ID, c.first, c.last, cr.classification, cr.date_charged, a.filing_date, a.status
FROM Criminals c, Crimes cr, Appeals a
WHERE c.Criminal_ID = cr.Criminal_ID
AND cr.Crime_ID = a.Crime_ID;
SELECT c.Criminal_ID, c.first, c.last, cr.classification, cr.date_charged, a.filing_date, a.status
FROM Criminals c JOIN Crimes cr USING (Criminal_ID),
Crimes cr JOIN Appeals a USING (Crime_ID);

SELECT c.Criminal_ID, c.first || ' ' || c.last "Criminal Name",
cr.Classification, cr.Date_charged, cc.Crime_code, cc.Fine_amount
FROM Criminals c, Crimes cr, Crime_charges cc
WHERE c.Criminal_ID = cr.Criminal_ID
AND cr.Crime_ID = cc.Crime_ID
AND cr.Classification = 'O'
ORDER BY c.Criminal_ID DESC, cr.Date_charged;
SELECT Criminal_ID, c.first || ' ' || c.last "Criminal Name",
cr.Classification, cr.Date_charged, cc.Crime_code, cc.Fine_amount
FROM Criminals c JOIN Crimes cr USING (Criminal_ID)
JOIN Crime_charges cc USING (Crime_ID)
WHERE cr.Classification = 'OTHER'
ORDER BY Criminal_ID, Date_charged;

SELECT c.Criminal_ID, c.first || ' ' || c.last "Criminal Name",
c.v_status, c.p_status, a.Alias
FROM Criminals c, Aliases a
WHERE c.Criminal_ID = a.Criminal_ID
ORDER BY "Criminal Name" DESC;
SELECT Criminal_ID, c.first || ' ' || c.last "Criminal Name",
c.v_status, c.p_status, a.Alias
FROM Criminals c JOIN Aliases a USING (Criminal_ID)
ORDER BY "Criminal Name" DESC;

SELECT c.first || ' ' || c.last "Criminal Name",
s.start_date, s.end_date, pc.con_freq
FROM Criminals c, Sentences s, prob_contact pc
WHERE c.Criminal_ID = s.Criminal_ID
AND s.end_date - s.start_date >= pc.low_amt
AND s.end_date - s.start_date <= pc.high_amt
AND s.Type = 'P'
ORDER BY "Criminal Name", s.start_date;
SELECT c.first || ' ' || c.last "Criminal Name",
s.start_date, s.end_date, pc.con_freq
FROM Criminals c JOIN Sentences s USING (Criminal_ID)
JOIN prob_contact pc 
ON s.end_date - s.start_date >= pc.low_amt
AND s.end_date - s.start_date <= pc.high_amt
WHERE s.Type = 'P'
ORDER BY "Criminal Name", s.start_date;

SELECT po.last, po.first, pm.last "Sup. Last", pm.first "Sup. First"
FROM prob_officers po, prob_officers pm
WHERE pm.mgr_id = po.prob_id(+)
ORDER BY po.last;
SELECT po.last, po.first, pm.last "Sup. Last", pm.first "Sup. First"
FROM prob_officers po LEFT OUTER JOIN prob_officers pm
ON po.mgr_ID = pm.prob_id
ORDER BY po.last;

**********
CJ #10
**********
1.
SELECT crime_id "Crime ID", classification "Class.", date_charged "Charge Date", hearing_date "Hearing Date", (hearing_date-date_charged) "Days"
FROM Crimes
WHERE (hearing_date-date_charged) > 14;

2.
SELECT first || ' ' || last "Officer Name", precinct "Code",
	CASE
	WHEN precinct LIKE '_A%' THEN 'Shady Grove'
	WHEN precinct LIKE '_B%' THEN 'Center City'
	WHEN precinct LIKE '_C%' THEN 'Bay Landing'
	END "Precinct"
FROM Officers
WHERE status='A'
	AND precinct LIKE '_A%' OR precinct LIKE '_B%' OR precinct LIKE '_C%';

3.
SELECT c.criminal_id, UPPER(c.first || ' ' || c.last) "Inmate Name", s.sentence_id,
	TO_CHAR(s.start_date, 'MONTH DD, YYYY') "Start Sentence",
	ROUND(MONTHS_BETWEEN(s.end_date, s.start_date)) "Months"
FROM criminals c, sentences s
WHERE c.criminal_id = s.criminal_id;

4.
SELECT c.first || ' ' || c.last "Name", cc.charge_id "Charge ID", TO_CHAR((cc.fine_amount+cc.court_fee), '$9999.999') "Total Owed",
	cc.amount_paid, TO_CHAR(((cc.fine_amount+cc.court_fee)-cc.amount_paid), '$9999.99') "Balance", cc.Pay_due_date "Due Date"
FROM criminals c JOIN crimes cr USING (criminal_id)
	JOIN crime_charges cc USING (crime_id)
WHERE ((cc.fine_amount+cc.court_fee)-cc.amount_paid) > 0;

5.
SELECT c.first || ' ' || c.last "Criminal Name", s.start_date "Start Date", ADD_MONTHS(s.start_date, 2) "Review Date"
FROM criminals c JOIN sentences s USING (criminal_id)
WHERE s.type='P'
	AND MONTHS_BETWEEN(s.end_date,s.start_date) > 2;

6.
INSERT INTO appeals (appeal_id, crime_id, filing_date, hearing_date)
    VALUES (7503, 25344031, TO_DATE('02 13 2009', 'MM DD YYYY'), TO_DATE('02 27 2009', 'MM DD YYYY'));

*************************
**   Case Study 12     **
*************************

1.
SELECT officer_id "Officer ID", last || ', ' || first "Name"
FROM officers JOIN crime_officers USING (officer_id)
JOIN crimes USING (crime_id)
WHERE crime_id > ALL (SELECT AVG(COUNT(*))
                     FROM crimes
                     GROUP BY officer_id);

2.
SELECT criminal_id "Criminal ID", first || ' ' || last "Name"
FROM criminals JOIN crimes USING (criminal_id)
WHERE crime_id < ALL (SELECT AVG(COUNT(*))
                      FROM crimes
                      GROUP BY criminal_id)
AND v_status = 'N';

3.
SELECT *, AVG(hearing_date-filing_date) "Days"
FROM appeals
WHERE 'Days' <ALL (SELECT (hearing_date-filing_date)
                     FROM appeals);

4.
SELECT p.prob_id "ID", p.first || ' ' || p.last "Name"
FROM prob_officers p JOIN sentences s
ON p.prob_id = s.prob_id
WHERE sentence_id <ALL (SELECT AVG(COUNT(*))
                        FROM sentences
                        GROUP BY prob_id);

5.
SELECT c.crime_id, a.hearing_date
FROM crimes c JOIN appeals a
ON c.crime_id = a.crime_id
WHERE a.filing_date >ALL (SELECT MAX(filing_date)
	                      FROM appeals);

6.
SELECT charge_id, crime_id, crime_code, charge_status
FROM crime_charges
WHERE fine_amount >ANY (SELECT AVG(fine_amount)
                        FROM crime_charges
                        WHERE amount_paid <ALL (SELECT AVG(amount_paid)
                        	                    FROM crime_charges));

7.
SELECT first || ' ' || last "Name"
FROM criminals JOIN crimes USING (criminal_id)
WHERE crime_id IN (SELECT crime_id
                     FROM crimes JOIN crime_charges USING (crime_id)
                     WHERE crime_code = 10089);

8.
SELECT last || ', ' || first "Criminal Name", criminal_id "Criminal ID"
FROM criminals
WHERE EXISTS (SELECT criminal_id
                          FROM sentences
                          WHERE prob_id > 0);

9.
SELECT officer_id "Officer ID", first || ' ' || last "Name"
FROM officers JOIN crime_officers USING (officer_id)
JOIN crimes USING (crime_id)
WHERE crime_id > ALL (SELECT AVG(COUNT(*))
                     FROM crimes
                     GROUP BY officer_id);

10. 
MERGE INTO criminals_dw a
USING criminals b
ON a.criminal_id = b.criminal_id
WHEN MATCHED THEN
UPDATE SET a.criminal_id=b.criminal_id,
           a.last=b.last,
           a.first=b.first,
           a.street=b.street,
           a.city=b.city,
           a.state=b.state,
           a.zip=b.zip,
           a.phone=b.phone,
           a.v_status=b.v_status,
           a.p_status=b.p_status
WHEN NOT MATCHED THEN
INSERT INTO (criminal_id,
        last,
        first,
        street,
        city,
        state,
        zip,
        phone,
        v_status,
        p_status)
Values (b.criminal_id,
        b.last,
        b.first,
        b.street,
        b.state,
        b.zip,
        b.phone,
        b.v_status,
        b.p_status);

*************************
**   Case Study 13     **
*************************

1.
SELECT first || ' ' || last "Name", COUNT(crime_id)
FROM criminals JOIN crimes USING (criminal_id)
ORDER BY crime_id
WHERE ROWNUM = 3;

2.
CREATE OR REPLACE VIEW crimedetails
REFRESH COMPLETE
AS SELECT criminal_id, last || ', '|| first "Name", p_status, crime_id, date_charged, status,
          charge_id, crime_code, charge_status, charge_id, pay_due_date, (fine_amount-amount_paid) amount_due
          FROM criminals JOIN crimes USING (criminal_id)
          JOIN crime_charges USING (crime_id)
WITH CHECK OPTION;

3.
CREATE VIEW officers_charges
REFRESH FAST
START WITH SYSDATE NEXT SYSDATE + 14
AS SELECT officer_id, first || ' '|| last "Name", precinct, badge, phone, status, (COUNT(crime_charges))
          FROM officers JOIN crime_officers USING (officer_id)
                        JOIN crime_charges USING (crime_id)
GROUP BY officer_id;