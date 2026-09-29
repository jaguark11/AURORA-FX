module contingency
  use kinds, only: dp
  use grid_types
  use dc_powerflow
  use risk_metrics
  implicit none
contains
  subroutine nminus1_screen(grid, worst_branch, worst_loading, failed_cases)
    type(grid_t), intent(in) :: grid
    integer, intent(out) :: worst_branch, failed_cases
    real(dp), intent(out) :: worst_loading
    type(grid_t) :: g
    real(dp), allocatable :: theta(:), flows(:)
    integer :: k, info
    real(dp) :: load
    worst_branch = 0; worst_loading = -1.0_dp; failed_cases = 0
    do k = 1, size(grid%branches)
      g = grid; g%branches(k)%in_service = .false.
      call solve_dc(g,theta,flows,info)
      if (info /= 0) then
        failed_cases = failed_cases + 1
        load = huge(1.0_dp)
      else
        load = max_loading(g,flows)
      end if
      if (load > worst_loading) then
        worst_loading = load; worst_branch = k
      end if
      if (allocated(theta)) deallocate(theta)
      if (allocated(flows)) deallocate(flows)
    end do
  end subroutine nminus1_screen
end module contingency
