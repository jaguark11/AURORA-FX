module resilience_optimizer
  use kinds, only: dp
  use grid_types
  use dc_powerflow
  use risk_metrics
  implicit none
contains
  subroutine greedy_stabilize(grid, target_loading, max_steps, stabilized, shed_total, final_loading)
    type(grid_t), intent(in) :: grid
    real(dp), intent(in) :: target_loading
    integer, intent(in) :: max_steps
    type(grid_t), intent(out) :: stabilized
    real(dp), intent(out) :: shed_total, final_loading
    real(dp), allocatable :: theta(:), flows(:)
    integer :: step, info, i, worst_bus
    real(dp) :: largest_demand, amount

    stabilized = grid; shed_total = 0.0_dp
    do step = 0, max_steps
      call solve_dc(stabilized,theta,flows,info)
      if (info /= 0) then
        final_loading = huge(1.0_dp)
      else
        final_loading = max_loading(stabilized,flows)
      end if
      if (final_loading <= target_loading) return
      largest_demand = -1.0_dp; worst_bus = 0
      do i = 1, size(stabilized%buses)
        if (i == stabilized%slack_bus) cycle
        if (stabilized%buses(i)%demand > largest_demand) then
          largest_demand = stabilized%buses(i)%demand; worst_bus = i
        end if
      end do
      if (worst_bus == 0 .or. largest_demand <= 1.0e-9_dp) return
      amount = min(0.05_dp*largest_demand + 0.5_dp, stabilized%buses(worst_bus)%demand)
      stabilized%buses(worst_bus)%demand = stabilized%buses(worst_bus)%demand - amount
      shed_total = shed_total + amount
      if (allocated(theta)) deallocate(theta)
      if (allocated(flows)) deallocate(flows)
    end do
  end subroutine greedy_stabilize
end module resilience_optimizer
