-- set search_path = owtrad, public
--{
--    "type": "Feature",
--    "geometry": {
--        "type": "LineString",
--        "coordinates": []
--    },
--    "properties": {
--        "sToponym": "RIHA_354E318N_S",
--        "eToponym": "NABULUS_352E322N_S",
--        "id": "CR0001_FROM354E318N_TO352E322N",
--        "Meter": 48742
--    }
--},
SELECT DISTINCT(dataid) FROM routes_asia
SELECT count(*) FROM routes_asia

SELECT json_build_object(
    'type','Feature', 
    'geometry',st_asgeojson(geom),
    'properties', json_build_object(
        'sToponym',node1||'_'||nodeid1,
        'eToponym',node2||'_'||nodeid2,
        'id',dataid,'Meter', st_length(geom))
) FROM routes_asia

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'owtrad'
  AND table_name   = 'routes_europe'
