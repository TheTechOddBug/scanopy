use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

use crate::server::{bindings::r#impl::base::Binding, services::r#impl::base::Service};

const SUBNET_CHILD_HEADER_HEIGHT: usize = 25;
const SUBNET_CHILD_FOOTER_HEIGHT: usize = 25;
const HEIGHT_PER_SERVICE_IN_SUBNET_CHILD: usize = 50;
const SUBNET_CHILD_WIDTH: usize = 250;

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Default, PartialEq, Eq, Hash, ToSchema)]
pub struct Uxy {
    pub x: usize,
    pub y: usize,
}

impl Uxy {
    pub fn subnet_child_size_from_service_count(
        services: &[&Service],
        interface_id: Uuid,
        has_header: bool,
        hide_ports: bool,
    ) -> Self {
        let service_area_height: usize = if services.is_empty() {
            HEIGHT_PER_SERVICE_IN_SUBNET_CHILD
        } else {
            services
                .iter()
                .map(|s| {
                    let bindings_with_ports = s
                        .base
                        .bindings
                        .iter()
                        .filter(|b| {
                            b.interface_id().map(|i| i == interface_id).unwrap_or(true)
                                && b.port_id().is_some()
                        })
                        .collect::<Vec<&Binding>>()
                        .len();
                    HEIGHT_PER_SERVICE_IN_SUBNET_CHILD
                        + if hide_ports && bindings_with_ports > 0 {
                            0
                        } else {
                            25
                        }
                })
                .sum()
        };

        Self {
            x: SUBNET_CHILD_WIDTH,
            y: service_area_height
                + SUBNET_CHILD_FOOTER_HEIGHT
                + if has_header {
                    SUBNET_CHILD_HEADER_HEIGHT
                } else {
                    0
                },
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Default, PartialEq, Eq, Hash, ToSchema)]
pub struct Ixy {
    pub x: isize,
    pub y: isize,
}
