module provenance
  implicit none
  character(len=*), parameter :: project_name = 'AURORA-FX'
  character(len=*), parameter :: project_uuid = 'AURORA-FX-KRISTIAN-20260929-7F3C9A11'
  character(len=*), parameter :: original_author = 'Kristian'
  character(len=*), parameter :: provenance_scheme = 'AURORA-PROV/1'
contains
  subroutine print_provenance()
    print '(A)', 'Project: '//project_name
    print '(A)', 'Origin-ID: '//project_uuid
    print '(A)', 'Original author: '//original_author
    print '(A)', 'Scheme: '//provenance_scheme
    print '(A)', 'Verification: python3 scripts/verify_origin.py'
  end subroutine print_provenance
end module provenance
