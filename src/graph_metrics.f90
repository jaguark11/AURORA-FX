module graph_metrics
  use kinds, only: dp
  use grid_types
  use linalg, only: spectral_radius_power
  implicit none
contains
  subroutine adjacency_matrix(grid, A)
    type(grid_t), intent(in) :: grid
    real(dp), allocatable, intent(out) :: A(:,:)
    integer :: n, k, i, j
    n = size(grid%buses); allocate(A(n,n)); A = 0.0_dp
    do k = 1, size(grid%branches)
      if (.not. grid%branches(k)%in_service) cycle
      i = bus_index(grid, grid%branches(k)%from_bus); j = bus_index(grid, grid%branches(k)%to_bus)
      if (i>0 .and. j>0) then
        A(i,j)=1.0_dp; A(j,i)=1.0_dp
      end if
    end do
  end subroutine adjacency_matrix

  real(dp) function graph_spectral_radius(grid) result(r)
    type(grid_t), intent(in) :: grid
    real(dp), allocatable :: A(:,:)
    call adjacency_matrix(grid,A); r = spectral_radius_power(A)
  end function graph_spectral_radius
end module graph_metrics
