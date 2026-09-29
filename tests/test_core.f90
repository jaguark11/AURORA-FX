program test_core
  use kinds, only: dp
  use grid_types
  use grid_io
  use dc_powerflow
  use risk_metrics
  use contingency
  implicit none
  type(grid_t) :: grid
  real(dp), allocatable :: theta(:), flows(:)
  real(dp) :: ml
  integer :: ierr, info, wb, failed
  call load_grid('data/buses.csv','data/branches.csv',grid,ierr)
  call assert_true(ierr==0,'grid loads')
  grid%slack_bus=1
  call solve_dc(grid,theta,flows,info)
  call assert_true(info==0,'dc powerflow converges')
  call assert_true(size(flows)==size(grid%branches),'flow vector dimension')
  ml=max_loading(grid,flows)
  call assert_true(ml>0.0_dp .and. ml<10.0_dp,'max loading finite')
  call assert_true(overload_score(grid,flows)>=0.0_dp .and. overload_score(grid,flows)<=1.0_dp,'risk bounded')
  call nminus1_screen(grid,wb,ml,failed)
  call assert_true(wb>=1 .and. wb<=size(grid%branches),'n-1 worst branch valid')
  print *, 'ALL TESTS PASSED'
contains
  subroutine assert_true(cond,name)
    logical,intent(in)::cond
    character(len=*),intent(in)::name
    if (.not. cond) then
      print *, 'FAIL: ', trim(name); stop 1
    else
      print *, 'PASS: ', trim(name)
    end if
  end subroutine
end program test_core
