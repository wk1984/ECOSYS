
      SUBROUTINE readq(NA,ND,NT,NE,NAX,NDX,NTX,NEX,NF,NFX,NTZ
     2,NTZX,NHW,NHE,NVN,NVS)
C
C     THIS SUBROUTINE READS INPUT DATA FROM PLANT SPECIES
C     AND MANAGEMENT FILES IDENTIFIED IN 'ROUTQ'
C
      include "parameters.h"
      include "filec.h"
      include "files.h"
      include "blkc.h"
      include "blk9a.h"
      include "blk9b.h"
      include "blk9c.h"
      include "blk17.h"
      DIMENSION NA(10),ND(10)
      CHARACTER*16 DATA(30),DATAC(30,250,250),DATAP(JP,JY,JX)
     2,DATAM(JP,JY,JX),DATAX(JP),DATAY(JP),DATAZ(JP,JY,JX)
     3,OUTS(10),OUTP(10),OUTFILS(10,JY,JX),OUTFILP(10,JP,JY,JX)
      CHARACTER*3 CHOICE(102,20)
      CHARACTER*8 CDATE
      CHARACTER*80 PREFIX
      PARAMETER (TWILGT=0.06976)
      CHARACTER*60 fnm_loc
      integer :: iqfile
      iqfile=111
      if(idispq==1)then
      write(fnm_loc,'(A,I4,A)')'plant_trait.',IYRC,'.desc'
      open(unit=iqfile, file=fnm_loc, status='replace'
     2, action='write', iostat=ierr)
      endif
      DO 9995 NX=NHW,NHE
      DO 9990 NY=NVN,NVS
      DO 9985 NZ=1,NP(NY,NX)	
C
C     OPEN PFT(11), PFT MANAGEMENT(12) FILES FROM
C     FILE NAMES IN DATA ARRAYS LOADED IN MAIN.F
C
C     PREFIX=path for files in current or higher level directory
C     DATAP=PFT file name
C
      IF(DATAP(NZ,NY,NX).NE.'NO')THEN
C     WRITE(*,2233)'READQ',NX,NY,NZ,IETYP(NY,NX),DATAP(NZ,NY,NX) 
2233  FORMAT(A8,4I4,2A16)
      OPEN(11,FILE=TRIM(PREFIX)//DATAP(NZ,NY,NX),STATUS='OLD')
      ENDIF
      IF(DATAM(NZ,NY,NX).NE.'NO')THEN
      OPEN(12,FILE=TRIM(PREFIX)//DATAM(NZ,NY,NX),STATUS='OLD')
      ENDIF
C
C     READ INPUTS FOR EACH PLANT SPECIES
C
      IF(DATAP(NZ,NY,NX).NE.'NO')THEN
C
C     PLANT FUNCTIONAL TYPE
C
C     ICTYP=photosynthesis type:3=C3,4=C4
C     IGTYP=root profile:0=shallow (eg bryophytes),1=intermediate(eg herbs),2=deep (eg trees)
C     ISTYP=growth habit:0=annual,1=perennial
C     IDTYP=growth habit:0=determinate,1=indetermimate
C     INTYP=N2 fixation:1,2,3=rapid to slow root symbiosis (e.g.legumes),
C     4,5,6=rapid to slow canopy symbiosis (e.g. cyanobacteria)
C     IWTYP=phenology type:0=evergreen,1=cold deciduous,2=drought deciduous,3=1+2
C     IPTYP=photoperiod type:0=day neutral,1=short day,2=long day
C     IBTYP=turnover:if IGTYP=0 or 1:all above-ground:0,1=rapid(deciduous),2=very slow(evergreen),3=slow(semi-deciduous)
C                   :if IGTYP=2:trees:1=rapid(deciduous),2=very slow(coniferous),3=slow(semi-deciduous)
C     IRTYP=storage organ:0=above ground,1=below ground
C     MY=mycorrhizal:1=no,2=yes
C     ZTYPI=thermal adaptation zone:1=arctic,boreal,2=cool temperate,
C     3=warm temperate,4=subtropical,5=tropical
C
      READ(11,*)ICTYP(NZ,NY,NX),IGTYP(NZ,NY,NX),ISTYP(NZ,NY,NX)
     2,IDTYP(NZ,NY,NX),INTYP(NZ,NY,NX),IWTYP(NZ,NY,NX)
     3,IPTYP(NZ,NY,NX),IBTYP(NZ,NY,NX),IRTYP(NZ,NY,NX),MY(NZ,NY,NX)
     4,ZTYPI(NZ,NY,NX)
C
C     PHOTOSYNTHETIC PROPERTIES
C
C     VCMX,VOMX=specific rubisco carboxylase,oxygenase activity (umol C,O g-1 s-1)
C     VCMX4=specific PEP carboxylase activity (umol g-1 s-1)
C     XKCO2,XKO2,XKCO24=Km for VCMX,VOMX,VCMX4 (uM)
C     RUBP,PEPC=fraction of leaf protein in rubisco, PEP carboxylase
C     ETMX=specific chlorophyll activity (umol e- g-1 s-1)
C     CHL=fraction of leaf protein in mesophyll(C3), bundle sheath(C4) chlorophyll
C     CHL4=fraction of leaf protein in mesophyll chlorophyll(C4)
C     FCO2=intercellular:atmospheric CO2 concentration ratio 
C
      READ(11,*)VCMX(NZ,NY,NX),VOMX(NZ,NY,NX),VCMX4(NZ,NY,NX)
     2,XKCO2(NZ,NY,NX),XKO2(NZ,NY,NX),XKCO24(NZ,NY,NX)
     3,RUBP(NZ,NY,NX),PEPC(NZ,NY,NX),ETMX(NZ,NY,NX),CHL(NZ,NY,NX)
     4,CHL4(NZ,NY,NX),FCO2(NZ,NY,NX)
C
C     OPTICAL PROPERTIES
C
C     ALBP,ALBP,TAUR,TAUP=leaf SW,PAR albedo,transmission
C
      READ(11,*)ALBR(NZ,NY,NX),ALBP(NZ,NY,NX),TAUR(NZ,NY,NX)
     2,TAUP(NZ,NY,NX)
C
C     PHENOLOGICAL PROPERTIES
C
C     XRNI,XRLA=rate of node initiation,leaf appearance at 25oC (h-1)
C     CTC=chilling temperature for CO2 fixation, seed loss (oC)
C     VRNLI,VRNXI=hour requirement for spring leafout,autumn leafoff
C     WDLF=leaf length:width ratio
C     PB=nonstructural C concentration needed for branching
C     GROUPX,XTLI=node number required for floral initiation,at planting  
C     XDL=critical photoperiod (h):<0=maximum daylength from site file
C     XPPD=photoperiod sensitivity (node h-1)
C
      READ(11,*)XRNI(NZ,NY,NX),XRLA(NZ,NY,NX),CTC(NZ,NY,NX)
     2,VRNLI,VRNXI,WDLF(NZ,NY,NX),PB(NZ,NY,NX)
      READ(11,*)GROUPX(NZ,NY,NX),XTLI(NZ,NY,NX),XDL(NZ,NY,NX)
     2,XPPD(NZ,NY,NX)
C
C     MORPHOLOGICAL PROPERTIES
C
C     SLA1,SSL1,SNL1=growth in leaf area,petiole length,internode length vs mass
C     CLASS=fraction of leaf area in 0-22.5,45,67.5,90o inclination classes
C     CFI=initial clumping factor
C     ANGBR,ANGSH=stem,petiole angle from horizontal
C     STMX=maximum potential seed mumber from pre-anthesis stalk growth
C     SDMX=maximum seed number per STMX
C     GRMX=maximum seed size per SDMX (g)
C     GRDM=seed size at planting (g)
C     GFILL=grain filling rate at 25 oC (g seed-1 h-1)
C     WTSTDI=mass of dead standing biomass at planting 
C
      READ(11,*)SLA1(NZ,NY,NX),SSL1(NZ,NY,NX),SNL1(NZ,NY,NX)
      READ(11,*)(CLASS(N,NZ,NY,NX),N=1,4),CFI(NZ,NY,NX),ANGBR(NZ,NY,NX)
     2,ANGSH(NZ,NY,NX)
      READ(11,*)STMX(NZ,NY,NX),SDMX(NZ,NY,NX),GRMX(NZ,NY,NX)
     2,GRDM(NZ,NY,NX),GFILL(NZ,NY,NX),WTSTDI(NZ,NY,NX)
C
C     ROOT CHARACTERISTICS
C
C     RRAD1M,RRAD2M=radius of primary,secondary roots
C     PORT=root porosity
C     PR=nonstructural C concentration needed for root branching
C     RSRR,RSRA=radial,axial root resistivity (m2 MPa-1 h-1)
C     PTSHT=rate constant for equilibrating shoot-root nonstructural C concn
C     RTFQ=root branching frequency (m-1)
C
      READ(11,*)RRAD1M(1,NZ,NY,NX),RRAD2M(1,NZ,NY,NX),PORT(1,NZ,NY,NX)
     2,PR(NZ,NY,NX),RSRR(1,NZ,NY,NX),RSRA(1,NZ,NY,NX)
     3,PTSHT(NZ,NY,NX),RTFQ(NZ,NY,NX)
C
C     ROOT UPTAKE PARAMETERS
C
C     UPMXZH,UPKMZH,UPMNZH=NH4 max uptake (g m-2 h-1),Km (uM), min concn (uM)      
C     UPMXZO,UPKMZO,UPMNZO=NO3 max uptake (g m-2 h-1),Km (uM), min concn (uM)      
C     UPMXPO,UPKMPO,UPMNPO=H2PO4 max uptake (g m-2 h-1),Km (uM), min concn (uM)      
C
      READ(11,*)UPMXZH(1,NZ,NY,NX),UPKMZH(1,NZ,NY,NX),UPMNZH(1,NZ,NY,NX)
      READ(11,*)UPMXZO(1,NZ,NY,NX),UPKMZO(1,NZ,NY,NX),UPMNZO(1,NZ,NY,NX)
      READ(11,*)UPMXPO(1,NZ,NY,NX),UPKMPO(1,NZ,NY,NX),UPMNPO(1,NZ,NY,NX)
C
C     WATER RELATIONS
C
C     OSMO=leaf osmotic potential at zero leaf water potential (MPa)
C     RCS=shape parameter for stomatal resistance vs leaf turgor potential
C     RSMX=cuticular resistance (s m-1)
C
      READ(11,*)OSMO(NZ,NY,NX),RCS(NZ,NY,NX),RSMX(NZ,NY,NX)
C
C     ORGAN GROWTH YIELDS
C
C     DM*=DM-C production vs nonstructural C consumption (g g-1)
C     *LF=leaf,*SHE=petiole,*STK=stalk,*RSV=stalk reserve,*HSK=husk
C     *EAR=ear,*GR=grain,*RT=root,*ND=bacteria in root nodule,canopy
C
      READ(11,*)DMLF(NZ,NY,NX),DMSHE(NZ,NY,NX),DMSTK(NZ,NY,NX)
     2,DMRSV(NZ,NY,NX),DMHSK(NZ,NY,NX),DMEAR(NZ,NY,NX)
     3,DMGR(NZ,NY,NX),DMRT(NZ,NY,NX),DMND(NZ,NY,NX)
C
C     ORGAN N AND P CONCENTRATIONS
C
C     CN*,CP*=N:C,P:C ratios in plant organs
C
      READ(11,*)CNLF(NZ,NY,NX),CNSHE(NZ,NY,NX),CNSTK(NZ,NY,NX)
     2,CNRSV(NZ,NY,NX),CNHSK(NZ,NY,NX),CNEAR(NZ,NY,NX)
     3,CNGR(NZ,NY,NX),CNRT(NZ,NY,NX),CNND(NZ,NY,NX)
      READ(11,*)CPLF(NZ,NY,NX),CPSHE(NZ,NY,NX),CPSTK(NZ,NY,NX)
     2,CPRSV(NZ,NY,NX),CPHSK(NZ,NY,NX),CPEAR(NZ,NY,NX)
     3,CPGR(NZ,NY,NX),CPRT(NZ,NY,NX),CPND(NZ,NY,NX)

      if(idispq==1)then
      write(iqfile,*)('=',j=1,100)
      write(iqfile,*)'PLANT traits for FUNCTIONAL TYPE (NZ,NY,NX)='
     2,NZ,NY,NX,DATAP(NZ,NY,NX)(1:6)
      write(iqfile,*)'Plant name: ',DATAP(NZ,NY,NX)(1:6)
      write(iqfile,*)'koppen climate zone:',IETYP(NY,NX)
      select CASE (ICTYP(NZ,NY,NX))
      case (3)
      write(iqfile,*)'C3 photosynthesis'
      case (4)
      write(iqfile,*)'C4 photosynthesis'
      case default
      write(iqfile,*)'photosynthesis type not defined'
      end select

      select case(IGTYP(NZ,NY,NX))
      case (0)
      write(iqfile,*)'shallow root profile, like bryophytes'
      case (1)
      write(iqfile,*)'intermediate root profile, like herbs'
      case (2)
      write(iqfile,*)'deep root profile, like trees'
      case default
      write(iqfile,*)'root profile not defined'
      end select

      select case (ISTYP(NZ,NY,NX))
      case (0)
      write(iqfile,*)'Annual plant'
      case (1)
      write(iqfile,*)'perennial plant'
      case default
      write(iqfile,*)'growth habit not defined'
      end select

      select case (IDTYP(NZ,NY,NX))
      case (0)
      write(iqfile,*)'determinate growth pattern'
      case (1)
      write(iqfile,*)'indetermimate growth pattern'
      case default
      write(iqfile,*)'growth pattern not defined'
      end select

      select case (INTYP(NZ,NY,NX))
      ! 1,2, 3, e.g. legumes
      case (1)
      write(iqfile,*)'Rapid root N2 fixation symbiosis'
      case (2)
      write(iqfile,*)'Intermediate root N2 fixation symbiosis'
      case (3)
      write(iqfile,*)'Slow root N2 fixation symbiosis'
      !4,5,6, e.g. cyanobacteria
      case (4)
      write(iqfile,*)'Rapid canopy N2 fixation symbiosis'
      case (5)
      write(iqfile,*)'Intermediate canopy N2 fixation symbiosis'
      case (6)
      write(iqfile,*)'Slow canopy N2 fixation symbiosis'
      case default
      write(iqfile,*)'No N2 fixation symbiosis defined'
      end select

      select case(IWTYP(NZ,NY,NX))
      case (0)
      write(iqfile,*)'phenology type: evergreen'
      case (1)
      write(iqfile,*)'phenology type: cold deciduous'
      case (2)
      write(iqfile,*)'phenology type: drought deciduous'
      case (3)
      write(iqfile,*)'phenology type: cold+drought deciduous'
      case default
      write(iqfile,*)'phenology type not defined'
      end select

      select case(IPTYP(NZ,NY,NX))
      case (0)
      write(iqfile,*)'day neutral photoperiod'
      case (1)
      write(iqfile,*)'short day photoperiod'
      case (2)
      write(iqfile,*)'long day photoperiod'
      case default
      write(iqfile,*)'photoperiod not defined'
      end select

      if(IGTYP(NZ,NY,NX).GT.1)then
      select case(IBTYP(NZ,NY,NX))
      case (0, 1)
      write(iqfile,*)'Rapid tree biome turnover (deciduous)'
      case (2)
      write(iqfile,*)'Very slow tree biome '
     2//'turnover (needleleaf evergreen)'
      case (3)
      write(iqfile,*)'Slow tree biome turnover '
     2//'(Broadleaf evergreen)'
      case (4)
      write(iqfile,*)'Tree biome turnover semi-deciduous'
      case (5)
      write(iqfile,*)'Tree biome turnover semi-evergreen'
      case default
      write(iqfile,*)'Tree biome turnover not defined'
      end select
      else
      select case(IBTYP(NZ,NY,NX))
      case (0, 1)
      write(iqfile,*)'Rapid all aboveground plant'
     2//' biome turnover (herbaceous)'
      case default
      write(iqfile,*)'Plant biome turnover not defined'
      end select
      endif

      select case(IRTYP(NZ,NY,NX))
      case (0)
      write(iqfile,*)'Above ground storage organ'
      case (1)
      write(iqfile,*)'Belowground storage organ'
      case default
      write(iqfile,*)'Storage organ not defined'
      end select

      select case(MY(NZ,NY,NX))
      case (1)
      write(iqfile,*)'No mycorrhizal'
      case (2)
      write(iqfile,*)'Mycorrhizal'
      case default
      write(iqfile,*)'Wrong option for mycorrhizae'
      end select

      select case(INT(ZTYPI(NZ,NY,NX)+0.5005))
      case (1)
      write(iqfile,*)'thermal adaptation zone: arctic, boreal'
      case (2)
      write(iqfile,*)'thermal adaptation zone: cool temperate'
      case (3)
      write(iqfile,*)'thermal adaptation zone: warm temperate'
      case (4)
      write(iqfile,*)'thermal adaptation zone: subtropical'
      case (5)
      write(iqfile,*)'thermal adaptation zone: tropical'
      case default
      write(iqfile,*)'Not thermal adaptation zone defined'
      end select

      write(iqfile,*)('-',j=1,100)
      write(iqfile,*)'PHOTOSYNTHETIC PROPERTIES'
      call wrfixl(iqfile,'Specific rubisco carboxylase '
     2//'(umol C g-1 s-1) VCMX',VCMX(NZ,NY,NX),90)
      call wrfixl(iqfile,'Specific rubisco oxygenase'
     2//' (umol O2 g-1 s-1) VOMX',VOMX(NZ,NY,NX),90)
      call wrfixl(iqfile,'Specific PEP carboxylase'
     2//' activity (umol g-1 s-1) VCMX4',VCMX4(NZ,NY,NX)
     3,90)
      call wrfixl(iqfile,'Km for VmaxRubCarboxyRef_pft(uM) '
     2//'XKCO2',XKCO2(NZ,NY,NX),90)
      call wrfixl(iqfile,'Km for VmaxRubOxyRef_pft (uM) XKO2'
     2,XKO2(NZ,NY,NX),90)
      call wrfixl(iqfile,'KM for VmaxPEPCarboxyRef_pft (uM) '
     2//'XKCO24',XKCO24(NZ,NY,NX),90)
      call wrfixl(iqfile,'Fraction of leaf protein in rubisco'
     2//' (g rub/(g protein)) RUBP',RUBP(NZ,NY,NX),90)
      call wrfixl(iqfile,'Fraction of leaf protein in PEP '
     2//'carboxylase (g pep/(g protein)) PEPC'
     3,PEPC(NZ,NY,NX),90)
      call wrfixl(iqfile,'Specific chlorophyll activity'
     2//' (umol e- gC-1 s-1) ETMX',ETMX(NZ,NY,NX),90)
      if(ICTYP(NZ,NY,NX).eq.3)then
      call wrfixl(iqfile,'Fraction of leaf protein as '
     2//'chlorophyll in mesophyll (C3) '
     3//'(g Chl /(g protein)) CHL',CHL(NZ,NY,NX),90)
      elseif(ICTYP(NZ,NY,NX).eq.4)then
      call wrfixl(iqfile,'Fraction of leaf protein as'
     2//' chlorophyll in bundle sheath(C4) '
     3//'(g Chl /(g protein)) CHL',CHL(NZ,NY,NX),90)
      call wrfixl(iqfile,'fraction of leaf protein in '
     2//'mesophyll chlorophyll(C4)'
     3//' (g Chl /(g protein)) CHL4',CHL4(NZ,NY,NX),90)
      endif
      call wrfixl(iqfile,'intercellular:atmospheric '
     2//'CO2 concentration ratio FCO2',FCO2(NZ,NY,NX),90)

      write(iqfile,*)('-',j=1,100)
      write(iqfile,*)'OPTICAL PROPERTIES'
      call wrfixl(iqfile,'leaf SW albedo ALBR',ALBR(NZ,NY,NX),50)
      call wrfixl(iqfile,'leaf PAR albedo ALBP',ALBP(NZ,NY,NX),50)
      call wrfixl(iqfile,'leaf SW transmission TAUR',TAUR(NZ,NY,NX),50)
      call wrfixl(iqfile,'leaf PAR transmission TAUP',TAUP(NZ,NY,NX),50)

      write(iqfile,*)('-',j=1,100)
      write(iqfile,*)'PHENOLOGICAL PROPERTIES'
      call wrfixl(iqfile,'rate of node initiation at '
     2//'25oC (h-1) XRNI',XRNI(NZ,NY,NX),70)
      call wrfixl(iqfile,'rate of leaf appearance at '
     2//'25oC (h-1) XRLA',XRLA(NZ,NY,NX),70)
      call wrfixl(iqfile,'chilling temperature for CO2 fixation, '
     2//'seed loss (oC) CTC',CTC(NZ,NY,NX),70)
      call wrfixl(iqfile,'hour requirement for spring '
     2//'leafout VRNLI',VRNLI,70)
      call wrfixl(iqfile,'hour requirement for autumn'
     2//' leafoff VRNXI',VRNXI,70)
      call wrfixl(iqfile,'leaf length:width ratio '
     2//'WDLF',WDLF(NZ,NY,NX),70)
      call wrfixl(iqfile,'nonstructural C concentration needed '
     2//'for branching PB',PB(NZ,NY,NX),70)
      call wrfixl(iqfile,'Maturity group, node number required '
     2//'for floral initiation, GROUPX',GROUPX(NZ,NY,NX),70)
      call wrfixl(iqfile,'Node number at planting XTLI'
     2,XTLI(NZ,NY,NX),70)
      call wrfixl(iqfile,'critical photoperiod (h) '
     2//'<= maximum daylength XDL',XDL(NZ,NY,NX),70)
      call wrfixl(iqfile,'photoperiod sensitivity (node h-1) XPPD'
     2,XPPD(NZ,NY,NX),70)

      write(iqfile,*)('-',j=1,100)  
      write(iqfile,*)'MORPHOLOGICAL PROPERTIES'
      call wrfixl(iqfile,'growth in leaf area vs mass '
     2//'(m2 g-1) SLA1',SLA1(NZ,NY,NX),70)
      call wrfixl(iqfile,'growth in petiole length vs'
     2//' mass (m g-1) SSL1',SSL1(NZ,NY,NX),70)
      call wrfixl(iqfile,'growth in internode length '
     2//'vs mass (m g-1) SNL1',SNL1(NZ,NY,NX),70)
      call wafixl(iqfile,'fraction of leaf area in '
     2//'0-22.5,45,67.5,90o inclination classes CLASS'
     3,CLASS(1:4,NZ,NY,NX),70)
      call wrfixl(iqfile,'initial clumping factor CFI'
     2,CFI(NZ,NY,NX),70)
      call wrfixl(iqfile,'stem angle from horizontal'
     2//' ANGBR',ANGBR(NZ,NY,NX),70)
      call wrfixl(iqfile,'petiole angle from horizontal'
     2//' ANGSH',ANGSH(NZ,NY,NX),70)
      call wrfixl(iqfile,'maximum potential seed mumber from '
     2//'pre-anthesis stalk growth STMX',STMX(NZ,NY,NX),70)
      call wrfixl(iqfile,'maximum seed number per '
     2//'STMX (none) SDMX',SDMX(NZ,NY,NX),70)
      call wrfixl(iqfile,'maximum seed size per '
     2//'SDMX (g) GRMX',GRMX(NZ,NY,NX),70)
      call wrfixl(iqfile,'seed size at planting (gC)'
     2//' GRDM',GRDM(NZ,NY,NX),70)
      call wrfixl(iqfile,'grain filling rate at 25 oC'
     2//' (g seed-1 h-1) GFILL',GFILL(NZ,NY,NX),70)
      call wrfixl(iqfile,'mass of dead standing biomass'
     2//' at planting (gC m-2) WTSTDI',WTSTDI(NZ,NY,NX),70)

      write(iqfile,*)('-',j=1,100)
      write(iqfile,*)'ROOT CHARACTERISTICS'
      call wrfixl(iqfile,'radius of primary roots (m) '
     2//'RRAD1M',RRAD1M(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'radius of secondary roots (m)'
     2//' RRAD2M',RRAD2M(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'primary/fine root porosity '
     2//'(m3 m-3) PORT',PORT(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'nonstructural C concentration '
     2//'needed for root branching (gC/gC) PR'
     3,PR(NZ,NY,NX),70)
      call wrfixl(iqfile,'radial root resistivity for '
     2//'water uptake (m2 MPa-1 h-1) RSRR'
     3,RSRR(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'axial root resistivity for '
     2//'water uptake (m2 MPa-1 h-1) RSRA'
     3,RSRA(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'rate constant for equilibrating'
     2//' shoot-root nonstructural C concn PTSHT'
     3,PTSHT(NZ,NY,NX),70)
      call wrfixl(iqfile,'root branching frequency (m-1)'
     2//' RTFQ',RTFQ(NZ,NY,NX),70)

      write(iqfile,*)('-',j=1,100)
      write(iqfile,*)'ROOT UPTAKE PARAMETERS'
      call wrfixl(iqfile,'NH4 max uptake (g m-2 h-1) UPMXZH'
     2,UPMXZH(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'NH4 uptake Km (uM) UPKMZH'
     2,UPKMZH(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'NH4 uptake min concn (uM) UPMNZH'
     2,UPMNZH(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'NO3 max uptake (g m-2 h-1) UPMXZO'
     2,UPMXZO(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'NO3 uptake Km (uM) UPKMZO'
     2,UPKMZO(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'NO3 uptake min concn (uM) UPMNZO'
     2,UPMNZO(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'H2PO4 or H1PO4 max uptake '
     2//'(g m-2 h-1) UPMXPO',UPMXPO(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'H2PO4 or H1PO4 uptake Km (uM) '
     2//'UPKMPO',UPKMPO(1,NZ,NY,NX),70)
      call wrfixl(iqfile,'H2PO4 or H1PO4 uptake min'
     2//' conc (uM) UPMNPO',UPMNPO(1,NZ,NY,NX),70)

      write(iqfile,*)('-',j=1,100)  
      write(iqfile,*)'WATER RELATIONS'
      call wrfixl(iqfile,'leaf osmotic potential at '
     2//'zero leaf water potential (MPa) OSMO'
     3,OSMO(NZ,NY,NX),70)
      call wrfixl(iqfile,'shape parameter for '
     2//'stomatal resistance vs leaf turgor potential RCS'
     3,RCS(NZ,NY,NX),70)
      call wrfixl(iqfile,'cuticular resistance (s m-1)'
     2//' RSMX',RSMX(NZ,NY,NX),70)

      write(iqfile,*)('-',j=1,100)
      write(iqfile,*)'ORGAN GROWTH YIELDS'
      call wrfixl(iqfile,'leaf dry matter C production vs '
     2//'nonstructural C consumption (g g-1) DMLF'
     3,DMLF(NZ,NY,NX),101)
      call wrfixl(iqfile,'petiole dry matter C production vs '
     2//'nonstructural C consumption (g g-1) DMSHE'
     3,DMSHE(NZ,NY,NX),101)
      call wrfixl(iqfile,'stalk dry matter C production vs '
     2//'nonstructural C consumption (g g-1) DMSTK'
     3,DMSTK(NZ,NY,NX),101)
      call wrfixl(iqfile,'stalk reserve C production vs '
     2//'nonstructural C consumption (g g-1) DMRSV'
     3,DMRSV(NZ,NY,NX),101)
      call wrfixl(iqfile,'husk dry matter C production vs '
     2//'nonstructural Cconsumption (g g-1) DMHSK'
     3,DMHSK(NZ,NY,NX),101)
      call wrfixl(iqfile,'ear dry matter C production vs '
     2//'nonstructural Cconsumption (g g-1) DMEAR'
     3,DMEAR(NZ,NY,NX),101)
      call wrfixl(iqfile,'grain C production vs nonstructural '
     2//'C consumption (g g-1) DMGR',DMGR(NZ,NY,NX),101)
      call wrfixl(iqfile,'root dry matter C production vs '
     2//'nonstructural C consumption (g g-1) DMRT'
     3,DMRT(NZ,NY,NX),101)
      call wrfixl(iqfile,'nodule bacteria in root,'
     2//' canopy dry matter C production vs nonstructural'
     3//' C consumption (g g-1) DMND'
     4,DMND(NZ,NY,NX),101)

      write(iqfile,*)('-',j=1,100)
      write(iqfile,*)'ORGAN N AND P CONCENTRATIONS'
      call wrfixl(iqfile,'NC ratio in plant leaves (gN/gC) '
     2//'CNLF:',CNLF(NZ,NY,NX),70)
      call wrfixl(iqfile,'NC ratio in plant petiole (gN/gC) '
     2//'CNSHE',CNSHE(NZ,NY,NX),70)
      call wrfixl(iqfile,'NC ratio in plant stalk (gN/gC) '
     2//'CNSTK',CNSTK(NZ,NY,NX),70)
      call wrfixl(iqfile,'NC ratio in plant stalk reserve '
     2//'(gN/gC) CNRSV',CNRSV(NZ,NY,NX),70)
      call wrfixl(iqfile,'NC ratio in plant husk (gN/gC) '
     2//'CNHSK',CNHSK(NZ,NY,NX),70)
      call wrfixl(iqfile,'NC ratio in plant ear (gN/gC) '
     2//'CNEAR',CNEAR(NZ,NY,NX),70)
      call wrfixl(iqfile,'NC ratio in plant grain (gN/gC)'
     2//' CNGR',CNGR(NZ,NY,NX),70)
      call wrfixl(iqfile,'NC ratio in plant root (gN/gC) '
     2//'CNRT',CNRT(NZ,NY,NX),70)
      call wrfixl(iqfile,'NC ratio in plant nodule (gN/gC)'
     2//' CNND',CNND(NZ,NY,NX),70)
      call wrfixl(iqfile,'PC ratio in plant leaves (gP/gC)'
     2//' CPLF',CPLF(NZ,NY,NX),70)
      call wrfixl(iqfile,'PC ratio in plant petiole (gP/gC)'
     2//' CPSHE',CPSHE(NZ,NY,NX),70)
      call wrfixl(iqfile,'PC ratio in plant stalk (gP/gC)'
     2//' CPSTK',CPSTK(NZ,NY,NX),70)
      call wrfixl(iqfile,'PC ratio in plant stalk reserve'
     2//' (gP/gC) CPRSV',CPRSV(NZ,NY,NX),70)
      call wrfixl(iqfile,'PC ratio in plant husk (gP/gC)'
     2//' CPHSK',CPHSK(NZ,NY,NX),70)
      call wrfixl(iqfile,'PC ratio in plant ear (gP/gC) '
     2//'CPEAR',CPEAR(NZ,NY,NX),70)
      call wrfixl(iqfile,'PC ratio in plant grain (gP/gC) '
     2//'CPGR',CPGR(NZ,NY,NX),70)
      call wrfixl(iqfile,'PC ratio in plant root (gP/gC) '
     2//'CPRT',CPRT(NZ,NY,NX),70)
      call wrfixl(iqfile,'PC ratio in plant nodule (gP/gC) '
     2//'CPND',CPND(NZ,NY,NX),70)

      endif
C
C     RE-CALCULATE PLANT INPUTS IN MODEL UNITS
C
C     ABSR,ABSP=leaf SW,PAR absorbtivity
C
      VCMX(NZ,NY,NX)=2.5*VCMX(NZ,NY,NX)
      VOMX(NZ,NY,NX)=2.5*VOMX(NZ,NY,NX)
      VCMX4(NZ,NY,NX)=2.5*VCMX4(NZ,NY,NX)
      ETMX(NZ,NY,NX)=2.5*ETMX(NZ,NY,NX)
      ABSR(NZ,NY,NX)=1.0-ALBR(NZ,NY,NX)-TAUR(NZ,NY,NX)
      ABSP(NZ,NY,NX)=1.0-ALBP(NZ,NY,NX)-TAUP(NZ,NY,NX)
      ALBR(NZ,NY,NX)=ALBR(NZ,NY,NX)/ABSR(NZ,NY,NX)
      ALBP(NZ,NY,NX)=ALBP(NZ,NY,NX)/ABSP(NZ,NY,NX)
      TAUR(NZ,NY,NX)=TAUR(NZ,NY,NX)/ABSR(NZ,NY,NX)
      TAUP(NZ,NY,NX)=TAUP(NZ,NY,NX)/ABSP(NZ,NY,NX)
      ANGBR(NZ,NY,NX)=SIN(ANGBR(NZ,NY,NX)/57.29578)
      ANGSH(NZ,NY,NX)=SIN(ANGSH(NZ,NY,NX)/57.29578)
      GROUPI(NZ,NY,NX)=GROUPX(NZ,NY,NX)
      IF(IBTYP(NZ,NY,NX).NE.0)THEN
      XRNI(NZ,NY,NX)=XRNI(NZ,NY,NX)/25.0
      XRLA(NZ,NY,NX)=XRLA(NZ,NY,NX)/25.0
      GROUPI(NZ,NY,NX)=GROUPI(NZ,NY,NX)/25.0
      XTLI(NZ,NY,NX)=XTLI(NZ,NY,NX)/25.0
      ENDIF
      GROUPI(NZ,NY,NX)=GROUPI(NZ,NY,NX)-XTLI(NZ,NY,NX)
      IF(XDL(NZ,NY,NX).LT.0.0)THEN
      XDL(NZ,NY,NX)=DYLM(NY,NX)
      ENDIF
      DO 5 NB=1,10
      IF(IWTYP(NZ,NY,NX).EQ.0.AND.ISTYP(NZ,NY,NX).NE.0)THEN
      VRNL(NB,NZ,NY,NX)=AMIN1(4380.0,VRNLI+144.0*ZTYPI(NZ,NY,NX)*(NB-1))
      VRNX(NB,NZ,NY,NX)=AMIN1(4380.0,VRNXI+144.0*ZTYPI(NZ,NY,NX)*(NB-1))
      ELSE
      VRNL(NB,NZ,NY,NX)=VRNLI
      VRNX(NB,NZ,NY,NX)=VRNXI
      ENDIF
5     CONTINUE         
      CLOSE(11)
      ENDIF
C     WRITE(*,1111)'CRITICAL DAYLENGTH',IGO,NZ,XDL(NZ,NY,NX)
1111  FORMAT(A20,2I8,E12.4)
C
C     READ INPUTS FOR PLANT MANAGEMENT
C
      DO 15 M=1,366
      IHVST(NZ,M,NY,NX)=-1
      JHVST(NZ,M,NY,NX)=0
      HVST(NZ,M,NY,NX)=1.0E+06
      THIN(NZ,M,NY,NX)=-1.0
      EHVST(1,1,NZ,M,NY,NX)=1.0
      EHVST(1,2,NZ,M,NY,NX)=1.0
      EHVST(1,3,NZ,M,NY,NX)=1.0
      EHVST(1,4,NZ,M,NY,NX)=1.0
      EHVST(2,1,NZ,M,NY,NX)=1.0
      EHVST(2,2,NZ,M,NY,NX)=1.0
      EHVST(2,3,NZ,M,NY,NX)=1.0
      EHVST(2,4,NZ,M,NY,NX)=1.0
15    CONTINUE
      IF(DATAM(NZ,NY,NX).NE.'NO')THEN
      N=0
      NN=0
      IDAY0(NZ,NY,NX)=-1E+06
      IYR0(NZ,NY,NX)=-1E+06
      IDAYH(NZ,NY,NX)=1E+06
      IYRH(NZ,NY,NX)=1E+06
10    IF(N.EQ.0)THEN
C
C     PLANTING
C
C     DY=planting date DDMMYYYY
C     PPI=initial planting density (m-2)
C     SDPTHI=seeding depth (m)
C
      READ(12,*,END=540)DY,PPI(NZ,NY,NX),SDPTHI(NZ,NY,NX)
      SDPTHI(NZ,NY,NX)=AMAX1(1.0E-06,SDPTHI(NZ,NY,NX))
      ELSE
C
C     HARVESTING
C
C     DY=if harvesting: harvesting date DDMMYYYY
C       =if grazing: first grazing date DDMMYYYY, followed by last grazing date in next line
C     ICUT=harvest type:0=none,1=grain,2=all above-ground,3=pruning
C     4=grazing,5=fire,6=insect
C     JCUT=terminate PFT:0=no,1=yes,2=yes,but reseed
C     HCUT=if harvesting: >0=cutting height,<0=fraction of LAI removed
C         =if grazing: grazer biomass (g FW m-2)
C     PCUT=if harvesting: thinning,fraction of population removed
C         =if grazing: grazer consumption rate (g DW g FW-1 d-1)
C     ECUT11,ECUT12,ECUT13,ECUT14=fraction of leaf,non-foliar,woody,standing dead 
C     removed from PFT
C     ECUT21,ECUT22,ECUT23,ECUT124=fraction of leaf,non-foliar,woody,standing dead 
C     removed from ecosystem
C
      READ(12,*,END=540)DY,ICUT,JCUT,HCUT,PCUT
     2,ECUT11,ECUT12,ECUT13,ECUT14,ECUT21,ECUT22,ECUT23,ECUT24
      ENDIF
C
C     DERIVE PLANTING,HARVESTING DATES,YEARS
C
C     IDAY0,IYR0,IDAYH,IYRH=day,year of planting,harvesting
C
      IDX=INT(DY/1.0E+06)
      IMO=INT(DY/1.0E+04-IDX*1.0E+02)
      IYR=INT(DY-(IDX*1.0E+06+IMO*1.0E+04))
      LPY=0
      IF(MOD(IYR,4))520,510,520
510   IF(IMO.GT.2)LPY=1
520   IF(IMO.EQ.1)GO TO 525
      IDY=30*(IMO-1)+ICOR(IMO-1)+IDX+LPY
      GO TO 527
525   IDY=IDX
527   IF(N.EQ.0)THEN
      IF(IDY.GT.0.AND.IYR.GT.0)THEN
C     IDY=IDY-0.5*(NTX-1)
      IDAY0(NZ,NY,NX)=IDY
C     IF(ISTYP(NZ,NY,NX).EQ.0)THEN
      IYR=IYR+(NT-1)*NF+(NTX-1)*NFX-NTZX 
C     ENDIF
      IYR0(NZ,NY,NX)=MIN(IYR,IYRC)
      IDAYX(NZ,NY,NX)=IDAY0(NZ,NY,NX)
      IYRX(NZ,NY,NX)=IYR0(NZ,NY,NX)
      PPZ(NZ,NY,NX)=PPI(NZ,NY,NX)
      ENDIF
      ELSE
      IF(IDY.GT.0.AND.JCUT.EQ.1)THEN
C     IDY=IDY+0.5*(NTX-1)
      IDAYH(NZ,NY,NX)=IDY
      IYR=IYR+(NT-1)*NF+(NTX-1)*NFX-NTZX 
      IYRH(NZ,NY,NX)=MIN(IYR,IYRC)
      ENDIF
C
C     LOAD MODEL ARRAYS WITH PFT MANAGEMENT FOR SPECIFIED DATES
C
C     IHVST=harvest type:0=none,1=grain,2=all above-ground,3=pruning,4=grazing,5=fire,6=herbivory
C     JHVST=terminate PFT:0=no,1=yes,2=yes,and reseed
C     HVST=IHVST=0-2:>0=cutting height,<0=fraction of LAI removed
C          IHVST=3:reduction of clumping factor
C          IHVST=4 or 6:animal or insect biomass(g LM m2),IHVST=5:fire
C     THIN=IHVST=0-3,5: fraction of population removed, 
C          IHVST=4 or 6:specific herbivory rate (g DM g-1 LM d-1)
C     EHVST(1,1,EHVST(1,2,EHVST(1,3,EHVST(1,4=fraction of 
C           leaf,non-foliar,woody, standing dead removed from PFT
C     EHVST(2,1,EHVST(2,2,EHVST(2,3,EHVST(2,4=fraction of 
C           leaf,non-foliar,woody, standing dead removed from ecosystem
C
      IHVST(NZ,IDY,NY,NX)=ICUT
      JHVST(NZ,IDY,NY,NX)=JCUT
      HVST(NZ,IDY,NY,NX)=HCUT
      THIN(NZ,IDY,NY,NX)=PCUT
      EHVST(1,1,NZ,IDY,NY,NX)=ECUT11
      EHVST(1,2,NZ,IDY,NY,NX)=ECUT12
      EHVST(1,3,NZ,IDY,NY,NX)=ECUT13
      EHVST(1,4,NZ,IDY,NY,NX)=ECUT14
      EHVST(2,1,NZ,IDY,NY,NX)=ECUT21
      EHVST(2,2,NZ,IDY,NY,NX)=ECUT22
      EHVST(2,3,NZ,IDY,NY,NX)=ECUT23
      EHVST(2,4,NZ,IDY,NY,NX)=ECUT24
C
C     IF ANIMAL OR INSECT GRAZING LOAD ALL DATES BETWEEN FIRST AND LAST
C
      IF(IHVST(NZ,IDY,NY,NX).EQ.4.OR.IHVST(NZ,IDY,NY,NX).EQ.6)THEN
      NN=NN+1
      IF(MOD(NN,2))570,560,570
560   IDYE=IDY
      DO 580 IDYG=IDYS+1,IDYE-1
      IHVST(NZ,IDYG,NY,NX)=ICUT
      JHVST(NZ,IDYG,NY,NX)=JCUT
      HVST(NZ,IDYG,NY,NX)=HCUT
      THIN(NZ,IDYG,NY,NX)=PCUT
      EHVST(1,1,NZ,IDYG,NY,NX)=ECUT11
      EHVST(1,2,NZ,IDYG,NY,NX)=ECUT12
      EHVST(1,3,NZ,IDYG,NY,NX)=ECUT13
      EHVST(1,4,NZ,IDYG,NY,NX)=ECUT14
      EHVST(2,1,NZ,IDYG,NY,NX)=ECUT21
      EHVST(2,2,NZ,IDYG,NY,NX)=ECUT22
      EHVST(2,3,NZ,IDYG,NY,NX)=ECUT23
      EHVST(2,4,NZ,IDYG,NY,NX)=ECUT24      
580   CONTINUE
570   IDYS=IDY
      ENDIF
      ENDIF
      N=N+1
      GO TO 10
540   CLOSE(12)
      ELSE
      SDPTHI(NZ,NY,NX)=1.0E-06
      ENDIF
      IDAYY(NZ,NY,NX)=IDAYH(NZ,NY,NX)
      IYRY(NZ,NY,NX)=IYRH(NZ,NY,NX)
      IFLGC(NZ,NY,NX)=0
      IDTH(NZ,NY,NX)=0
9985  CONTINUE
9990  CONTINUE
9995  CONTINUE
      if(idispq==1)then
      close(iqfile)
      endif
      RETURN
      contains

      subroutine wrfixl(nu_plt,desc,value,width)
      implicit none
      integer,intent(in)  :: nu_plt
      character(len=*), intent(in) :: desc
      integer, intent(in) :: width
      real,intent(in) :: value

      character(len=width) :: line
      line=desc
      line(width:width)=':'
      write(nu_plt,*)line,value
      end subroutine wrfixl

      subroutine wafixl(nu_plt,desc,values,width)
      implicit none
      integer,intent(in)  :: nu_plt
      character(len=*), intent(in) :: desc
      integer, intent(in) :: width
      real,dimension(:),intent(in) :: values

      character(len=width) :: line
      line=desc
      line(width:width)=':'
      write(nu_plt,*)line,values
      end subroutine wafixl

      END
