
      subroutine WRDIAG(I,J,NHW,NHE,NVN,NVS)

      include "parameters.h"
      include "blk11a.h"
      include "blk8a.h"
      include "blkc.h"
      include "blk1g.h"
      include "blk1u.h"
      integer,parameter :: iunhd=311
      INTEGER,PARAMETER :: iuqdr=312
      INTEGER,PARAMETER :: iupho=313
      
      logical :: isopen
      CHARACTER(len=40) :: fname

      if(I==1.and.J==1)then
      iut=iunhd
      inquire(unit=iut, opened=isopen)
      if(isopen)then
      close(iut)            
      endif
      iut=iuqdr
      inquire(unit=iut, opened=isopen)
      if(isopen)then
      close(iut)      
      endif
      iut=iupho
      inquire(unit=iut, opened=isopen)
      if(isopen)then
      close(iut)      
      endif

      if(.false.)then
      write(fname,'(A,I4,A)')'hcnd_vr.',IYRC,'.txt'
      open(iunhd,file=fname,status='unknown')
      endif
      if(.false.)then
      write(fname,'(A,I4,A)')'QDRAI.',IYRC,'.txt'
      open(iuqdr,file=fname,status='unknown')
      endif

      if(.true.)then      
      write(fname,'(A,I4,A)')'photo.',IYRC,'.txt'
      write(*,*)'open file', fname
      open(iupho,file=fname,status='unknown')
      endif
      endif
      DO 9695 NX=NHW,NHE
      DO 9690 NY=NVN,NVS
      if(.false.)then
      write(iunhd,*)(HCND3(3,L,NY,NX),L=NU(NY,NX)
     2,NL(NY,NX))
      write(iuqdr,*)(QDRAIZ(L,NY,NX),L=NU(NY,NX)
     2,NL(NY,NX))      
      endif

      write(iupho,*)I*100+J,(CO2Q(NZ,NY,NX),CO2I(NZ,NY,NX)
     2,XKCO2O(NZ,NY,NX),O2L(NZ,NY,NX),TKCZ(NZ,NY,NX)-273.15
     3,NZ=1,NP(NY,NX))

9690  CONTINUE
9695  CONTINUE


      end subroutine WRDIAG
