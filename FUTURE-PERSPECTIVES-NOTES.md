# Future Perspectives Notes

## L2 Physical
- Could use `ByApplicationGroup` pattern for L2: group by VLAN tag or physical switch
- Physical link edges are already primary in L2 perspective
- Container rule: `BySwitch` or `ByVLAN` would be natural groupings
- **Element (interface port):** SectionIdentity shows the IfEntry data (physical port name, MAC, ifIndex). SectionIfEntryData shows full SNMP status, speed, and LLDP/CDP neighbor details. SectionTags for host tags.
- **Container:** SectionIdentity shows the VLAN or broadcast domain name. SectionElementSummary shows port count.
- **Edge inspector:** PhysicalLink edges should show source/target IfEntry details, discovery protocol (LLDP/CDP), and neighbor resolution details. The InspectorEdgePhysicalLink component already handles this.
- **ElementEntityType:** Would likely be `Interface` (same as L3) but resolved differently — matching IfEntry rather than IP interface.

## Infrastructure
- `ByVirtualizingService` already applies to Infrastructure perspective
- Could add `ByHypervisor` container rule to group VMs under their hypervisor host
- Proxmox integration would feed into this naturally
- **Element (host/VM):** SectionIdentity shows the host with virtualization info. SectionServices shows services running on the host. SectionTags for host tags.
- **Container (hypervisor/cluster):** SectionIdentity shows the hypervisor service name and host. SectionElementSummary shows VM count.
- **Edge inspector:** HostVirtualization and ServiceVirtualization edges already have dedicated inspectors. These work well for Infrastructure perspective.
- **ElementEntityType:** May need a new `Host` variant or reuse `Interface` with different resolution logic. Alternatively, use `Service` where the element represents a VM service.
- **Key difference from L3:** Grouping is by virtualization hierarchy (hypervisor → VMs) rather than by subnet.
