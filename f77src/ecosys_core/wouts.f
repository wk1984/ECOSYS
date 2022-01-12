      SUBROUTINE wouts(I,NHW,NHE,NVN,NVS)
C
C     THIS SUBROUTINE WRITES OUT ALL SOIL VARIABLES TO
C     CHECKPOINT FILES AT THE FREQUENCY GIVEN IN THE OPTIONS
C     FILE SO THAT OUTPUTS FROM EARLIER MODEL RUNS CAN BE USED
C     TO INITIALIZE LATER MODEL RUNS
C
      include "parameters.h"
      include "filec.h"
      include "files.h"
      include "blkc.h"
      include "blk2a.h"
      include "blk2b.h"
      include "blk2c.h"
      include "blk5.h"
      include "blk8a.h"
      include "blk8b.h"
      include "blk11a.h"
      include "blk11b.h"
      include "blk13a.h"
      include "blk13b.h"
      include "blk13c.h"
      include "blk16.h"
      include "blk18a.h"
      include "blk18b.h"
      include "blk19a.h"
      include "blk19b.h"
      include "blk19c.h"
      include "blk19d.h"
      CHARACTER*16 DATA(30),DATAC(30,250,250),DATAP(JP,JY,JX)
     2,DATAM(JP,JY,JX),DATAX(JP),DATAY(JP),DATAZ(JP,JY,JX)
     3,OUTS(10),OUTP(10),OUTFILS(10,JY,JX),OUTFILP(10,JP,JY,JX)
      CHARACTER*3 CHOICE(102,20)
      CHARACTER*8 CDATE
      WRITE(21,90)I,IDATA(3),CRAIN,TSEDOU
     2,HEATIN,OXYGIN,TORGF,TORGN,TORGP,CO2GIN,ZN2GIN,VOLWOU,CEVAP
     3,CRUN,HEATOU,OXYGOU,TCOU,TZOU,TPOU,TZIN,TPIN,XCSN,XZSN,XPSN 
      DO 9995 NX=NHW,NHE
      DO 9990 NY=NVN,NVS
      WRITE(21,95)I,IDATA(3),(TDTPX(NY,NX,N),N=1,12)
     2,(TDTPN(NY,NX,N),N=1,12),(TDRAD(NY,NX,N),N=1,12)
     3,(TDWND(NY,NX,N),N=1,12),(TDHUM(NY,NX,N),N=1,12)
     4,(TDPRC(NY,NX,N),N=1,12),(TDIRI(NY,NX,N),N=1,12)
     5,(TDCO2(NY,NX,N),N=1,12),(TDCN4(NY,NX,N),N=1,12)
     6,(TDCNO(NY,NX,N),N=1,12)
      WRITE(21,93)I,IDATA(3),IFLGT(NY,NX),IFNHB(NY,NX),IDTBL(NY,NX)
     2,IFNOB(NY,NX),IFPOB(NY,NX),IUTYP(NY,NX)
     3,ZT(NY,NX),TFLWC(NY,NX),TSED(NY,NX) 
     3,ZS(NY,NX),THRMC(NY,NX),THRMG(NY,NX),TCNET(NY,NX),TVOLWC(NY,NX) 
     4,VOLWG(NY,NX),URAIN(NY,NX),ARLFC(NY,NX),ARSTC(NY,NX),PPT(NY,NX)
     5,VOLWD(NY,NX),ZM(NY,NX),UCO2G(NY,NX),UCH4G(NY,NX),UOXYG(NY,NX)
     6,UN2GG(NY,NX),UN2OG(NY,NX),UNH3G(NY,NX),UN2GS(NY,NX)
     7,UCO2F(NY,NX),UCH4F(NY,NX),UOXYF(NY,NX),UN2OF(NY,NX)
     8,UNH3F(NY,NX),UPO4F(NY,NX),UORGF(NY,NX),UFERTN(NY,NX)
     9,UFERTP(NY,NX),UVOLO(NY,NX),UEVAP(NY,NX),URUN(NY,NX)
     1,UDOCQ(NY,NX),UDOCD(NY,NX),UDONQ(NY,NX),UDOND(NY,NX)
     2,UDOPQ(NY,NX),UDOPD(NY,NX),UDICQ(NY,NX),UDICD(NY,NX)
     3,UDINQ(NY,NX),UDIND(NY,NX),UDIPQ(NY,NX),UDIPD(NY,NX)
     4,UXCSN(NY,NX),UXZSN(NY,NX),UXPSN(NY,NX),UCOP(NY,NX)
     5,UDRAIN(NY,NX),ZDRAIN(NY,NX),PDRAIN(NY,NX),DPNH4(NY,NX)
     6,DPNO3(NY,NX),DPPO4(NY,NX),DETS(NY,NX),DETE(NY,NX)
     7,CER(NY,NX),XER(NY,NX),USEDOU(NY,NX),ROWN(NY,NX),ROWO(NY,NX)
     8,ROWP(NY,NX),DTBLZ(NY,NX),DTBLD(NY,NX),TNBP(NY,NX),VOLR(NY,NX)
     9,SED(NY,NX),TGPP(NY,NX),TRAU(NY,NX),TNPP(NY,NX),THRE(NY,NX)
     1,TCAN(NY,NX),TLEC(NY,NX),TSHC(NY,NX),DYLN(NY,NX),DYLX(NY,NX) 
     2,DTBLX(NY,NX),DTBLY(NY,NX),(RC0(K,NY,NX),K=0,5)
     3,VOLSS(NY,NX),VOLWS(NY,NX),VOLIS(NY,NX),VOLS(NY,NX)
     4,DPTHS(NY,NX),ENGYP(NY,NX)
      WRITE(21,91)I,IDATA(3),(VOLSSL(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(VOLISL(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(VOLWSL(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(VOLSL(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(DENSS(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(DLYRS(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(VHCPW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(TKW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(TCW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(CO2W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(CH4W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(OXYW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZNGW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZN2W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZN4W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZN3W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZNOW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(Z1PW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZHPW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(FHOL(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(DLYR(3,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CDPTH(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CDPTHZ(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(BKDSI(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(BKDS(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CORGC(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(POROS(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(FC(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(WP(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(SCNV(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(SCNH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(SAND(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(SILT(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CLAY(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VOLW(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VOLWX(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VOLI(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VOLP(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VOLA(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VOLY(L,NY,NX),L=0,NLI(NY,NX))
C     WRITE(21,91)I,IDATA(3),(GKC4(L,NY,NX),L=1,NLI(NY,NX))
C     WRITE(21,91)I,IDATA(3),(GKCH(L,NY,NX),L=1,NLI(NY,NX))
C     WRITE(21,91)I,IDATA(3),(GKCA(L,NY,NX),L=1,NLI(NY,NX))
C     WRITE(21,91)I,IDATA(3),(GKCM(L,NY,NX),L=1,NLI(NY,NX))
C     WRITE(21,91)I,IDATA(3),(GKCN(L,NY,NX),L=1,NLI(NY,NX))
C     WRITE(21,91)I,IDATA(3),(GKCK(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XCEC(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XAEC(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(TCS(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(TKS(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VHCP(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VHCM(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CO2G(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CO2S(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CO2SH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CH4G(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CH4S(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CH4SH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ROXYF(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RCO2F(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ROXYL(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RCH4F(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RCH4L(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H2GG(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H2GS(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(OXYG(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(OXYS(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(OXYSH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ROXYX(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RNH4X(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RNO3X(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RNO2X(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RN2OX(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RPO4X(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RP14X(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RNHBX(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RN3BX(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RN2BX(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RPOBX(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RP1BX(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,95)I,IDATA(3),((ROQCX(K,L,NY,NX),L=0,NLI(NY,NX)),K=0,4)
      WRITE(21,95)I,IDATA(3),((ROQAX(K,L,NY,NX),L=0,NLI(NY,NX)),K=0,4)
      WRITE(21,91)I,IDATA(3),(VOLWH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VOLIH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VOLAH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(RTDNT(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZL(L,NY,NX),L=0,JC)
      WRITE(21,91)I,IDATA(3),(ARLFT(L,NY,NX),L=1,JC)
      WRITE(21,91)I,IDATA(3),(ARSTT(L,NY,NX),L=1,JC)
      WRITE(21,91)I,IDATA(3),(WGLFT(L,NY,NX),L=1,JC)
      WRITE(21,91)I,IDATA(3),(VLNH4(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VLNHB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VLNO3(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VLNOB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VLPO4(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(VLPOB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XN4(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XNB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XOH0(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XOH1(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XOH2(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XH1P(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XH2P(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XOH0B(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XOH1B(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XOH2B(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XH1PB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XH2PB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PALPO(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PFEPO(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PCAPD(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PCAPH(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PCAPM(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PALPB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PFEPB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PCPDB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PCPHB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PCPMB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(CION(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZAL(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFE(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZHY(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA(L,NY,NX),L=1,NLI(NY,NX))
      IF(ISALTG.NE.0)THEN
      WRITE(21,91)I,IDATA(3),(ZALW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZFEW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZHYW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCAW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZMGW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZNAW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZKAW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZOHW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZSO4W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCLW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCO3W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZHCO3W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZALH1W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZALH2W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZALH3W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZALH4W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZALSW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZFEH1W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZFEH2W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZFEH3W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZFEH4W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZFESW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCAOW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCACW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCAHW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCASW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZMGOW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZMGCW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZMGHW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZMGSW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZNACW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZNASW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZKASW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(H0PO4W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(H3PO4W(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZFE1PW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZFE2PW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCA0PW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCA1PW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZCA2PW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZMG1PW(L,NY,NX),L=1,JS)
      WRITE(21,91)I,IDATA(3),(ZMG(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZNA(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZKA(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZOH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZSO4(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCL(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCO3(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZHCO3(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALOH1(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALOH2(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALOH3(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALOH4(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALS(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFEOH1(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFEOH2(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFEOH3(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFEOH4(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFES(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCAO(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCAC(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCAH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCAS(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMGO(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMGC(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMGH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMGS(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZNAC(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZNAS(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZKAS(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H0PO4(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H3PO4(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFE1P(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFE2P(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA0P(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA1P(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA2P(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMG1P(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H0POB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H3POB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFE1PB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFE2PB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA0PB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA1PB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA2PB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMG1PB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFEH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZHYH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCCH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMGH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZNAH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZKAH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZOHH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZSO4H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCLH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCO3H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZHCO3H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALO1H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALO2H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALO3H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALO4H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZALSH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFEO1H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFEO2H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFEO3H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFEO4H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFESH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCAOH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCACH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCAHH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCASH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMGOH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMGCH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMGHH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMGSH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZNACH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZNASH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZKASH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H0PO4H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H3PO4H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFE1PH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFE2PH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA0PH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA1PH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA2PH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMG1PH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H0POBH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(H3POBH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFE1BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZFE2BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA0BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA1BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZCA2BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(ZMG1BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XHY(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XAL(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XFE(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XCA(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XMG(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XNA(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(XKA(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PALOH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PFEOH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PCACO(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(21,91)I,IDATA(3),(PCASO(L,NY,NX),L=1,NLI(NY,NX))
      ENDIF
      DO 9985 K=0,5
      DO 9985 N=1,7
      WRITE(22,91)I,IDATA(3),(ROXYS(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RVMX4(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RVMX3(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RVMX2(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RVMX1(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RVMB4(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RVMB3(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RVMB2(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RINHO(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RINOO(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RIPOO(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RINHB(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RINOB(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(RIPBO(N,K,L,NY,NX),L=0,NLI(NY,NX))
      IF(K.LE.4)THEN
      WRITE(22,91)I,IDATA(3),(ROQCS(N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ROQAS(N,K,L,NY,NX),L=0,NLI(NY,NX))
      ENDIF
      WRITE(22,91)I,IDATA(3),RINHOR(N,K,NY,NX)
      WRITE(22,91)I,IDATA(3),RINOOR(N,K,NY,NX)
      WRITE(22,91)I,IDATA(3),RIPOOR(N,K,NY,NX)
      DO 9985 M=1,3
      WRITE(22,91)I,IDATA(3),(OMC(M,N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OMN(M,N,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OMP(M,N,K,L,NY,NX),L=0,NLI(NY,NX))
9985  CONTINUE
      DO 9980 K=0,4
      DO 9975 M=1,2
      WRITE(22,91)I,IDATA(3),(ORC(M,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ORN(M,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ORP(M,K,L,NY,NX),L=0,NLI(NY,NX))
9975  CONTINUE
      WRITE(22,91)I,IDATA(3),(OQC(K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OQN(K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OQP(K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OQA(K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OQCH(K,L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OQNH(K,L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OQPH(K,L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OQAH(K,L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OHC(K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OHN(K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OHP(K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OHA(K,L,NY,NX),L=0,NLI(NY,NX))
      DO 9970 M=1,4
      WRITE(22,91)I,IDATA(3),(OSC(M,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OSA(M,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OSN(M,K,L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(OSP(M,K,L,NY,NX),L=0,NLI(NY,NX))
9970  CONTINUE
9980  CONTINUE
      WRITE(22,91)I,IDATA(3),(RVMXC(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ORGC(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ORGR(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH4FA(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH3FA(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNHUFA(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO3FA(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH4FB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH3FB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNHUFB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO3FB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(Z2GG(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(Z2GS(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(Z2GSH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(Z2OG(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(Z2OS(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(Z2OSH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH3G(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH4S(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH4SH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH3S(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH3SH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO3S(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO3SH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO2S(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO2SH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(H1PO4(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(H2PO4(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(H1PO4H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(H2PO4H(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH4B(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH4BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH3B(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNH3BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO3B(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO3BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO2B(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNO2BH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(H1POB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(H2POB(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(H1POBH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(H2POBH(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(WDNHB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(DPNHB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(WDNOB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(DPNOB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(WDPOB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(DPPOB(L,NY,NX),L=1,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNHUI(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNHU0(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNFNI(L,NY,NX),L=0,NLI(NY,NX))
      WRITE(22,91)I,IDATA(3),(ZNFN0(L,NY,NX),L=0,NLI(NY,NX))
9990  CONTINUE
9995  CONTINUE
90    FORMAT(2I4,15E17.8E3,/,15E17.8E3,/,15E17.8E3
     2,/,15E17.8E3,/,15E17.8E3,/,15E17.8E3)
91    FORMAT(2I4,21E17.8E3)
92    FORMAT(2I4,15E17.8E3,/,15E17.8E3,/,15E17.8E3
     2,/,15E17.8E3,/,15E17.8E3,/,15E17.8E3)
93    FORMAT(8I4,15E17.8E3,/,15E17.8E3,/,15E17.8E3,/,15E17.8E3
     2,/,15E17.8E3,/,15E17.8E3,/,15E17.8E3,/,15E17.8E3,/,15E17.8E3)
95    FORMAT(2I4,15E17.8E3,/,15E17.8E3,/,15E17.8E3,/,15E17.8E3
     2,/,15E17.8E3,/,15E17.8E3,/,15E17.8E3,/,15E17.8E3)
      RETURN
      END

