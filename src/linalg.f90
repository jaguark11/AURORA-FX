module linalg
  use kinds, only: dp
  implicit none
contains
  subroutine solve_linear(A, b, x, info)
    real(dp), intent(in) :: A(:,:), b(:)
    real(dp), intent(out) :: x(:)
    integer, intent(out) :: info
    real(dp), allocatable :: M(:,:), rhs(:), tmp_row(:)
    real(dp) :: factor, pivot_tmp
    integer :: n, i, k, p

    n = size(b)
    info = 0
    if (size(A,1) /= n .or. size(A,2) /= n .or. size(x) /= n) then
      info = -1; return
    end if
    allocate(M(n,n), rhs(n), tmp_row(n))
    M = A; rhs = b

    do k = 1, n-1
      p = k
      do i = k+1, n
        if (abs(M(i,k)) > abs(M(p,k))) p = i
      end do
      if (abs(M(p,k)) < 1.0e-12_dp) then
        info = k; return
      end if
      if (p /= k) then
        tmp_row = M(k,:); M(k,:) = M(p,:); M(p,:) = tmp_row
        pivot_tmp = rhs(k); rhs(k) = rhs(p); rhs(p) = pivot_tmp
      end if
      do i = k+1, n
        factor = M(i,k) / M(k,k)
        M(i,k:n) = M(i,k:n) - factor * M(k,k:n)
        rhs(i) = rhs(i) - factor * rhs(k)
      end do
    end do
    if (abs(M(n,n)) < 1.0e-12_dp) then
      info = n; return
    end if

    x(n) = rhs(n) / M(n,n)
    do i = n-1, 1, -1
      x(i) = (rhs(i) - sum(M(i,i+1:n) * x(i+1:n))) / M(i,i)
    end do
  end subroutine solve_linear

  pure real(dp) function vec_norm2(x) result(v)
    real(dp), intent(in) :: x(:)
    v = sqrt(sum(x*x))
  end function vec_norm2

  pure real(dp) function spectral_radius_power(A, iterations) result(rho)
    real(dp), intent(in) :: A(:,:)
    integer, intent(in), optional :: iterations
    integer :: it, k, n
    real(dp), allocatable :: x(:), y(:)
    real(dp) :: nrm
    n = size(A,1)
    it = 80; if (present(iterations)) it = iterations
    allocate(x(n), y(n)); x = 1.0_dp / sqrt(real(n,dp))
    rho = 0.0_dp
    do k = 1, it
      y = matmul(A,x)
      nrm = sqrt(sum(y*y))
      if (nrm < 1.0e-14_dp) exit
      x = y / nrm
      rho = dot_product(x, matmul(A,x))
    end do
    rho = abs(rho)
  end function spectral_radius_power
end module linalg
