module grid_io
  use kinds, only: dp
  use grid_types
  implicit none
contains
  subroutine load_grid(bus_file, branch_file, grid, ierr)
    character(len=*), intent(in) :: bus_file, branch_file
    type(grid_t), intent(out) :: grid
    integer, intent(out) :: ierr
    integer :: u, ios, n, i
    character(len=512) :: line

    ierr = 0; n = 0
    open(newunit=u, file=bus_file, status='old', action='read', iostat=ios)
    if (ios /= 0) then; ierr = 1; return; end if
    read(u,'(A)',iostat=ios) line
    do
      read(u,'(A)',iostat=ios) line
      if (ios /= 0) exit
      if (len_trim(line) > 0) n = n + 1
    end do
    rewind(u); read(u,'(A)') line
    allocate(grid%buses(n))
    do i = 1, n
      read(u,*,iostat=ios) grid%buses(i)%id, grid%buses(i)%demand, grid%buses(i)%generation
      if (ios /= 0) then; ierr = 2; close(u); return; end if
    end do
    close(u)

    n = 0
    open(newunit=u, file=branch_file, status='old', action='read', iostat=ios)
    if (ios /= 0) then; ierr = 3; return; end if
    read(u,'(A)') line
    do
      read(u,'(A)',iostat=ios) line
      if (ios /= 0) exit
      if (len_trim(line) > 0) n = n + 1
    end do
    rewind(u); read(u,'(A)') line
    allocate(grid%branches(n))
    do i = 1, n
      read(u,*,iostat=ios) grid%branches(i)%from_bus, grid%branches(i)%to_bus, &
        grid%branches(i)%reactance, grid%branches(i)%limit
      if (ios /= 0) then; ierr = 4; close(u); return; end if
      grid%branches(i)%in_service = .true.
    end do
    close(u)
  end subroutine load_grid
end module grid_io
