use super::{
    application_builder::ApplicationBuilder, context::TopologyContext,
    infrastructure_builder::InfrastructureBuilder, l3_builder::L3Builder,
};
use crate::server::topology::types::{
    edges::{Edge, TopologyPerspective},
    grouping::GroupingConfig,
    nodes::Node,
};

pub trait PerspectiveBuilder {
    fn build(&self, ctx: &TopologyContext, grouping: &GroupingConfig) -> (Vec<Node>, Vec<Edge>);
}

pub fn builder_for_perspective(perspective: TopologyPerspective) -> Box<dyn PerspectiveBuilder> {
    match perspective {
        TopologyPerspective::L3Logical => Box::new(L3Builder),
        TopologyPerspective::Application => Box::new(ApplicationBuilder),
        TopologyPerspective::Infrastructure => Box::new(InfrastructureBuilder),
        // L2Physical will have its own builder; fall back to L3 for now
        _ => Box::new(L3Builder),
    }
}
