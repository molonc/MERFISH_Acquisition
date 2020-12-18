function hybrid_workflow(mega, MVP1, MVP2, MVP3, fluid_num)
    wash(mega, MVP1, MVP2, wash_t)
    emptyWaste(mega, MVP2)
    hybrid_buffer(mega, MVP2, MVP3, fluid_num)
    emptyWaste(mega, MVP2)
    imaging(mega, MVP2, imaging_t)
    emptyWaste(mega, MVP2)
end