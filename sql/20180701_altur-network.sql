set search_path = alturayya,public
--SELECT * into alturayya.routes_bak FROM routes 
-- not all places are part of the network
select * into nodes from places 
    where placeid in 
    (select "sID" from routes) or 
    placeid in (select "eID" from routes); -- 1678
-- get node x,y into routes, build non-path line
-- create geom_line
SELECT AddGeometryColumn ('alturayya','routes','geom_line',4326,'LINESTRING',2);
-- sid, eid from routes; drop table bak.routes; select * into bak.routes from routes
-- start/source x1,y1
update routes r set x1=n.lon::numeric, y1=n.lat::numeric from nodes n
    where r.sid = n.placeid
-- end/target x2,y2
update routes r set x2=n.lon::numeric, y2=n.lat::numeric from nodes n
    where r.eid = n.placeid
    
-- make linestring geometry
SELECT ST_AsText(ST_MakeLine(ST_MakePoint(x1,y1), ST_MakePoint(x2,y2)))from routes;
update routes set geom_line = ST_SetSRID( ST_MakeLine(ST_MakePoint(x1,y1), ST_MakePoint(x2,y2)) ,4326);
-- build topology
SELECT  pgr_createTopology('routes', 0.001,'geom_line', 'id', 'source', 'target');

SELECT * FROM pgr_dijkstra('SELECT id, source, target, cost, reverse_cost FROM routes', 2, 3 );

-- node IDs are from routes_vertices_pgr
-- need reverse_cost (or don't factor in query)
update routes set reverse_cost = cost;

-- map nodes to graph IDs
update routes r set snode_id = n.id from nodes n where r.sid = n.placeid;
update routes r set tnode_id = n.id from nodes n where r.eid = n.placeid;

-- map routes_vertices_pgr.id to node_id
-- create routes_vertices_pgr.nodeid 
update routes_vertices_pgr rv set nodeid = r.snode_id from routes r 
    where rv.id = r.source
select count(*) from routes_vertices_pgr where nodeid is null -- 71 were missing, get from target
update routes_vertices_pgr rv set nodeid = r.tnode_id from routes r 
    where rv.id = r.target and rv.nodeid is null
-- get working node id (as graphid) from routes_vertices_pgr into nodes
update nodes n set graphid = rv.id from routes_vertices_pgr rv 
    where n.id = rv.nodeid