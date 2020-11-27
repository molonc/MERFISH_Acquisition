function hybrid_workflow(mega, MVP1, MVP2, MVP3, fluid_num)
    wash(mega, MVP1, MVP2, wash_t)
    rinse(mega, MVP2, 5)
    hybrid_buffer(mega, MVP2, MVP3, fluid_num)
    rinse(mega, MVP2, 5)
    imaging(mega, MVP2, imaging_t)
    rinse(mega, MVP2, 5)
end