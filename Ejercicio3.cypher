//Ejercicio 3

CALL gds.graph.create('Padrons',
['Persona','Habitatge'],['VIU', 'FAMILIA'])

CALL gds.wcc.stream("Padrons", {}) YIELD nodeId, componentId AS community
WITH gds.util.asNode(nodeId) AS node, community
WITH collect(node) AS allNodes, community
where not any(node in allNodes where labels(node)=['Habitatge'])
RETURN count(*)

CALL gds.wcc.stream("Padrons", {}) YIELD nodeId, componentId AS community
WITH gds.util.asNode(nodeId) AS node, community
WITH collect(node) AS allNodes, community
where not any(node in allNodes where labels(node)=['Habitatge'])
RETURN community, size(allNodes) as num 
order by num desc

CALL gds.wcc.stream("Padrons", {}) YIELD nodeId, componentId AS community
WITH gds.util.asNode(nodeId) AS node, community
WITH collect(node) AS allNodes, community
with community, size(allNodes) as pers
where not any(node in allNodes where labels(node)=['Habitatge'])
RETURN sum(pers)


//b
match (h1:Habitatge), (h2:Habitatge)
where h1.Numero <> 'nan' and h2.Numero <> 'nan' and h1.Municipi <> 'null' and h2.Municipi <> 'null' and h1.Municipi=h2.Municipi and h1.Carrer=h2.Carrer and h1.Numero=h2.Numero and h1.Any>h2.Any
Merge (h1)-[:MATEIX_HAB]->(h2)
return h1, h2

CALL gds.graph.create('Similar',
  ['Persona','Habitatge'],['VIU', 'FAMILIA', 'MATEIX_HAB'])
  
CALL gds.nodeSimilarity.stats('Similar')
YIELD nodesCompared, similarityDistribution

CALL gds.nodeSimilarity.write('Similar',{
  writeRelationshipType:'SIMILAR',
  writeProperty:'score',
  similarityCutoff:0.45,
  topK:5
  })
YIELD nodesCompared, relationshipsWritten

match (p1:Persona)-[:SAME_AS]-(p2:Persona)
where (p1)-[:SIMILAR]-(p2)
return p1, p2

match (p1:Habitatge)-[:MATEIX_HAB]-(p2:Habitatge)
where (p1)-[:SIMILAR]-(p2)
return count(*)

match (p1:Habitatge)-[:MATEIX_HAB]-(p2:Habitatge)
return count(*)
