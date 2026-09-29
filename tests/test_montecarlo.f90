program test_montecarlo
  use kinds, only: dp
  use grid_types
  use grid_io
  use monte_carlo
  implicit none
  type(grid_t) :: grid
  real(dp), allocatable :: risks(:)
  real(dp) :: mean_risk, var95, cvar95
  integer :: ierr
  call load_grid('data/buses.csv','data/branches.csv',grid,ierr)
  if (ierr /= 0) stop 1
  grid%slack_bus=1
  call simulate_failures(grid,250,0.03_dp,12345,risks,mean_risk,var95,cvar95)
  if (size(risks) /= 250) stop 2
  if (minval(risks) < 0.0_dp .or. maxval(risks) > 1.0_dp) stop 3
  if (cvar95 + 1.0e-12_dp < var95) stop 4
  print *, 'PASS: monte carlo bounded'
  print *, 'PASS: CVaR >= VaR'
end program test_montecarlo
