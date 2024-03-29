//Consulta 1
match (p:Persona)-[:VIU]->(h:Habitatge) where p.Nom <> 'nan' and h.Any=1866 and h.Municipi = 'CR'
return count(*) as Num_Habitants, collect(distinct p.Nom) as Llistat

//Consulta 2
match (h:Habitatge)
where h.Municipi='SFLL' and h.Any < 1840
return h.Any as Any, collect(h.ID) as Llista_Llars
ORDER BY h.Any

//Consulta 3
//llista
match (p:Persona)-[:VIU]-(h:Habitatge)-[v:VIU]-(p2:Persona)
where toLower(p.Nom)='rafel' and toLower(p.Cognom)='marti' and h.Any=1838
return p.Nom as Nom, collect(p2.Nom) as Convivents
//graf
match (p:Persona)-[:VIU]-(h:Habitatge)-[v:VIU]-(p2:Persona)
where toLower(p.Nom)='rafel' and toLower(p.Cognom)='marti' and h.Any=1838
return p, collect(p2)

//Consulta 4
match path=(p:Persona)<-[r:SAME_AS]->(n) where toLower(p.Nom)='miguel' and toLower(p.Cognom)='ballester'
return path

//Consulta 5
match(p:Persona)-[:SAME_AS]-(n)
where p.Nom = 'antonio' and p.Cognom = 'farran' 
return n.Nom as Nom,n.Cognom as Cognom1,n.Segon_Cognom as Cognom2,"SAME_AS" as Tipus
UNION ALL
match(p:Persona)-[:FAMILIA]-(n) 
where p.Nom = 'antonio' and p.Cognom = 'farran'
return n.Nom as Nom,n.Cognom as Cognom1,n.Segon_Cognom as Cognom2,"FAMILIA" as Tipus

//Consulta 6
match (:Persona)-[x:FAMILIA]-(:Persona)
where x.Relacio_Harmonitzada <> 'null'
return distinct x.Relacio_Harmonitzada as Relacions_Familiars

//Consulta 7
match (h:Habitatge{Municipi:'SFLL'}) 
where h.Carrer <> 'nan' and h.Numero <> 'nan' 
return (h.Carrer) as Carrer, h.Numero as Numero_Carrer, count(distinct h.Any) as Total, collect(distinct h.Any) as Anys, collect(h.ID) as Ids 
order by Total desc, h.Carrer, h.Numero limit 10

//Consulta 8
match(h:Habitatge)<-[:VIU]-(p:Persona)-[r:FAMILIA]->(n), (h:Habitatge)<-[:VIU]-(pe:Persona)-[re:FAMILIA]->(n) 
where h.Municipi='CR' and (toLower(r.Relacio)='cap' or toLower(r.Relacio)='cabeza') and (toLower(re.Relacio)='hijo' or toLower(re.Relacio)='hija' or toLower(re.Relacio_Harmonitzada) = 'fill' or toLower(re.Relacio_Harmonitzada) = 'filla') 
return distinct p.Nom as nombre, p.Cognom as apellido, p.Segon_Cognom as segundo_apellido, size(collect(pe)) as fills 
order by fills DESC limit 20

//Consulta 9
match(h1:Habitatge) where h1.Any = 1881 and h1.Municipi = 'SFLL' with count(distinct(h1)) as num
match(h:Habitatge)<-[:VIU]-(p:Persona)-[r:FAMILIA]->(n)
where h.Any = 1881 and h.Municipi = 'SFLL' and (toLower(r.Relacio)='hijo' or toLower(r.Relacio)='hija' or toLower(r.Relacio_Harmonitzada) = 'fill' or toLower(r.Relacio_Harmonitzada) = 'filla')
return count(distinct(p)) as Total_Fills, num as Num_Llars, toFloat(count(distinct(p)))/toFloat(num) as Mitjana

//Consulta 10
match (h:Habitatge)-[:VIU]-(p:Persona)
where h.Municipi='SFLL'
with h.Any as Any, h.Carrer as Carrer, count(*) as num_hab
Order by Any, num_hab
return Any, collect(Carrer)[0] as Carrer, collect(num_hab)[0] as Num_Habitants
