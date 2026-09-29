program aurora_fx
  use kinds, only: dp
  use grid_types
  use grid_io
  use dc_powerflow
  use risk_metrics
  use graph_metrics
  use contingency
  use monte_carlo
  use resilience_optimizer
  use provenance
  implicit none
  type(grid_t) :: grid, stabilized
  real(dp), allocatable :: theta(:), flows(:), risks(:)
  real(dp) :: mean_risk, var95, cvar95, worst_loading, shed, final_loading
  integer :: ierr, info, worst_branch, failed, i
  character(len=64) :: cmd
  character(len=256) :: busf, branchf

  cmd = 'demo'; if (command_argument_count() >= 1) call get_command_argument(1,cmd)
  if (trim(cmd) == '--provenance' .or. trim(cmd) == 'provenance') then
    call print_provenance(); stop
  end if
  busf='data/buses.csv'; branchf='data/branches.csv'
  if (command_argument_count() >= 3) then
    call get_command_argument(2,busf); call get_command_argument(3,branchf)
  end if
  call load_grid(trim(busf),trim(branchf),grid,ierr)
  if (ierr /= 0) then
    print *, 'Failed loading grid, code=', ierr; stop 2
  end if
  grid%slack_bus = 1

  select case(trim(cmd))
  case('demo','solve')
    call solve_dc(grid,theta,flows,info)
    if (info /= 0) then; print *, 'Power flow failed:',info; stop 3; end if
    print '(A,F8.4)', 'Spectral radius: ', graph_spectral_radius(grid)
    print '(A,F8.4)', 'Risk score:      ', overload_score(grid,flows)
    print '(A,F8.4)', 'Max loading:     ', max_loading(grid,flows)
    print '(A)', 'Branch flows:'
    do i=1,size(flows)
      print '(I3,2X,F10.3,2X,A,F7.2)', i, flows(i), 'limit=', grid%branches(i)%limit
    end do
  case('contingency')
    call nminus1_screen(grid,worst_branch,worst_loading,failed)
    print '(A,I0)', 'Worst outage branch: ', worst_branch
    print '(A,F10.4)', 'Worst post-contingency loading: ', worst_loading
    print '(A,I0)', 'Singular/islanded cases: ', failed
  case('montecarlo')
    call simulate_failures(grid,1000,0.03_dp,424242,risks,mean_risk,var95,cvar95)
    print '(A,F8.5)', 'Mean risk: ', mean_risk
    print '(A,F8.5)', 'VaR95:     ', var95
    print '(A,F8.5)', 'CVaR95:    ', cvar95
  case('stabilize')
    call greedy_stabilize(grid,0.95_dp,50,stabilized,shed,final_loading)
    print '(A,F10.4)', 'Load shed: ', shed
    print '(A,F10.4)', 'Final max loading: ', final_loading
  case default
    print *, 'Usage: aurora_fx [demo|contingency|montecarlo|stabilize|provenance] [buses.csv branches.csv]'
  end select
end program aurora_fx
