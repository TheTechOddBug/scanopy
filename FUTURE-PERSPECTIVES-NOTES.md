# Future Perspectives Notes

## L2 Physical
- Could use `ByApplicationGroup` pattern for L2: group by VLAN tag or physical switch
- Physical link edges are already primary in L2 perspective
- Container rule: `BySwitch` or `ByVLAN` would be natural groupings

## Infrastructure
- `ByVirtualizingService` already applies to Infrastructure perspective
- Could add `ByHypervisor` container rule to group VMs under their hypervisor host
- Proxmox integration would feed into this naturally
