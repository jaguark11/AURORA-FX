module monte_carlo
  use kinds, only: dp
  use grid_types
  use dc_powerflow
  use risk_metrics
  implicit none
contains
  subroutine seed_rng(seed)
    integer, intent(in) :: seed
    integer :: n, i
    integer, allocatable :: put(:)
    call random_seed(size=n); allocate(put(n))
    do i=1,n; put(i)=mod(seed + 104729*i, 2147483646); end do
    call random_seed(put=put)
  end subroutine seed_rng

  subroutine simulate_failures(grid, trials, failure_prob, seed, risks, mean_risk, var95, cvar95)
    type(grid_t), intent(in) :: grid
    integer, intent(in) :: trials, seed
    real(dp), intent(in) :: failure_prob
    real(dp), allocatable, intent(out) :: risks(:)
    real(dp), intent(out) :: mean_risk, var95, cvar95
    type(grid_t) :: g
    real(dp), allocatable :: theta(:), flows(:)
    real(dp) :: r
    integer :: t, k, info
    allocate(risks(trials)); call seed_rng(seed)
    do t = 1, trials
      g = grid
      do k = 1, size(g%branches)
        call random_number(r)
        if (r < failure_prob) g%branches(k)%in_service = .false.
      end do
      call solve_dc(g,theta,flows,info)
      if (info /= 0) then
        risks(t) = 1.0_dp
      else
        risks(t) = overload_score(g,flows)
      end if
      if (allocated(theta)) deallocate(theta)
      if (allocated(flows)) deallocate(flows)
    end do
    mean_risk = sum(risks)/real(trials,dp)
    call cvar(risks,0.95_dp,var95,cvar95)
  end subroutine simulate_failures
end module monte_carlo
