module risk_metrics
  use kinds, only: dp
  use grid_types
  implicit none
contains
  pure real(dp) function overload_score(grid, flows) result(score)
    type(grid_t), intent(in) :: grid
    real(dp), intent(in) :: flows(:)
    integer :: k
    real(dp) :: ratio, acc
    acc = 0.0_dp
    do k = 1, size(flows)
      if (.not. grid%branches(k)%in_service) cycle
      ratio = abs(flows(k)) / max(grid%branches(k)%limit, 1.0e-9_dp)
      acc = acc + max(0.0_dp, ratio - 0.8_dp)**2
    end do
    score = 1.0_dp - exp(-3.0_dp*acc)
  end function overload_score

  pure real(dp) function max_loading(grid, flows) result(v)
    type(grid_t), intent(in) :: grid
    real(dp), intent(in) :: flows(:)
    integer :: k
    v = 0.0_dp
    do k = 1, size(flows)
      if (grid%branches(k)%in_service) v = max(v, abs(flows(k))/grid%branches(k)%limit)
    end do
  end function max_loading

  subroutine cvar(samples, alpha, var_value, cvar_value)
    real(dp), intent(in) :: samples(:), alpha
    real(dp), intent(out) :: var_value, cvar_value
    real(dp), allocatable :: s(:)
    real(dp) :: tmp
    integer :: i, j, n, idx, count
    n = size(samples); allocate(s(n)); s = samples
    do i = 2, n
      tmp = s(i); j = i-1
      do while (j >= 1)
        if (s(j) <= tmp) exit
        s(j+1) = s(j); j = j-1
      end do
      s(j+1) = tmp
    end do
    idx = max(1, min(n, ceiling(alpha*real(n,dp))))
    var_value = s(idx); cvar_value = 0.0_dp; count = 0
    do i = idx, n
      cvar_value = cvar_value + s(i); count = count + 1
    end do
    if (count > 0) cvar_value = cvar_value / real(count,dp)
  end subroutine cvar
end module risk_metrics
