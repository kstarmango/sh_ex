package egovframework.mango.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Map;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.datasource.SingleConnectionDataSource;

public class SHAnalysisBaseService {

	private String node_table_name = "seoul_walk_node";
	private String link_table_name = "seoul_walk_link";
	public SingleConnectionDataSource openServiceAreaDataSource() {
		String url = SHResource.getValue("spring.network.dburi");
		String username = SHResource.getValue("spring.network.dbuser");
		String password = SHResource.getValue("spring.network.dbpassword");
		
		SingleConnectionDataSource singleDatasource = null;
		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(url, username, password);
			singleDatasource = new SingleConnectionDataSource(connection, true);
        } catch (SQLException e) {
        	singleDatasource = null;
        } catch(Exception e) {
        	singleDatasource = null;
		}
		return singleDatasource;
	}
	
	public void destroyServiceAreaDatasource(SingleConnectionDataSource singleDatasource) {
		if(singleDatasource != null) {
			try {
				singleDatasource.destroy();
			} catch(NullPointerException e) {
				singleDatasource = null;
			} catch(Exception e) {
				singleDatasource = null;
			}
		}
	}
	
	public NamedParameterJdbcTemplate getServiceAreaJdbcNamedParameter(SingleConnectionDataSource singleDatasource) {
		NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(singleDatasource);
		return namedParameterJdbcTemplate;
	}
	
	public Map<String, Object> getServiceArea(SingleConnectionDataSource singleDatasource, Map<String, Object> paramMap) {
		NamedParameterJdbcTemplate secondNamedTemplate = getServiceAreaJdbcNamedParameter(singleDatasource);
		StringBuffer sb = new StringBuffer();
		sb.append("WITH starting_point AS (\r\n");
		sb.append("	    SELECT node_id\r\n");
		sb.append("	    FROM ");
		sb.append(node_table_name);
		sb.append("	\r\n");
		sb.append("	    ORDER BY geom <-> st_transform(ST_SetSRID(ST_MakePoint(");
		sb.append(":coord_x");
		sb.append(", ");
		sb.append(":coord_y");
		sb.append("), ");
		sb.append(":srid");
		sb.append("),5179)\r\n");
		sb.append("	    LIMIT 1\r\n");
		sb.append("	),\r\n");
		sb.append("	driving_distance AS (\r\n");
		sb.append("	    SELECT *\r\n");
		sb.append("	    FROM pgr_drivingDistance(\r\n");
		sb.append("	        'SELECT link_id as id, source, target, length AS cost FROM ");
		sb.append(link_table_name);
		sb.append("	',\r\n");
		sb.append("	        (SELECT node_id as id FROM starting_point), ");
		sb.append(":distance");
		sb.append(", false\r\n");
		sb.append("	    )\r\n");
		sb.append("	)\r\n");
		sb.append("	SELECT st_astext(st_transform(st_concaveHull(ST_Collect(geom), ");
		Double convexRadius = (Double) paramMap.get("convex_radius");
		if(convexRadius == null) {
			convexRadius = 0.5;
		}
		sb.append(convexRadius);
		sb.append("	),");
		sb.append(":srid");
		sb.append("	)\r\n");
		sb.append(")	as service_area\r\n");
		String edgeOrNode = (String) paramMap.get("edge_or_node");
		if (edgeOrNode.equalsIgnoreCase("edge")) {
			sb.append("	FROM ");
			sb.append(link_table_name);
			sb.append("	n, driving_distance dd\r\n");
			sb.append("	WHERE n.link_id = dd.edge\r\n");
		} else {
			sb.append("	FROM ");
			sb.append(node_table_name);
			sb.append("	n, driving_distance dd\r\n");
			sb.append("	WHERE n.node_id = dd.node\r\n");
		}
		try {
			return secondNamedTemplate.queryForMap(sb.toString(), paramMap);
		} catch (EmptyResultDataAccessException erdae) {
			return null;
		}
	}
	
	public Map<String, Object> getShortestPath(SingleConnectionDataSource singleDatasource, Map<String, Object> paramMap) {
		NamedParameterJdbcTemplate secondNamedTemplate = getServiceAreaJdbcNamedParameter(singleDatasource);
		StringBuffer sb = new StringBuffer();
		sb.append("	WITH path AS ( \r\n");
		sb.append("			SELECT * FROM pgr_dijkstra( \r\n");
		sb.append("				'SELECT link_id id, source, target, length as cost FROM  \r\n");
		sb.append(link_table_name);
		sb.append("				', \r\n");
		sb.append("				(SELECT node_id id FROM  \r\n");
		sb.append(node_table_name);
		sb.append("				 order by geom <-> st_transform(ST_SetSRID(ST_MakePoint( \r\n");
		sb.append(":start_coord_x");
		sb.append("					 ,  \r\n");
		sb.append(":start_coord_y");
		sb.append("				 ),  \r\n");
		sb.append(":srid");
		sb.append("														  ), 5179) \r\n");
		sb.append("				 limit 1 \r\n");
		sb.append("				), \r\n");
		sb.append("				(SELECT node_id id FROM  \r\n");
		sb.append(node_table_name);
		sb.append("				order by geom <-> st_transform(ST_SetSRID(ST_MakePoint( \r\n");
		sb.append(":end_coord_x");
		sb.append("					,  \r\n");
		sb.append(":end_coord_y");
		sb.append("				),  \r\n");
		sb.append(":srid");
		sb.append("														 ), 5179) \r\n");
		sb.append("				 limit 1 \r\n");
		sb.append("				), \r\n");
		sb.append("				directed := false \r\n");
		sb.append("			) \r\n");
		sb.append("		) \r\n");
		sb.append("		select \r\n");
		sb.append("			(select node from path where path_seq = start_seq) start_node, \r\n");
		sb.append("			(select node from path where path_seq = end_seq) end_node, \r\n");
		sb.append("			* \r\n");
		sb.append("		from \r\n");
		sb.append("		( \r\n");
		sb.append("			SELECT \r\n");
		sb.append("				count(path.seq) path_cnt, \r\n");
		sb.append("				min(path.path_seq) start_seq, \r\n");
		sb.append("				max(path.path_seq) end_seq, \r\n");
		sb.append("				max(path.agg_cost) as cost, \r\n");
		sb.append("				st_astext(st_transform(st_collect(edges.geom),  \r\n");
		sb.append(":srid");
		sb.append("							)) AS geom \r\n");
		sb.append("			FROM \r\n");
		sb.append("				path \r\n");
		sb.append("			JOIN \r\n");
		sb.append(link_table_name);
		sb.append("			edges  \r\n");
		sb.append("			ON path.edge = edges.link_id \r\n");
		sb.append("		) r	");
		try {
			return secondNamedTemplate.queryForMap(sb.toString(), paramMap);
		} catch (EmptyResultDataAccessException erdae) {
			return null;
		}
	}
}
