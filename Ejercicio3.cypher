//Ejercicio 3
//b
match (h1:Habitatge), (h2:Habitatge)
where h1.Any>h2.Any and h1.ID=h2.ID and h1.Municipi=h2.Municipi
Merge (h1)-[:MATEIX_HAB]->(h2)
return h1, h2

CALL gds.graph.create('Padrons',
  ['Persona','Habitatge'],['VIU', 'FAMILIA', 'MATEIX_HAB'])
CALL gds.nodeSimilarity.stats('Padrons')
YIELD nodesCompared, similarityDistribution

CALL gds.nodeSimilarity.write('Padrons',{
  writeRelationshipType:'SIMILAR',
  writeProperty:'score',
  similarityCutoff:0.45,
  topK:5
  })
YIELD nodesCompared, relationshipsWritten

CALL gds.nodeSimilarity.stats('Padrons')
YIELD nodesCompared, similarityDistribution
