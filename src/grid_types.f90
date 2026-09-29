module grid_types
  use kinds, only: dp
  implicit none

  type :: bus_t
    integer :: id = 0
    real(dp) :: demand = 0.0_dp
    real(dp) :: generation = 0.0_dp
  end type

  type :: branch_t
    integer :: from_bus = 0
    integer :: to_bus = 0
    real(dp) :: reactance = 0.1_dp
    real(dp) :: limit = 100.0_dp
    logical :: in_service = .true.
  end type

  type :: grid_t
    type(bus_t), allocatable :: buses(:)
    type(branch_t), allocatable :: branches(:)
    integer :: slack_bus = 1
  end type

contains
  pure integer function bus_index(grid, id) result(idx)
    type(grid_t), intent(in) :: grid
    integer, intent(in) :: id
    integer :: i
    idx = 0
    do i = 1, size(grid%buses)
      if (grid%buses(i)%id == id) then
        idx = i
        return
      end if
    end do
  end function bus_index
end module grid_types
