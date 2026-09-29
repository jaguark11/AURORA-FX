module dc_powerflow
  use kinds, only: dp
  use grid_types
  use linalg, only: solve_linear
  implicit none
contains
  subroutine solve_dc(grid, theta, flows, info)
    type(grid_t), intent(in) :: grid
    real(dp), allocatable, intent(out) :: theta(:), flows(:)
    integer, intent(out) :: info
    integer :: n, m, i, j, k, fi, ti, slack, rr, cc
    real(dp), allocatable :: B(:,:), P(:), Br(:,:), Pr(:), xr(:)
    real(dp) :: bval

    n = size(grid%buses); m = size(grid%branches); slack = grid%slack_bus
    allocate(theta(n), flows(m), B(n,n), P(n)); B = 0.0_dp; P = 0.0_dp
    do i = 1, n
      P(i) = grid%buses(i)%generation - grid%buses(i)%demand
    end do
    ! Balance mismatch at slack bus.
    P(slack) = P(slack) - sum(P)

    do k = 1, m
      if (.not. grid%branches(k)%in_service) cycle
      fi = bus_index(grid, grid%branches(k)%from_bus)
      ti = bus_index(grid, grid%branches(k)%to_bus)
      if (fi == 0 .or. ti == 0) cycle
      bval = 1.0_dp / grid%branches(k)%reactance
      B(fi,fi) = B(fi,fi) + bval; B(ti,ti) = B(ti,ti) + bval
      B(fi,ti) = B(fi,ti) - bval; B(ti,fi) = B(ti,fi) - bval
    end do

    allocate(Br(n-1,n-1), Pr(n-1), xr(n-1))
    rr = 0
    do i = 1, n
      if (i == slack) cycle
      rr = rr + 1; Pr(rr) = P(i); cc = 0
      do j = 1, n
        if (j == slack) cycle
        cc = cc + 1; Br(rr,cc) = B(i,j)
      end do
    end do
    call solve_linear(Br, Pr, xr, info)
    if (info /= 0) then
      theta = 0.0_dp; flows = huge(1.0_dp); return
    end if
    theta = 0.0_dp; rr = 0
    do i = 1, n
      if (i == slack) cycle
      rr = rr + 1; theta(i) = xr(rr)
    end do

    do k = 1, m
      if (.not. grid%branches(k)%in_service) then
        flows(k) = 0.0_dp; cycle
      end if
      fi = bus_index(grid, grid%branches(k)%from_bus)
      ti = bus_index(grid, grid%branches(k)%to_bus)
      flows(k) = (theta(fi)-theta(ti)) / grid%branches(k)%reactance
    end do
  end subroutine solve_dc
end module dc_powerflow
