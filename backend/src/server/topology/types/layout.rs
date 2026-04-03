use serde::{Deserialize, Serialize};
use utoipa::ToSchema;

use crate::server::services::r#impl::base::Service;

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
    pub fn subnet_child_size_from_service_count(services: &[&Service], has_header: bool) -> Self {
        // Always compute height as if ports are shown — this is just a
        // MINIMUM_SIZE hint for elkjs; the frontend handles display options.
        let service_area_height: usize = if services.is_empty() {
            HEIGHT_PER_SERVICE_IN_SUBNET_CHILD
        } else {
            services.len() * (HEIGHT_PER_SERVICE_IN_SUBNET_CHILD + 25)
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
