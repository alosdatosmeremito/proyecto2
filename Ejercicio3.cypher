//Ejercicio 3
//a-1
CALL gds.wcc.stream({
  nodeProjection: '*',
  relationshipProjection: {
    relType: {
      type: '*',
      orientation: 'UNDIRECTED',
      properties: {}
    }
  }
}) YIELD nodeId, componentId AS community
WITH gds.util.asNode(nodeId) AS node, community
WITH collect(node) AS allNodes, community
RETURN community, size(allNodes) AS size
ORDER BY size DESC
LIMIT toInteger(100)

//a-2


//a-3
match (:Persona)-[:VIU]->(h:Habitatge)
with h.Any as anyo, h.Municipi as Municipio, count(*) as relaciones
return Municipio, collect(anyo), collect(relaciones)

//a-4
CALL gds.wcc.stream({
  nodeProjection: '*',
  relationshipProjection: {
    relType: {
      type: '*',
      orientation: 'UNDIRECTED',
      properties: {}
    }
  }
}) YIELD nodeId, componentId AS community
WITH gds.util.asNode(nodeId) AS node, community
WITH collect(node) AS allNodes, community
where not any(node in allNodes where labels(node)=['Habitatge'])
RETURN count(*)

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
