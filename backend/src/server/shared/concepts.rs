use serde::{Deserialize, Serialize};
use strum_macros::{Display, EnumDiscriminants, EnumIter, IntoStaticStr};

use crate::server::shared::types::{
    Color, Icon,
    metadata::{EntityMetadataProvider, HasId},
};

#[derive(
    Debug,
    Clone,
    PartialEq,
    Eq,
    Hash,
    EnumDiscriminants,
    EnumIter,
    IntoStaticStr,
    Serialize,
    Deserialize,
    Display,
)]
#[strum_discriminants(derive(Display, Hash, EnumIter, IntoStaticStr))]
pub enum Concept {
    Dns,
    Vpn,
    Gateway,
    ReverseProxy,
    IoT,
    Storage,
    Virtualization,
    SNMP,
    L2,
    L3,
    Application,
    Infrastructure,
}

impl HasId for Concept {
    fn id(&self) -> &'static str {
        self.into()
    }
}

impl EntityMetadataProvider for Concept {
    fn color(&self) -> Color {
        match self {
            Concept::Dns => Color::Emerald,
            Concept::Vpn => Color::Green,
            Concept::Gateway => Color::Teal,
            Concept::ReverseProxy => Color::Cyan,
            Concept::IoT => Color::Yellow,
            Concept::Storage => Color::Green,
            Concept::Virtualization => Color::Indigo,
            Concept::SNMP => Color::Pink,
            Concept::L2 => Color::Emerald,
            Concept::L3 => Color::Blue,
            Concept::Application => Color::Purple,
            Concept::Infrastructure => Color::Orange,
        }
    }

    fn icon(&self) -> Icon {
        match self {
            Concept::Dns => Icon::Search,
            Concept::Vpn => Icon::VenetianMask,
            Concept::Gateway => Icon::Router,
            Concept::ReverseProxy => Icon::Split,
            Concept::IoT => Icon::Cpu,
            Concept::Storage => Icon::HardDrive,
            Concept::Virtualization => Icon::Boxes,
            Concept::SNMP => Icon::Activity,
            Concept::L2 => Icon::Cable,
            Concept::L3 => Icon::Network,
            Concept::Application => Icon::AppWindow,
            Concept::Infrastructure => Icon::Server,
        }
    }
}
