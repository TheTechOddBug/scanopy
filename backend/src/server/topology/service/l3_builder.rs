use std::collections::HashMap;
use uuid::Uuid;

use super::{
    context::TopologyContext, edge_builder::EdgeBuilder, graph_builder::GraphBuilder,
    perspective::PerspectiveBuilder,
};
use crate::server::topology::types::{
    edges::Edge,
    grouping::GroupingConfig,
    nodes::{Node, NodeType},
};

pub struct L3Builder;

impl PerspectiveBuilder for L3Builder {
    fn build(&self, ctx: &TopologyContext, grouping: &GroupingConfig) -> (Vec<Node>, Vec<Edge>) {
        // Create all edges
        let mut all_edges = Vec::new();

        all_edges.extend(EdgeBuilder::create_interface_edges(ctx));
        all_edges.extend(EdgeBuilder::create_group_edges(ctx));
        all_edges.extend(EdgeBuilder::create_vm_host_edges(ctx));
        let (container_edges, docker_bridge_host_subnet_id_to_group_on) =
            EdgeBuilder::create_containerized_service_edges(ctx, grouping);
        all_edges.extend(container_edges);
        all_edges.extend(EdgeBuilder::create_physical_link_edges(ctx));

        // Create nodes (positions zeroed — frontend computes layout via elkjs)
        let mut graph_builder = GraphBuilder::new();
        let (subnet_ids, child_nodes) = graph_builder.create_subnet_child_nodes(
            ctx,
            &mut all_edges,
            grouping,
            docker_bridge_host_subnet_id_to_group_on,
        );

        let mut subnet_nodes = graph_builder.create_subnet_nodes(ctx, &subnet_ids);

        // Set layer_hint on container nodes from subnet vertical_order
        let subnet_type_map: HashMap<Uuid, i32> = ctx
            .subnets
            .iter()
            .map(|s| (s.id, s.base.subnet_type.vertical_order() as i32))
            .collect();
        for node in &mut subnet_nodes {
            if let NodeType::Container {
                ref mut layer_hint, ..
            } = node.node_type
            {
                *layer_hint = subnet_type_map.get(&node.id).copied();
            }
        }

        let all_nodes: Vec<Node> = subnet_nodes.into_iter().chain(child_nodes).collect();
        (all_nodes, all_edges)
    }
}
