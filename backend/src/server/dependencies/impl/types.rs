use crate::server::shared::entities::EntityDiscriminants;
use crate::server::shared::types::{
    Color, Icon,
    metadata::{EntityMetadataProvider, HasId, TypeMetadataProvider},
};
use serde::{Deserialize, Serialize};
use strum_macros::{EnumDiscriminants, EnumIter, IntoStaticStr};
use utoipa::ToSchema;

#[derive(
    Debug,
    Clone,
    Copy,
    Serialize,
    Deserialize,
    Hash,
    PartialEq,
    Eq,
    EnumIter,
    IntoStaticStr,
    EnumDiscriminants,
    Default,
    ToSchema,
)]
#[strum_discriminants(derive(IntoStaticStr, EnumIter, Hash, Deserialize, Serialize))]
#[serde(rename_all = "PascalCase")]
pub enum DependencyType {
    #[default]
    RequestPath,
    HubAndSpoke,
}

impl HasId for DependencyTypeDiscriminants {
    fn id(&self) -> &'static str {
        self.into()
    }
}

impl EntityMetadataProvider for DependencyTypeDiscriminants {
    fn color(&self) -> Color {
        match self {
            DependencyTypeDiscriminants::RequestPath => EntityDiscriminants::Dependency.color(),
            DependencyTypeDiscriminants::HubAndSpoke => EntityDiscriminants::Dependency.color(),
        }
    }

    fn icon(&self) -> Icon {
        match self {
            DependencyTypeDiscriminants::RequestPath => Icon::Route,
            DependencyTypeDiscriminants::HubAndSpoke => Icon::Sun,
        }
    }
}

impl TypeMetadataProvider for DependencyTypeDiscriminants {
    fn name(&self) -> &'static str {
        match self {
            DependencyTypeDiscriminants::RequestPath => "Request Path",
            DependencyTypeDiscriminants::HubAndSpoke => "Hub and Spoke",
        }
    }

    fn description(&self) -> &'static str {
        match self {
            DependencyTypeDiscriminants::RequestPath => {
                "Ordered path of network traffic through services. Represents how requests flow through your infrastructure from one service to another."
            }
            DependencyTypeDiscriminants::HubAndSpoke => {
                "Central service connecting to multiple dependent services in a hub-and-spoke pattern. The first service in the list is the hub."
            }
        }
    }
}
