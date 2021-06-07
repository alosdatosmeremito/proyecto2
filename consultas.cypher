//Consulta 1
match (p:Persona)-[:VIU]->(h:Habitatge) where p.Nom <> 'nan' and h.Any=1866 and h.Municipi = 'CR'
return collect(distinct p.Nom), count(*)

//Consulta 2
match (h:Habitatge)
where h.Municipi='SFLL' and h.Any < 1840
return h.Any as Any, collect(h.ID) as Identificadors
ORDER BY h.Any

//Consulta 3
//llista
match (p:Persona)-[:VIU]-(h:Habitatge)-[v:VIU]-(p2:Persona)
where toLower(p.Nom)='rafel' and toLower(p.Cognom)='marti' and h.Any=1838
return p.Nom, collect(p2.Nom)
//graf
match (p:Persona)-[:VIU]-(h:Habitatge)-[v:VIU]-(p2:Persona)
where toLower(p.Nom)='rafel' and toLower(p.Cognom)='marti' and h.Any=1838
return p, collect(p2)

//Consulta 4
match (p:Persona)<-[:Same_As]->(n) where toLower(p.Nom)='miguel' and toLower(p.Cognom)='ballester'
return n
