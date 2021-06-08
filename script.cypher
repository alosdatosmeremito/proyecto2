match (a) -[r] -> () delete a, r;
match (a) delete a;
CALL apoc.schema.assert({},{},true) YIELD label, key RETURN *;

CREATE CONSTRAINT PrimaryKey_Persona on (p:Persona) ASSERT p.ID IS UNIQUE;
CREATE CONSTRAINT PrimaryKey_Habitatge on (h:Habitatge) ASSERT h.Unique IS UNIQUE;

CREATE INDEX IndexHabitatge FOR (h:Habitatge) ON (h.ID, h.Any, h.Municipi);

LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTfU6oJBZhmhzzkV_0-avABPzHTdXy8851ySDbn2gq32WwaNmYxfiBtCGJGOZsMgCWjzlEGX4Zh1wqe/pub?output=csv' as row
Merge (p:Persona {ID: toInteger(row.Id), Nom: row.name, Cognom: row.surname, Segon_Cognom: COALESCE(row.second_name, 'nan'), Any: toInteger(row.Year)})
return NULL;

LOAD CSV WITH HEADERS FROM "https://docs.google.com/spreadsheets/d/e/2PACX-1vT0ZhR6BSO_M72JEmxXKs6GLuOwxm_Oy-0UruLJeX8_R04KAcICuvrwn2OENQhtuvddU5RSJSclHRJf/pub?output=csv" as row
Merge (:Habitatge {ID: toInteger(row.Id_Llar), Any: toInteger(row.Any_Padro), Carrer: row.Carrer, Numero: COALESCE(toInteger(row.Numero), 'nan'), Municipi: row.Municipi, Unique: row.Id_Llar + ', ' + row.Any_Padro + ', ' + row.Municipi})
return NULL;

LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRVOoMAMoxHiGboTjCIHo2yT30CCWgVHgocGnVJxiCTgyurtmqCfAFahHajobVzwXFLwhqajz1fqA8d/pub?output=csv' AS row
match (p1:Persona) where toInteger(row.ID_1) = p1.ID
match (p2:Persona) where toInteger(row.ID_2) = p2.ID
Merge (p1)<-[:FAMILIA {Relacio: row.Relacio, Relacio_Harmonitzada: row.Relacio_Harmonitzada}]-(p2)
return NULL;

LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRM4DPeqFmv7w6kLH5msNk6_Hdh1wuExRirgysZKO_Q70L21MKBkDISIyjvdm8shVixl5Tcw_5zCfdg/pub?output=csv' AS row
match (p:Persona) where toInteger(row.IND) = p.ID
match (h:Habitatge) where toInteger(row.HOUSE_ID) = h.ID and row.Location = h.Municipi and toInteger(row.Year) = h.Any
Merge (p)-[:VIU]->(h)
return NULL;

LOAD CSV WITH HEADERS FROM 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTgC8TBmdXhjUOPKJxyiZSpetPYjaRC34gmxHj6H2AWvXTGbg7MLKVdJnwuh5bIeer7WLUi0OigI6wc/pub?output=csv' AS row
match (p1:Persona) where toInteger(row.Id_A) = p1.ID
match (p2:Persona) where toInteger(row.Id_B) = p2.ID
Merge (p1)<-[:SAME_AS]-(p2)
return NULL;
