/*----------------------------------------------------------------------------
 * Module: interdm.c
 *         $Id: interdm.c,v 2.2 1996/07/25 17:37:18 pjt Exp pjt $
 * ----------------------------------------------------------------------------
 *
 * Description:  Interdm API functions. (Optab management)
 *
 * This module is part of OPTIDOC (Interdm)
 *
 * History: $Log: interdm.c,v $
 * Revision 2.6  1996/12/20  12:20:40  mpf
 * Porting para Windows NT.
 *
 * Revision 2.5  1996/11/13  12:06:23  pjt
 * Erro na ordem dos args de LerFicha
 *
 * Revision 2.4  1996/11/12  20:45:01  pjt
 * Corr. Erro Conv. Optabs
 *
 * Revision 2.2  1996/07/25  17:37:18  pjt
 * Integracao Branch 2.0.1
 *
 * Revision 2.0.1.1  1996/04/29  17:35:16  pjt
 * Optidoc Dev. Branch Start
 *
 * Revision 2.0  1996/04/29  13:30:56  pjt
 * OPT_R51F
 *
 * Revision 1.8  1996/02/26  10:37:24  pjt
 * *** empty log message ***
 *
 * Revision 1.7  1996/02/23  16:02:46  pjt
 * *** empty log message ***
 *
 * Revision 1.6  1996/02/15  17:39:20  pjt
 * *** empty log message ***
 *
 * Revision 1.5  1996/02/14  15:26:04  pjt
 * Uniformizacao V51/DEV
 *
 * Revision 1.4  1996/02/13  17:51:37  pjc
 * limpesa de warnings
 *
 * Revision 1.3  1996/02/03  14:34:35  mpf
 * Alteracao de chamada a chown() em WIN32
 *
 * Revision 1.2  1995/11/29  15:50:19  pjc
 * OPT-R51
 *
 * Revision 1.2  1995/05/29  09:26:10  pjt
 * Revision 1.1  1995/05/26  17:50:41  pjt
 * Initial revision
 *
 * ------------------------------------------------
 * Development going on:
 *		- BRS interface deactivated
 *		- PRD support
 * ------------------------------------------------
 * Copyright (c) 1989...95, SMD.
 * All Rights Reserved. Licensed Material-Property of SMD
 * --------------------------------------------------------------------------*/

#define _INTERDM_C

#include "elenix.h"

#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdio.h>
#include <time.h>
#include <ctype.h>
#include <fcntl.h>
#include <errno.h>

#ifdef UNIX
# ifdef ELE_HAVE_UNISTD_H
#    include <unistd.h>
# endif /* ELE_HAVE_UNISTD_H */
#endif

#ifdef MSDOS
# include <direct.h>
# include <dir.h>
# include <dos.h>
# include <io.h>
# include <search.h>
#endif

#ifdef WINDOWS
# include <windows.h>
# include <io.h>
# include <ctype.h>
# include <winsock.h>
#endif


#define  _OPT_TYPES

#include "notify.h"
#include "elnxgen.h"
#include "elnxerr.h"
#include "elwfunc.h"
#include "sockint.h"
#include "optidoc.h"
#include "interdm.h"
#include "geral.h"


/* FOR DEBBUGING */
#include <notify.h>


#define DOAP_RO_VERSIONS 		1 /* Recup. versões - lança dialogo para escolher qual a versao */
#define DOAP_RO_RO2TMP   		2 /* Para recuperar para tmp se dir. tiver prot. escrita */
#define DOAP_RO_IFPRDNOLOAD   	4 /* Se PRD, vem só pag. 0 */




int 			DLL_ocupada=0;
ContVerSt       PVInf_ContVerSt ;
extern ESGEN_HandleArrayDesc stGContextsDsc;

LPCSTR MsgErroOptidoc ( HINSTANCE hInst, int erro, LPSTR buffer, int LenBuffer );


#ifndef OLD_CSTYLE
int DUMMY_Avisofunc ( int which_dialog, char *arg1 )
#else
int DUMMY_Avisofunc ( which_dialog, arg1 )
int which_dialog;
char *arg1;
#endif
{

	switch (which_dialog) {

		case IDM_DIALOG_VERSIONS :
			return 0;	/* Error return because this dialog is mandatory when used */

		case IDM_DIALOG_NEWFILENAME :
			return 0;	/* Error return because this dialog is mandatory when used */

		case IDM_DIALOG_OPTDELET_YN :
			return 1;

		case IDM_DIALOG_RMARQX_YN :
			return 1;

		case IDM_DIALOG_MVARQX_YN :
			return 1;

		case IDM_DIALOG_OPTDELET_YNA :
			return 1;

		case IDM_DIALOG_RMARQX_YNA :
			return 1;

		case IDM_DIALOG_MVARQX_YNA :
			return 1;

	}
    return 0;
}


ESIDM_IOControl stIDMNullIO = {DUMMY_Avisofunc, {NULL,NULL}};


/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% SORTED FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */


/*-------------------------------------------------
	Rotina: IDM_EndOptidoc()
	"Desliga" o sistema cliente OPTIDOC
	Retorna 0 se tudo bem e -1 se falhou algo
-------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
	 far pascal _export
#endif
#ifdef MSDOS
		IDM_EndOptidoc(int *phOpt)
#else
		IDM_EndOptidoc(phOpt)
		int *phOpt;
#endif
{
int ret;

#ifdef WINDOWS
	if (DLL_ocupada==1)
			return(EDLL_BUSY);
	else
			DLL_ocupada=1;
#endif

	ret = iidm_end_optidoc(phOpt);
	DLL_ocupada=0;
	return ret;
}


/*-------------------------------------------------
	Rotina: IDM_InitOptidoc()
	Faz a inicializacao do sistema cliente OPTIDOC
	Retorna 0 se tudo bem e -1 se falhou algo
-------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
	 far pascal _export
#endif
#ifdef MSDOS
		IDM_InitOptidoc(int *phOpt)
#else
		IDM_InitOptidoc(phOpt)
		int *phOpt;
#endif
{
int ret;

#ifdef WINDOWS
	if (DLL_ocupada==1)
		return(EDLL_BUSY);
	else
		DLL_ocupada=1;
#endif

	ret = iidm_init_optidoc(phOpt);
	DLL_ocupada=0;
	return ret;
}

/*+---------------------------------------------------------------------------+
|    Rotina : IDM_ListaDiscos
+-----------------------------------------------------------------------------+
|
|    Descricao:
|
|    Parametros (Entrada)   :
|               (Saida)     :
|
|    Retorna :
|
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
	far pascal _export
#endif
#ifndef OLD_CSTYLE
IDM_ListaDiscos (int *phOpt, char *servidor, int  *num_sv, struct o_srv_disk_info  **info2)
#else
IDM_ListaDiscos (phOpt,servidor,num_sv,info2)
int *phOpt;
char *servidor;
int *num_sv;
struct o_srv_disk_info **info2;
#endif
{
int res,tries;

#ifdef WINDOWS
	 if (DLL_ocupada==1)
			return(EDLL_BUSY);
	 else
			DLL_ocupada=1;
#endif

	res = iidm_init_optidoc(phOpt);

	if (res != OK) {
#ifdef WINDOWS
		DLL_ocupada=0;
#endif
		return res;
	}
	tries = 2;
	while (tries) {
		res = OPC_OdiskList (num_sv, info2);
		tries--;
		if (res == TIME_ERR && tries > 0) {

			res = iidm_init_optidoc(phOpt);

			if (res)
				break;
		}
		else
			break;
	 }

#ifdef WINDOWS
	 DLL_ocupada=0;
#endif

 return res;
}

extern "C" int
#ifdef WINDOWS
	far pascal _export
#endif
#ifdef MSDOS
	IDM_PingOptidoc(void)
#else
	IDM_PingOptidoc()
#endif
{
int ret;

#ifdef WINDOWS
	if (DLL_ocupada==1)
			return(NETSVOFF);
	else
			DLL_ocupada=1;
#endif

	ret = iidm_ping_optidoc(NULL,NULL);

#ifdef WINDOWS
	DLL_ocupada=0;
#endif

	return ret;

}

/*+---------------------------------------------------------------------------+

	Function:     IDM_PingOptidocServer

	Description:  Faz a inicializacao do sistema cliente OPTIDOC
				  mas sem validar utilizadores, apenas para ver
				  se o servidor estß lancado.
	Args:
	Return:       Retorna 0 se tudo bem e -1 se falhou algo
	Notes:

----------------------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
	far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_PingOptidocServer(char *svname, unsigned short svport)
#else
	IDM_PingOptidocServer(svname,svport)
	char *svname;
	unsigned short svport;
#endif
{
int ret;

#ifdef WINDOWS
	if (DLL_ocupada==1)
			return(EDLL_BUSY);
	else
			DLL_ocupada=1;
#endif

	ret = iidm_ping_optidoc(svname,svport);

#ifdef WINDOWS
	DLL_ocupada=0;
#endif

	return ret;

}

/*-------------------------------------------------
	Rotina: IDM_SetConfiguration()
			Inicializa/Altera parametros de
			configuracao por pedido expresso
			do "utilizador" desta api
            Tem de ser fornecido um Handler valido e inicializado
------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
	 far pascal _export
#endif
#ifdef MSDOS
		IDM_SetConfiguration(int hOpt, unsigned short wOptCase)
#else
		IDM_SetConfiguration(hOpt, wOptCase)
        int				hOpt;
		unsigned short  wOptCase;
#endif
{
ESIDM_OptContext *pstContext;

	pstContext = ((ESIDM_OptContext *) stGContextsDsc.pArray[hOpt]);

	/*if (GEN_HandleIsValid(pstGContextsDsc,hOpt)).....*/
	pstContext->bOptCase = wOptCase;
	return 0;
}
/*  -------------------------------------------------------
	Rotina IDM_SetServer()
	Destina-se a estabelecer o nome do servidor.
	Permite-se a sua utilizacao directa para comutar de
	 posto servidor
-------------------------------------------------------------------*/

extern "C" int
#ifdef WINDOWS
   far pascal _export
#endif
#ifdef MSDOS
	IDM_SetServer(char *server, short port)
#else
	IDM_SetServer(server, port)
	char *server;
	short port;
#endif
{

#ifdef WINDOWS
  if (DLL_ocupada==1)
	return(EDLL_BUSY);
  else
	DLL_ocupada=1;
#endif

  /* Desactivada ... set_oserver(server, port);*/
  /*                 OptInicializado = 1;*/

#ifdef WINDOWS
  DLL_ocupada=0;
#endif
  return 0;
}




/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS TO SORT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS TO SORT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS TO SORT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS TO SORT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS TO SORT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS TO SORT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS TO SORT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS TO SORT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */



/*+---------------------------------------------------------------------------+
|    Rotina : IDM_GuardaExterior
+-----------------------------------------------------------------------------+
|
|    Descricao:
|          ARQ  : copiar para DO , apagar de ARQ, inserir opt_t
|          DO   : (avisa que o doc. ja esta em DO)
|        DO+ARQ :                  apagar de ARQ, altera status p/ DO
|        DO+ARQ*: copiar para DO , apagar de ARQ, altera opt_t (nom_DO,index,status)
|
|       ( o mesmo para o caso da BRS)
|
|    Parametros (Entrada)   :
|               (Saida)     :
|
|    Retorna : 0 - se nao houve erro.
|                          O codigo do erro c.c.
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
	far pascal _export
#endif
#ifndef OLD_CSTYLE
IDM_GuardaExterior (int *phOpt, char *pszDiskName, char *pszFile, char *ficha_cli, int tamficha_cli, ESIDM_IOControl *pstIOCtrl)
#else
IDM_GuardaExterior (phOpt, pszDiskName,pszFile,ficha_cli,tamficha_cli, pstIOCtrl)
int *phOpt;
char *pszDiskName;
char *pszFile;
char *ficha_cli;
int   tamficha_cli;
ESIDM_IOControl *pstIOCtrl;
#endif
{
int iRet;

#ifdef WINDOWS
	if (DLL_ocupada==1)
		return(EDLL_BUSY);
	else
		DLL_ocupada=1;
#endif

	iRet = iidm_save_file (phOpt, pszDiskName, pszFile, ficha_cli, tamficha_cli, pstIOCtrl);
	DLL_ocupada=0;
	return (iRet);

}

int aux_sort_function( const void *a, const void *b)
{
char *s1,*s2;

	memcpy(&s1, a, sizeof(char*));
	memcpy(&s2, b, sizeof(char*));
    return( stricmp(s1,s2) );
}

/*+---------------------------------------------------------------------------+
|    Rotina : iidm_SaveFile
+-----------------------------------------------------------------------------+
|
|    Descricao:
|          ARQ  : copiar para DO , apagar de ARQ, inserir opt_t
|          DO   : (avisa que o doc. ja esta em DO)
|        DO+ARQ :                  apagar de ARQ, altera status p/ DO
|        DO+ARQ*: copiar para DO , apagar de ARQ, altera opt_t (nom_DO,index,status)
|
|       ( o mesmo para o caso da BRS)
|
|    Parametros (Entrada)   :
|               (Saida)     :
|
|    Retorna : 0 - se nao houve erro.
|                          O codigo do erro c.c.
|
+----------------------------------------------------------------------------*/
int
#ifndef OLD_CSTYLE
iidm_save_file (int *phOpt, char *pszDiskName, char *pszFile, char *ficha_cli, int tamficha_cli, ESIDM_IOControl *pstIOCtrl)
#else
iidm_save_file (phOpt, pszDiskName,pszFile,ficha_cli,tamficha_cli, pstIOCtrl)
int *phOpt;
char *pszDiskName;
char *pszFile;
char *ficha_cli;
int   tamficha_cli;
ESIDM_IOControl *pstIOCtrl;
#endif
{
	char            *ficha;
	unsigned int    tamficha;
	char            *p;
	opt_t           inf_opt, stOptAux;
	long            index;
	char            HostName[SERVER_NAME_SIZE];
	int             st,i,tries, err,k;
	NATRIB_STRUCT   atrib;
	int             erro,res,done;
	int             file_in_opt,iStatusPag;
	BOOL			bDOARQ2DO;
	ESOPC_IOControl *pstTrfIOCtrl;
	ESIDM_IOControl stIOCtrlAux;
#ifdef WINDOWS 		/* For PRD management */
	struct ffblk    stFfblk;
#endif

	char		 	**ppwPageNameList;
	unsigned short 	wNPages=0;
	int				iFileIsPRD;
	char			szOptab[OMAXPATHNAME+1];
	char			szFileDirName[OMAXPATHNAME+1];
	char			szShortFileName[OMAXFILENAME+1];
	char			szFullFileName[OMAXPATHNAME+1];
	char			szPRDBDTFile[OMAXPATHNAME+1];
	char            szPRDTmpFile[OMAXPATHNAME+1];
	char			szAux[OMAXFILENAME+1];
	ContVerSt		*pstAssocFileList=NULL;
	unsigned short  wNAssocFiles;
	ContVerSt       LVInf_ContVerSt ;

	if (pstIOCtrl == NULL) {
		pstIOCtrl = &stIDMNullIO;
		pstTrfIOCtrl = NULL;
	}
	else {
		pstTrfIOCtrl = &(pstIOCtrl->stOPCIOCtl);
    }

	if (pszDiskName) {
		for (i=0; pszDiskName[i]; i++)
			pszDiskName[i] = toupper(pszDiskName[i]);
	}

	/* 19-10-95   pjc  informacao da versao recuperada  ----------------*/
	strcpy (inf_opt.nom_DO_VR,"");
	inf_opt.ind_VR = 0 ;
	inf_opt.filestat_VR.dev = 0;
	inf_opt.filestat_VR.inumber = 0;
	inf_opt.filestat_VR.mode = 0;
	inf_opt.filestat_VR.nlink = 0;
	inf_opt.filestat_VR.uid = 0;
	inf_opt.filestat_VR.gid = 0;
	inf_opt.filestat_VR.rdev = 0;
	inf_opt.filestat_VR.size = 0;
	inf_opt.filestat_VR.atime = 0;
	inf_opt.filestat_VR.mtime = 0;
	inf_opt.filestat_VR.ctime = 0;
	inf_opt.filestat_VR.env = 0;

	/* PJT 22-11-95 Limitar nomes de ficheiros a 14 chars  */
	GEN_SplitPath(pszFile, szFileDirName, szShortFileName);

	if (strlen(szShortFileName)>OMAXFILENAME)
		return EIDM_BADFILENAME;

	/* pjt 27/11/96 #36 */
	if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
		sprintf (szOptab, "%s%s", szFileDirName, OPTTABNAME);
    else
		sprintf (szOptab, "%s%c%s", szFileDirName, SLASH, OPTTABNAME);
	/* end #36 */
	if (!iidm_file_access ( szOptab, 00 ) ) {
		/* .......  optab nao existe  -> verificar se se tem permissao de escrita na directoria ..... */
		if (!iidm_file_access ( szFileDirName, 02 ) )
			return EPRIVILEGIOS;
	}
	else {
		/* ..........  optab existe -> testar se se tem permissao de escrita  .... */
		if (!iidm_file_access ( szOptab, 02 ) )
			return EPRIVILEGIOS;
	}

	iidm_getpath(pszFile, szFullFileName);
	file_in_opt = iidm_file_is_in_optab (szFullFileName, &inf_opt);

	if (file_in_opt == -1)
		return EOPTABINVAL;

	/* pjt 9-5-96 METSOVO */
	if (file_in_opt && inf_opt.status == S_ARQ) {
		file_in_opt = FALSE;
		iFileIsPRD  = TRUE;
	}
	else if (!file_in_opt)
		iFileIsPRD = FALSE;
	else
		iFileIsPRD = inf_opt.isPRD;


	/* pjc 17-04-95  Controlo versoes de documentos, guardar o disco e index da versao anterior*/
	if (file_in_opt  &&  inf_opt.status == S_DOARQX) {
		strcpy(LVInf_ContVerSt.disco, inf_opt.nom_DO);
		LVInf_ContVerSt.index = inf_opt.ind ;
	}
	else {
		strcpy(LVInf_ContVerSt.disco, "");
		LVInf_ContVerSt.index = 0L;
	}

	/* o doc. ja se encontra em DO */
	if (file_in_opt && inf_opt.status == S_DO)
		return EJAEMMEIO;

    strcpy (szAux, szShortFileName);
	p = strrchr(szAux, '.');
	if (p)
		*p='\0';

	if (iFileIsPRD) {
        iidm_file_2_bdt(szFullFileName, szPRDBDTFile);
		/* pjt 28/10/998
		if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
			sprintf (szPRDBDTFile, "%s%s%c%s%c%s%s",szFileDirName,OPTDIRNAME,SLASH,szShortFileName,SLASH,szAux,OPTEXTBDT);
		else
			sprintf (szPRDBDTFile, "%s%c%s%c%s%c%s%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szShortFileName,SLASH,szAux,OPTEXTBDT);
        */
    }
	erro = iidm_n_atributos(szFullFileName, &atrib);
	if (erro != 0)
		return EATRIBUTOS;
	if ((atrib.mode  & S_IFMT) == S_IFDIR)
		return EDIR;
	if (access(szFullFileName,02) != 0)
		return EPRIVILEGIOS;

	bDOARQ2DO = FALSE;
	if ( file_in_opt ) {
		if (inf_opt.status == S_DOARQ) {
			bDOARQ2DO = TRUE;
			if ( unlink(szFullFileName) != 0)
				return EREMOVER;
			inf_opt.status = S_DO;
			if (iFileIsPRD)
				inf_opt.isPRD = EDIDM_PRD_COMPLETE;
			else
				inf_opt.isPRD = 0;
			inf_opt.ver_actual = inf_opt.ult_versao;
			erro = iidm_alterar_opt(szFullFileName,inf_opt);
#ifdef WINDOWS
			if (!iFileIsPRD)
				return 0;
			else {
                /* pjt 12/11/96 BDT wasn't being erased */
				unlink(szPRDBDTFile);
				goto PAGES;
            }
#else
			return 0;
#endif
		}
	}

#ifdef WINDOWS
PAGES:	if (iFileIsPRD) {
			/* pjt 27/11/96 #36 */
			if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
				sprintf (szPRDTmpFile, "%s%s%c%s%c*.TIF",szFileDirName,OPTDIRNAME,SLASH,szShortFileName,SLASH);
			else
				sprintf (szPRDTmpFile, "%s%c%s%c%s%c*.TIF",szFileDirName,SLASH,OPTDIRNAME,SLASH,szShortFileName,SLASH);

            if (findfirst(szPRDTmpFile, &stFfblk, 0) != 0) {
				if (!bDOARQ2DO)
					goto GO_ON;
				else
					return 0;
			}
			done=0;
            /*i=1;*/
			stIOCtrlAux = *pstIOCtrl;
			/*pstIOCtrlSAF = pstIOCtrl;*/
			stIOCtrlAux.stOPCIOCtl.printfunc = NULL;
			ppwPageNameList=NULL;
			wNPages=0;

			while (!done) {

				iStatusPag = iidm_get_info (szPRDTmpFile, &stOptAux, EDIDM_ONLYOPTS);
				if (iStatusPag == 0)
					iidm_acerta_arqx (szPRDTmpFile, stOptAux);
				/* pjt 17/12/96 #41 Registar lista de pags para enviar ordenadas
				if ( !(iStatusPag == 0 && stOptAux.status == S_DOARQ) ) {
					if (pstIOCtrl->stOPCIOCtl.printfunc)
						(*pstIOCtrl->stOPCIOCtl.printfunc)(EDIDM_IOMSG_03, stFfblk.ff_name);
                }
				erro = iidm_save_file(phOpt, pszDiskName, szPRDTmpFile, NULL, 0,&stIOCtrlAux);
				if (erro)
					return(erro);*/
				if (wNPages==0) {
					ppwPageNameList = (char **) malloc(sizeof(char *));
					if (!ppwPageNameList)
						return EALOCAR;
				}
				else {
					ppwPageNameList = (char **)  realloc(ppwPageNameList, sizeof(char *)*(wNPages+1));
					if (!ppwPageNameList)
						return EALOCAR;
				}
				ppwPageNameList[wNPages] = (char *) malloc(OMAXFILENAME+1);
				if (!ppwPageNameList[wNPages])
					return EALOCAR;
				strcpy(ppwPageNameList[wNPages], stFfblk.ff_name);
				done = findnext(&stFfblk);
				wNPages++;
				/*i++;*/
			}

            /* pjt 17/12/96 #41 Ordenacao do envio das pags para optico */
			erro = 0;
			qsort((void *)ppwPageNameList, wNPages, sizeof(char *),  aux_sort_function);

/*//TRACE
for (k=0; k<wNPages; k++)
MessageBox(NULL, ppwPageNameList[k],"AFTER qsort",  MB_OKCANCEL|MB_ICONEXCLAMATION);*/

			for (k=0; k<wNPages; k++) {
				if (!erro) {
					/* pjt 27/11/96 #36 */
					if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
						sprintf(szPRDTmpFile, "%s%s%c%s%c%s",szFileDirName,OPTDIRNAME,SLASH,szShortFileName,SLASH, ppwPageNameList[k]);
					else
						sprintf(szPRDTmpFile, "%s%c%s%c%s%c%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szShortFileName,SLASH, ppwPageNameList[k]);
					/* end #36 */
					if ( !(iStatusPag == 0 && stOptAux.status == S_DOARQ) ) {
						if (pstIOCtrl->stOPCIOCtl.printfunc)
							(*pstIOCtrl->stOPCIOCtl.printfunc)(EDIDM_IOMSG_03, ppwPageNameList[k]);
            	    }
					erro = iidm_save_file(phOpt, pszDiskName, szPRDTmpFile, NULL, 0,&stIOCtrlAux);
				}
				free(ppwPageNameList[k]);
			}
			free(ppwPageNameList);
			if (erro)
				return(erro);
			/* -------------------- end #41 */

			if (pstIOCtrl->stOPCIOCtl.printfunc)
				(*pstIOCtrl->stOPCIOCtl.printfunc)(EDIDM_IOMSG_04, NULL);
			/* pjt 16/10/96 */
			if (bDOARQ2DO)
				return 0;

			/*pstIOCtrl = pstIOCtrlSAF;*/

			/* Must be done only in the end -----------
			erro = unlink (szPRDBDTFile);
			if ( erro )
				return (EREMOVER);
			*/
            /* 7/8/96 replaced by pjt: the AFT must be filled in order
			if (IDM_FindFirst(szPRDTmpFile, &st, &stFfblk, 0, &stOptAux) != 0)
				goto GO_ON;
			done=0;
			pstAssocFileList=NULL;
			for (wNAssocFiles=0; done==0; wNAssocFiles++) {
				if (st != S_DO && st != S_DOARQ && st != S_DOARQX) {
					if (pstAssocFileList)
						free(pstAssocFileList);
					return EEIDM_PAGENOTOPTIC;
				}
				if (pstAssocFileList==NULL) {
					pstAssocFileList = (ContVerSt *) malloc(sizeof(ContVerSt));
					if (!pstAssocFileList)
						return EALOCAR;
				}
				else {
					pstAssocFileList = (ContVerSt *) realloc(pstAssocFileList, sizeof(ContVerSt)*(wNAssocFiles+1));
					if (!pstAssocFileList)
						return EALOCAR;
				}
				err = iidm_get_info (szFullFileName, &stOptAux, EDIDM_ONLYOPTS);
				if (err) {
					free(pstAssocFileList);
					return err;
                }
				strcpy(pstAssocFileList[wNAssocFiles].disco, stOptAux.nom_DO);
				pstAssocFileList[wNAssocFiles].index = stOptAux.ind;
				done = IDM_FindNext(&st, &stFfblk, &stOptAux);
			}*/

GO_ON:;
			pstAssocFileList=NULL;
			for (wNAssocFiles=0; ; wNAssocFiles++) {
				/* pjt 27/11/96 #36 */
				if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
					sprintf (szPRDTmpFile, "%s%s%c%s%c%08d.TIF",szFileDirName,OPTDIRNAME,SLASH,szShortFileName,SLASH,wNAssocFiles+1);
				else
					sprintf (szPRDTmpFile, "%s%c%s%c%s%c%08d.TIF",szFileDirName,SLASH,OPTDIRNAME,SLASH,szShortFileName,SLASH,wNAssocFiles+1);
				/* end #36 */
				err = iidm_get_info (szPRDTmpFile, &stOptAux, EDIDM_ONLYOPTS);
				if (err == ENAOEMMEIO) {
					if (wNAssocFiles > 0)
						break;
                    else {
						if (pstAssocFileList)
							free(pstAssocFileList);
						return err;
                	}
				}
				if (err) {
					if (pstAssocFileList)
						free(pstAssocFileList);
					return err;
				}
				if (stOptAux.status == S_DOARQX) {
					if (pstAssocFileList)
						free(pstAssocFileList);
					return EEIDM_DOARQX;
				}
				if (stOptAux.status != S_DO && stOptAux.status != S_DOARQ) {
					if (pstAssocFileList)
						free(pstAssocFileList);
					return EEIDM_PAGENOTOPTIC;
				}
				/*if (stOptAux.status == S_DOARQX) {
					if (pstAssocFileList)
						free(pstAssocFileList);
					return EEIDM_DOARQX;
				} */
				if (pstAssocFileList==NULL) {
					pstAssocFileList = (ContVerSt *) malloc(sizeof(ContVerSt));
					if (!pstAssocFileList)
						return EALOCAR;
				}
				else {
					pstAssocFileList = (ContVerSt *) realloc(pstAssocFileList, sizeof(ContVerSt)*(wNAssocFiles+1));
					if (!pstAssocFileList)
						return EALOCAR;
				}
				strcpy(pstAssocFileList[wNAssocFiles].disco, stOptAux.nom_DO);
				pstAssocFileList[wNAssocFiles].index = stOptAux.ind;
			}
		}
#endif

	/* Back to main file ... */
	res = iidm_init_optidoc(phOpt);
	if (res) { 
		if (pstAssocFileList)
			free(pstAssocFileList);
		return res;
    }

	err = OPC_GetHostName(HostName);
	tamficha = F_CABSIZE + F_STATSIZE + strlen(szFullFileName)+1 + strlen(HostName)+ 1
				/*+ ContVerStSize + 1*/ + (ficha_cli != NULL ? tamficha_cli : 0);
	ficha = (char *) malloc (tamficha);
	if (ficha == NULL) {
		if (pstAssocFileList)
			free(pstAssocFileList);
		return EALOCAR;
    }

	p = ficha;
	memcpy (p, (char *)iidm_cab_ficha_actual(), F_CABSIZE);
	p += F_CABSIZE;
	iidm_conv_atrib_for_ficha (p, atrib);
	p += F_STATSIZE;
	strcpy (p, szFullFileName);
	p += strlen (szFullFileName) + 1;
	strcpy (p, HostName);
	p += strlen (HostName) + 1;

	if (ficha_cli != NULL)
		memcpy (p, ficha_cli, tamficha_cli);

	/* PJT 20-09-94 Como nivel opclient valida users, acusa os resets do servidor.
							Este ciclo e' para recuperar UMA vez dessa situacao */
	strcpy(PVInf_ContVerSt.disco, pszDiskName);
	tries = 2;
	while (tries) {
		if (!iFileIsPRD)
			st = OPC_SaveOfile (szFullFileName, NULL,         NULL, 			0,  		  ficha, &tamficha, LVInf_ContVerSt, &PVInf_ContVerSt, pstTrfIOCtrl);
		else {   
			st = OPC_SaveOfile (szFullFileName, szPRDBDTFile, pstAssocFileList, wNAssocFiles, ficha, &tamficha, LVInf_ContVerSt, &PVInf_ContVerSt, pstTrfIOCtrl);
		}
		
		index = PVInf_ContVerSt.index ;
		tries--;
		if (st == TIME_ERR && tries > 0) {
			st = iidm_init_optidoc(phOpt);
			if (st)
				break;
		}
		else
			break;
	}
	free (ficha);
	if (pstAssocFileList)
		free(pstAssocFileList);

	if (st == 0) {        /* Tudo Bem... */
		inf_opt.status = S_DO;
		/* 17-05-95   pjc  controlo de versoes de documentos  ----------------*/
		strcpy (inf_opt.nom_DO_LV, inf_opt.nom_DO);
		inf_opt.index_LV = LVInf_ContVerSt.index ;
		if ( inf_opt.index_LV != 0 )
			inf_opt.ult_versao ++ ;
		else
			inf_opt.ult_versao = 1;
		inf_opt.ver_actual = inf_opt.ult_versao ;
		inf_opt.ind = index;

		strcpy (inf_opt.nom_DO, pszDiskName);
		inf_opt.filestat = atrib;
		if (iFileIsPRD)
			inf_opt.isPRD = EDIDM_PRD_COMPLETE /* in fact it's absent because its S_DO */;
        else
			inf_opt.isPRD = FALSE;

		if (file_in_opt || iFileIsPRD)
			erro = iidm_alterar_opt(szFullFileName,inf_opt);
		else
			erro = iidm_inserir_opt(szFullFileName,inf_opt) ;

		if ( erro )
			return ( erro );

		erro = unlink ( szFullFileName );
		if ( erro )	{
			/* // pjt  21-6-96  deve dar confusao com os parciais iidm_alterar_status( szFullFileName, S_DOARQ ); */
			/* DLL_ocupada=0; */
			return ( EREMOVER );
		}
		if (iFileIsPRD) {
			erro = unlink (szPRDBDTFile);
			if ( erro )
				return (EREMOVER);
		}
		return 0;
	}
	else {
		return  st;
	}
}



/*+---------------------------------------------------------------------------+
|    Function : IDM_RecuperaExterior
+-----------------------------------------------------------------------------+
|
|    Description:  Loads from an external document server a given file,
|                  updating the local structures optab
|                  For PRD's the load must be total for old versions
|				   
|    Parameters (in ):  szFileName
|               (out):
|
|    Return:  An Optidoc error code
|
+----------------------------------------------------------------------------*/
extern "C" int 
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
IDM_RecuperaExterior (int *phOpt, char *szFileName, unsigned short *pwBlockList, unsigned short wNBlocks, int versao, char *NewFileName, Pind_versao inf_versao, int min_versao, unsigned short wFlag, ESIDM_IOControl *pstIOCtrl)
#else
IDM_RecuperaExterior (phOpt, szFileName, pwBlockList, wNBlocks, versao, NewFileName, inf_versao, min_versao, wFlag, pstIOCtrl)
int *phOpt;
char			*szFileName;
unsigned short	*pwBlockList;
unsigned short   wNBlocks;
int 			 versao;
char 			*NewFileName;
Pind_versao 	 inf_versao;
int 			 min_versao;
unsigned short	 wFlag;
ESIDM_IOControl *pstIOCtrl;
#endif
{
int iRet;

#ifdef WINDOWS
	if (DLL_ocupada==1)
		return(EDLL_BUSY);
	else
		DLL_ocupada=1;
#endif

	iRet = iidm_load_file (phOpt, szFileName, pwBlockList, wNBlocks, versao, NewFileName, inf_versao, min_versao, wFlag, pstIOCtrl);
	DLL_ocupada=0;
	return (iRet);

}



/*+---------------------------------------------------------------------------+
|    Function : IDM_RecuperaExterior
+-----------------------------------------------------------------------------+
|
|    Description:  Loads from an external document server a given file,
|                  updating the local structures optab
|                  For PRD's the load must be total for old versions
|				   
|    Parameters (in ):  wFlag - 0 if normal
|                               EDIDM_LOADSUBFILES  <-.
|								EDIDM_ONLYPAINT		<-´cannot be used together
|               (out):
|
|    Return:  An Optidoc error code
|
+----------------------------------------------------------------------------*/
int
#ifndef OLD_CSTYLE
iidm_load_file (int *phOpt, char *szFileName, unsigned short *pwBlockList, unsigned short wNBlocks, int versao, char *NewFileName, Pind_versao inf_versao, int min_versao, unsigned short wFlag, ESIDM_IOControl *pstIOCtrl)
#else
iidm_load_file (phOpt, szFileName, pwBlockList, wNBlocks, versao, NewFileName, inf_versao, min_versao, wFlag, pstIOCtrl)
int *phOpt;
char			*szFileName;
unsigned short	*pwBlockList;
unsigned short   wNBlocks;
int 			 versao;
char 			*NewFileName;
Pind_versao 	 inf_versao;
int 			 min_versao;
unsigned short	 wFlag;
ESIDM_IOControl *pstIOCtrl;
#endif
{
	opt_t    inf_opt, stAuxOptt, stDummyOptt;
	char     szFileShortName[OMAXFILENAME+1],szFileShortNameAux[OMAXFILENAME+1],
			 szFileLongName[OMAXPATHNAME+1],
			 szOptabname[OMAXPATHNAME+1],
			 NewFileName_aux[OMAXPATHNAME+1];
	char	 szPRDBDTFile[OMAXPATHNAME+1];
	char     szPRDTmpFile[2*OMAXPATHNAME+1];
    char	*pszFileToLoad;
	char	 szFileDirName[OMAXPATHNAME+1];
	char	 szAux[OMAXFILENAME+1], *p;
	int      res, st, tries;
	char     ficha[MAXFICHA];
	unsigned int 	tamficha;
	struct utimbuf 	tempos;
	long     		index;
	NATRIB_STRUCT  *pstat, fstat, auxstat;
	int      		res_dlg;
	ogd_t    	   	inf_ogd;
#ifdef WINDOWS
	struct ffblk   	stFfblk;
#endif
	int            	done,i;
	int			    fdAux;
	unsigned long	dwCurrentOffsetInTmp;
	ESBDT_Record 	stBDTRec, *pstBDTRec=&stBDTRec;
	ESBDT_Control 	stBDTCtrl, *pstBDTCtrl=&stBDTCtrl;
	unsigned short  wAskedInd,wBlock;
	ContVerSt	   *pstAssocFileList;
    unsigned short  wNAssocFiles;
	ESOPC_IOControl *pstTrfIOCtrl;
	ESIDM_IOControl stIOCtrlAux;
	ContVerSt       LVInf_ContVerSt ;

	tamficha = MAXFICHA;
	res = iidm_init_optidoc(phOpt);
	if (res != OK) 
		return res;

	if (pstIOCtrl == NULL) {
		pstIOCtrl = &stIDMNullIO;
		pstTrfIOCtrl = NULL;
	}
	else {
		pstTrfIOCtrl = &(pstIOCtrl->stOPCIOCtl);
    }

/* pjt 12/11/96 */
#ifdef WINDOWS
	if (wFlag & EDIDM_ONLYPAINT)
		SINT_dispatch_par_is(1L);
#endif

	strcpy(NewFileName_aux, NewFileName );
	if (NewFileName[0])
		GEN_SplitPath(NewFileName, szFileDirName, szFileShortNameAux);

	GEN_SplitPath(szFileName, szFileDirName, szFileShortName);
	/* pjt 27/11/96 #36 */
	if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
		sprintf (szOptabname, "%s%s", szFileDirName, OPTTABNAME);
	else
		sprintf (szOptabname, "%s%c%s", szFileDirName, SLASH, OPTTABNAME);
	/* end #36 */
	strcpy (szAux, szFileShortName);
	p = strrchr(szAux, '.');
	if (p)
		*p='\0';

	if (!iidm_file_access ( szOptabname, 02 ) ) {
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return EPRIVILEGIOS;
	}
	iidm_getpath(szFileName,szFileLongName);
    /* Char pointer to use as argument to OPC_Load */
	pszFileToLoad = szFileLongName;

	res = iidm_open_optab(&inf_ogd,szOptabname, "r+b");
	if (res != OK) {
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return res;
	}

	if (!iidm_em_DO_ogd (&inf_ogd, szFileLongName, &inf_opt) /* only opts */ ) {
		iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return ENAOEMMEIO;
	}

	if (wNBlocks > 0) {
		if (!inf_opt.isPRD) {
			wNBlocks = 0; /* ignore absurd situation - loads complete document */
			/*		return EIDM_DOCNOTPRD;*/
		}
	}

	/* pjt 9/10/96  Nao ha' problema em fazer e versao pode vir > 0
	if (versao > 0 && wFlag & EDIDM_LOADSUBFILES)
		wFlag &= !EDIDM_LOADSUBFILES; */
	/* pjt 9/10/96
	if (inf_opt.status==S_DOARQX && inf_opt.isPRD && versao > 0)
		return EEIDM_INVALRECVERS;*/

	/* pjt 14/11/96 #022 inf_opt was out of date; this function refreshes inf_opt */
	if (inf_opt.isPRD)
		/* iidm_acerta_arqx (szFileName, inf_opt); */
		iidm_acerta_arqx_ogd (&inf_ogd, szFileLongName, &inf_opt);
	/* pjt end #022 */

	if (inf_opt.status==S_DOARQX && inf_opt.isPRD /* pjt 17/10/96 */ && versao > 0 /* pjt #025 -> */ && NewFileName[0]=='\0' ) {
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return EEIDM_INVALRECVERS;
	}

	/* pjt 14/11/96 #022 inf_opt was out of date */
	if (inf_opt.status==S_DOARQ && inf_opt.isPRD && versao > 0) {
		iidm_fechar_opt(&inf_ogd);
		iidm_save_file(phOpt, "---", szFileLongName /* #022 wasn't long */, NULL, 0, NULL /* #o22 was Pstioctrl */);
		res = iidm_open_optab(&inf_ogd, szOptabname, "r+b");
		if (res) {
#ifdef WINDOWS
			if (wFlag & EDIDM_ONLYPAINT)
				SINT_dispatch_par_is(0L);
#endif
			return res;
		}
		iidm_em_DO_ogd (&inf_ogd, szFileLongName, &inf_opt);
	}
	/* pjt end #022 */

    iidm_file_2_bdt(szFileLongName, szPRDBDTFile);
	/* pjt 28/10/998
	if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
		sprintf (szPRDBDTFile, "%s%s%c%s%c%s%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH,szAux,OPTEXTBDT);
	else
		sprintf (szPRDBDTFile, "%s%c%s%c%s%c%s%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH,szAux,OPTEXTBDT);
	/* end #36 */

	if (inf_opt.status == S_DO || inf_opt.status == S_DOARQ || (inf_opt.status == S_DOARQX && NewFileName_aux[0] != '\0')   || (inf_opt.status == S_DOARQX && inf_opt.isPRD == EDIDM_PRD_PARTIAL && versao <= 0) ) {

		tamficha=MAXFICHA;
		index = inf_opt.ind;
		if ( NewFileName_aux[0] != '\0' )  {
			if ( iidm_acesso_doc(NewFileName_aux,00) == 0) {
				iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
				if (wFlag & EDIDM_ONLYPAINT)
					SINT_dispatch_par_is(0L);
#endif
				return EIDM_OLDFNAME;
			}
		}
		/* pjc    31-05-95   tirei para poder recuperar de disco optico para a versao existente em disco magnetico. Desde que nao esteja alterada
		if (inf_opt.isPRD && versao > 0 ) {
		  if (access(szFileLongname,00) == 0 ) {
			iidm_fechar_opt(&inf_ogd);
			return EJAEMARQ;
          }
		}*/
		tries = 2;
		PVInf_ContVerSt.index = index ;
		strcpy(PVInf_ContVerSt.disco, inf_opt.nom_DO );
		inf_opt.ver_actual = inf_opt.ult_versao ;
		
		if ( versao > 0 && versao < inf_opt.ver_actual ) {
			if ( inf_versao ) {
				if ( versao < min_versao )  {
					inf_opt.ver_actual = min_versao ;
					PVInf_ContVerSt.index = inf_versao[inf_opt.ult_versao - min_versao].index ;
					strcpy(PVInf_ContVerSt.disco, inf_versao[inf_opt.ult_versao - min_versao].disco );
				}
				else {
					inf_opt.ver_actual = versao ;
					PVInf_ContVerSt.index = inf_versao[inf_opt.ult_versao - versao].index ;
					strcpy(PVInf_ContVerSt.disco, inf_versao[inf_opt.ult_versao - versao].disco );
				}
			}
			else {
				PVInf_ContVerSt.index = inf_opt.index_LV ;
				strcpy(PVInf_ContVerSt.disco, inf_opt.nom_DO_LV );
				inf_opt.ver_actual--;
			}
		} 

		if ((inf_opt.status==S_DOARQX || inf_opt.status==S_DOARQ)
				&& inf_opt.isPRD==EDIDM_PRD_PARTIAL	&& wNBlocks==0 ) {
	       	/* When loading versions it should never get here */ 
			strcpy(pstBDTCtrl->szBDTFileName,szPRDBDTFile);
			strcpy(pstBDTCtrl->szBDTMode,"rb");
			res = ibdt_open (pstBDTCtrl);
			if (res) {
#ifdef WINDOWS
				if (wFlag & EDIDM_ONLYPAINT)
					SINT_dispatch_par_is(0L);
#endif
				return res;
			}

            wNBlocks = 0;
			pwBlockList	= NULL;
            wBlock = 0;
			while ((res = ibdt_read_record (pstBDTCtrl, pstBDTRec)) == 0) {
				if ((stBDTRec.wStatus & EDBDT_NOTLOADED) == FALSE ) {
                	wBlock++;
					continue;
                }
				if (pwBlockList == NULL)
					pwBlockList = (unsigned short *) malloc(sizeof(unsigned short));
                else
					pwBlockList = (unsigned short *) realloc(pwBlockList,sizeof(unsigned short)*(wNBlocks+1));
				pwBlockList[wNBlocks++] = wBlock++;
		  }
		  ibdt_close (pstBDTCtrl);
        }

		while (tries) {

            /* Version load management */
			if ( versao > 0 ) {

				if ( versao < inf_opt.ver_actual ) {

				  do {
                	/* Get only header */
					if (inf_opt.isPRD)
						st = OPC_LoadOfile (NULL, NULL, NULL, 0, &pstAssocFileList, &wNAssocFiles,
											ficha, &tamficha,
											&LVInf_ContVerSt, PVInf_ContVerSt, NULL);
					else
						st = OPC_LoadOfile (NULL, NULL, NULL, 0, NULL, NULL,
											ficha, &tamficha,
											&LVInf_ContVerSt, PVInf_ContVerSt, NULL);

					if ( st == TIME_ERR && tries > 0 )  {
						st = iidm_init_optidoc(phOpt);
						if (st)  {
							iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return st;
						}
					}
					else if ( st == DSK_NOT_FOUND || st == NOTFOUND || 
								st == WRONGDSK || st == CHANGED || st == WRONGNAME ) {
						res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_VERSIONS,PVInf_ContVerSt.disco);
						tries--;
						if ( res_dlg == 0 )  {
							iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return CLIENTABORT ;
						}
					}
					else if ( st )  {
						iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
						if (wFlag & EDIDM_ONLYPAINT)
							SINT_dispatch_par_is(0L);
#endif
						return st;
					}
					else    {
						if ( versao < inf_opt.ver_actual )  {
							PVInf_ContVerSt.index = LVInf_ContVerSt.index ;
							strcpy(PVInf_ContVerSt.disco, LVInf_ContVerSt.disco );
						}
						inf_opt.ver_actual--;
					}
				  } while ( versao < inf_opt.ver_actual   && tries > 0) ;
				  tries ++ ;

				} /*if ( versao < inf_opt.ver_actual ) {*/

				if ( NewFileName_aux[0] == '\0' ) {
					if (iidm_lock_regist(&inf_ogd, szFileLongName)==EIDM_LOCKOPTAB) {
						iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
						if (wFlag & EDIDM_ONLYPAINT)
							SINT_dispatch_par_is(0L);
#endif
						return EIDM_LOCKOPTAB ;
					}
				}

                /* PRD VERSION LOAD: */
				if (inf_opt.isPRD) {
					BOOL bAssocsEqual=TRUE;
                    int auxtries=2;

					do {
						st = OPC_LoadOfile (NULL, NULL, NULL, 0, &pstAssocFileList, &wNAssocFiles,
											ficha, &tamficha,
											&LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);

						if ( st == TIME_ERR && auxtries > 0 )  {
							st = iidm_init_optidoc(phOpt);
							if (st)  {
								iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
								if (wFlag & EDIDM_ONLYPAINT)
									SINT_dispatch_par_is(0L);
#endif
								return st;
							}
						}
						else if ( st == DSK_NOT_FOUND || st == NOTFOUND ||
									st == WRONGDSK || st == CHANGED || st == WRONGNAME ) {
                            if (auxtries == 0) {
								iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
								if (wFlag & EDIDM_ONLYPAINT)
									SINT_dispatch_par_is(0L);
#endif
								return st;
							}
							res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_VERSIONS,PVInf_ContVerSt.disco);
							auxtries--;
							if ( res_dlg == 0 )  {
								iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
								if (wFlag & EDIDM_ONLYPAINT)
									SINT_dispatch_par_is(0L);
#endif
								return CLIENTABORT ;
							}
						}
						else if ( st )  {
							iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return st;
						}
						else    {
							/* ok */
                            break;
							/*if ( versao < inf_opt.ver_actual )  {
								PVInf_ContVerSt.index = LVInf_ContVerSt.index ;
								strcpy(PVInf_ContVerSt.disco, LVInf_ContVerSt.disco );
							}
							inf_opt.ver_actual--;*/
						}
					} while ( 1 /*versao < inf_opt.ver_actual   && tries > 0*/ ) ;

					for (i=0; i<wNAssocFiles; i++) {
							/* pjt 27/11/96 #36 */
							if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
								sprintf (szPRDTmpFile, "%s%s%c%s%c%08d.TIF",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH,i+1);
							else
								sprintf (szPRDTmpFile, "%s%c%s%c%s%c%08d.TIF",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH,i+1);
							/* end #36 */
							if (iidm_em_DO(szPRDTmpFile,&stAuxOptt) != 1) {
								bAssocsEqual = FALSE;
								break;
							}
							if (stricmp(stAuxOptt.nom_DO,pstAssocFileList[i].disco) || stAuxOptt.ind != pstAssocFileList[i].index) {
								bAssocsEqual = FALSE;
								break;
							}
					}
                    if (bAssocsEqual) {
							/* pjt 27/11/96 #36 */
							if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
								sprintf (szPRDTmpFile, "%s%s%c%s%c%08d.TIF",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH,i+1);
							else
								sprintf (szPRDTmpFile, "%s%c%s%c%s%c%08d.TIF",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH,i+1);
							/* end #36 */
							if (iidm_em_DO(szPRDTmpFile,&stAuxOptt) == 1)
								bAssocsEqual = FALSE;
					}
					if (!bAssocsEqual ) {
							/* pjt 15/11/96 -> */
							if (NewFileName_aux[0] == '\0') {
								strcpy(szFileShortNameAux,szFileShortName);
								res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_NEWFILENAME,szFileShortNameAux);
								if (res_dlg == FALSE) {
#ifdef WINDOWS
									if (wFlag & EDIDM_ONLYPAINT)
										SINT_dispatch_par_is(0L);
#endif
									return EIDM_OPCANCEL;
								}
								/* pjt 27/11/96 #36 */
								if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
									sprintf (szPRDTmpFile, "%s%s",szFileDirName,szFileShortNameAux);
								else
									sprintf (szPRDTmpFile, "%s%c%s",szFileDirName,SLASH,szFileShortNameAux);
								/* end #36 */
								strcpy (NewFileName_aux,szPRDTmpFile);
								if (iidm_em_DO(NewFileName_aux, &stDummyOptt) || access(NewFileName_aux,0)==0) {
#ifdef WINDOWS
									if (wFlag & EDIDM_ONLYPAINT)
										SINT_dispatch_par_is(0L);
#endif
									return EEIDM_FILEEXISTS;
								}
							}
							strcpy (szAux, szFileShortNameAux);
							p = strrchr(szAux, '.');
							if (p)
								*p='\0';

                        	/* pjt 28/10/998 */
							if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
								sprintf (szPRDBDTFile, "%s%s%c%s%c%s%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortNameAux,SLASH,szAux,OPTBDTNAME);
							else
								sprintf (szPRDBDTFile, "%s%c%s%c%s%c%s%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortNameAux,SLASH,OPTBDTNAME);
					}
				}

				if ( NewFileName_aux[0] != '\0' ) {
					pszFileToLoad = NewFileName_aux;  /* pjt 6-8-96 achei que estava mal */
					if (inf_opt.isPRD) {
						/* pjt 27/11/96 #36 */
						if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
							sprintf (szPRDTmpFile, "%s%s%c%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortNameAux);
						else
							sprintf (szPRDTmpFile, "%s%c%s%c%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortNameAux);
						/* end #36 */

						/* pjt 27/11/96 #37 */
						{
						 char szFullPath[OMAXPATHNAME*2+1];
						 iidm_getpath(szPRDTmpFile, szFullPath);
                         /* pjt 13/11/98 - prever logo comprimento dos fichs das paginas */
						 if (strlen(szFullPath)+1+12 > /*MAXDIR*/MAXPATH-1)
                         /* o teste devera' quando possivel passar a ser feito a ED_MAXFILENAME (eletipo def dependente do sist.oper. */
							return (EEIDM_PGDIRTOOBIG);
                        }
 						/* end #37 */

						if (IDM_Mkdir(szPRDTmpFile)) {
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return EEIDM_MKDIR;
						}


						for (i=0; i<wNAssocFiles; i++) {
							sprintf (stAuxOptt.nome, "%08d.TIF",i+1);
							strcpy (stAuxOptt.nom_DO,pstAssocFileList[i].disco);
							stAuxOptt.ind = pstAssocFileList[i].index;
							stAuxOptt.status = S_DO;
                            /* Verificar bem se se pode fazer isto: */
							stAuxOptt.filestat = inf_opt.filestat;
							stAuxOptt.ult_versao = 1;
							stAuxOptt.isPRD = 0;
							/*st = IDM_SetOptEntry (szPRDTmpFile, stAuxOptt);*/
							/* pjt 27/11/96 #36 */
							if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
								sprintf (szPRDTmpFile, "%s%s%c%s%c%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortNameAux,SLASH,stAuxOptt.nome);
							else
								sprintf (szPRDTmpFile, "%s%c%s%c%s%c%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortNameAux,SLASH,stAuxOptt.nome);
							/* end #36 */
							if (!iidm_em_DO(szPRDTmpFile, &stDummyOptt) && access(szPRDTmpFile,0)) {
								st = iidm_inserir_opt (szPRDTmpFile, stAuxOptt);
								if (st) {
#ifdef WINDOWS
									if (wFlag & EDIDM_ONLYPAINT)
										SINT_dispatch_par_is(0L);
#endif
									return EEIDM_NEWFILEPGS;
								}
							}
                            else {
#ifdef WINDOWS
								if (wFlag & EDIDM_ONLYPAINT)
									SINT_dispatch_par_is(0L);
#endif
								return EEIDM_NEWFILEPGS;
							}
						}
					}
                }

				st = OPC_LoadOfile (pszFileToLoad, (inf_opt.isPRD ? szPRDBDTFile : NULL),
									NULL, 0, NULL, NULL,
									ficha, &tamficha,	&LVInf_ContVerSt,
									PVInf_ContVerSt, pstTrfIOCtrl);

				tries--;
				if (st == TIME_ERR && tries > 0) {
					st = iidm_init_optidoc(phOpt);
					if (st){
						if ( NewFileName_aux[0] == '\0' )
							iidm_unlock_regist(&inf_ogd, szFileLongName);
						break;
					}
				}
				else  {
					if ( !st && NewFileName_aux[0] == '\0' ) {
						iidm_get_atrib_from_ficha(ficha, &fstat);
						inf_opt.ind_VR = PVInf_ContVerSt.index ; ;
						strcpy(inf_opt.nom_DO_VR ,PVInf_ContVerSt.disco) ;
						inf_opt.filestat_VR = fstat ;
						iidm_alterar_opt_ogd(&inf_ogd, szFileLongName, inf_opt );
                    }
					break;
				}   

			}
			else { /* NOT VERSION */

				if ( NewFileName_aux[0] == '\0' ) {
					if (iidm_lock_regist(&inf_ogd, szFileLongName) == EIDM_LOCKOPTAB) {
						iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
						if (wFlag & EDIDM_ONLYPAINT)
							SINT_dispatch_par_is(0L);
#endif
						return EIDM_LOCKOPTAB ;
					}

					if (versao /*<= 0  pjt 4-8-96 seems to be wrong */) {
						if (access(szFileLongName,00) == 0 ) {
							iidm_unlock_regist(&inf_ogd, szFileLongName);
							iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return EJAEMARQ;
						} 
					}
				}
				else
					pszFileToLoad = NewFileName_aux;  /* pjt 6-8-96 achei que estava mal */

#ifdef WINDOWS
				if (inf_opt.isPRD == EDIDM_PRD_PARTIAL && inf_opt.status != S_DO) {
					fdAux = open(pszFileToLoad, O_RDONLY | O_BINARY);
					dwCurrentOffsetInTmp = ((unsigned long) filelength(fdAux));
					close(fdAux);
					st = OPC_LoadOfile (pszFileToLoad, NULL, pwBlockList, wNBlocks, NULL, NULL, ficha, &tamficha, &LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);
                }
				else {
#endif
					/*//TRACE//MessageBox(NULL,"Calling Load","DEBUG",MB_OKCANCEL|MB_ICONEXCLAMATION);
					if (versao)
						st = OPC_LoadOfile (pszFileToLoad, szPRDBDTFile, pwBlockList, wNBlocks, &pstAssocFileList, &wNAssocFiles, ficha, &tamficha, &LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);
                    else*/

					if (inf_opt.isPRD)
						st = OPC_LoadOfile (pszFileToLoad, szPRDBDTFile, pwBlockList, wNBlocks, NULL, NULL, ficha, &tamficha, &LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);
                    else
						st = OPC_LoadOfile (pszFileToLoad, NULL, NULL, 0, NULL, NULL, ficha, &tamficha, &LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);
#ifdef WINDOWS
                }
#endif

				tries--;
				if (st == TIME_ERR && tries > 0) {
					st = iidm_init_optidoc(phOpt);
					if (st) {
						if ( NewFileName_aux[0] == '\0' ) 
							iidm_unlock_regist(&inf_ogd, szFileLongName);
						break;
					}
				}
				else {
					iidm_get_atrib_from_ficha(ficha, &fstat);
					inf_opt.ind_VR = PVInf_ContVerSt.index ; ;
					strcpy(inf_opt.nom_DO_VR ,PVInf_ContVerSt.disco) ;
					inf_opt.filestat_VR = fstat ;
					iidm_alterar_opt_ogd(&inf_ogd, szFileLongName, inf_opt );
					break;
				}
			}
		}

        /* pjt 12/11/96 */
		if ((st == 0 && NewFileName_aux[0] == '\0') || (NewFileName_aux[0] && inf_opt.isPRD)) {
			if (NewFileName_aux[0] && inf_opt.isPRD) {
				iidm_fechar_opt(&inf_ogd);
				iidm_new_PRD_entry(NewFileName_aux);
				iidm_open_optab(&inf_ogd,szOptabname, "r+b");
			}

			/* Passa a ser admitida ficha vazia. Os ficheiros ficam como foram carregados. */
			if (tamficha) {

				if (!(NewFileName_aux[0] && inf_opt.isPRD)) 
					iidm_alterar_status_ogd (&inf_ogd, szFileLongName, S_DOARQ);

				if (wNBlocks > 0) { 
					iidm_set_prd_ogd (&inf_ogd, szFileLongName, EDIDM_PRD_PARTIAL);
					if (inf_opt.isPRD == EDIDM_PRD_PARTIAL) {
						strcpy(pstBDTCtrl->szBDTFileName,szPRDBDTFile);
						strcpy(pstBDTCtrl->szBDTMode,"r+b");
						res = ibdt_open (pstBDTCtrl);
    					if (res == 0) {
					      for (wAskedInd=0; wAskedInd<wNBlocks; wAskedInd++) {
							res = ibdt_read_nth_record (pstBDTCtrl, pwBlockList[wAskedInd], pstBDTRec);
							if (res) {
								ibdt_close (pstBDTCtrl);
								break;
                            }
							stBDTRec.dwOffsetInTmp = dwCurrentOffsetInTmp;
							stBDTRec.wStatus = 0;
							stBDTRec.dwLenInTmp = stBDTRec.dwBlockLen;
							/* //stBDTRec.wOldBlock  = wAskedInd+1; */
							/* //fseek(pstBDTCtrl->fp, ((long) (-sizeof(ESBDT_Record))), SEEK_CUR); */
							res = ibdt_write_nth_record (pstBDTCtrl, pwBlockList[wAskedInd], pstBDTRec);
							if (res) {
								ibdt_close (pstBDTCtrl);
								break;
                            }
							dwCurrentOffsetInTmp += stBDTRec.dwBlockLen;
							/*ibdt_regist_block (pstBDTCtrl, stBDTRec.dwBlockLen);*/
                          }
						  ibdt_close (pstBDTCtrl);
						}
					}
				}
				else if (inf_opt.isPRD) {
				  iidm_set_prd_ogd (&inf_ogd, szFileLongName, EDIDM_PRD_COMPLETE);
                  /* pjt 25/11/96 #35 --------------------------------- */
				  if (NewFileName_aux[0]) {
					strcpy(pstBDTCtrl->szBDTFileName,szPRDBDTFile);
					strcpy(pstBDTCtrl->szBDTMode,"r+b");
					res = ibdt_open (pstBDTCtrl);
   					if (res == 0) {
					     pstBDTCtrl->stHeader.dwTotalDataChanged = 0L;
					     for (i=0; i<pstBDTCtrl->stHeader.wNBlocks; i++) {
							res = ibdt_read_nth_record (pstBDTCtrl, i, pstBDTRec);
							if (res) {
								ibdt_close (pstBDTCtrl);
								break;
                            }
							pstBDTCtrl->stHeader.dwTotalDataChanged += pstBDTRec->dwBlockLen;
							pstBDTRec->wStatus |= EDBDT_CHANGED;
							res = ibdt_write_nth_record (pstBDTCtrl, i, pstBDTRec);
							if (res) {
								ibdt_close (pstBDTCtrl);
								break;
                            }
						 }
						 pstBDTCtrl->stHeader.wNBlocksChanged = pstBDTCtrl->stHeader.wNBlocks;
						 ibdt_close (pstBDTCtrl);
					}
                  }
				  /* end ------------ pjt 25/11/96 #35 --------------------------------- */
				}

				iidm_get_atrib_from_ficha(ficha, &fstat);
				pstat = &fstat;

//				if (!(NewFileName_aux[0] && inf_opt.isPRD)) {
#if !defined(MSDOS) && !defined(WIN32)                                              
				chmod(pszFileToLoad, (mode_t)pstat->mode);
				if (pstat->env == IDM_AMB_UNIX) 
					chown(pszFileToLoad, pstat->uid, pstat->gid);
#else
				chmod(pszFileToLoad, (int)pstat->mode);
#endif
				tempos.actime  = pstat->atime;
				tempos.modtime = pstat->mtime;
				utime(pszFileToLoad, &tempos);
				iidm_n_atributos(pszFileToLoad, &auxstat);
                /* Sera' que nao deve ser cortado para todas as sits de versoes ???  para as de newfilename */
				if (!(NewFileName_aux[0] && inf_opt.isPRD)) 
					res = iidm_alterar_ltime_ogd (&inf_ogd, szFileLongName, auxstat.mtime);
				iidm_unlock_regist(&inf_ogd, szFileLongName);

#ifdef WINDOWS
				if (inf_opt.isPRD && (wFlag&EDIDM_LOADSUBFILES) &&
									!(NewFileName_aux[0] && inf_opt.isPRD)) {

					char *pszFileList[256];
                    int   nFiles;

					/* pjt 27/11/96 #36 */
					if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
						sprintf (szPRDTmpFile, "%s%s%c%s%c*.TIF",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH);
					else
						sprintf (szPRDTmpFile, "%s%c%s%c%s%c*.TIF",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH);
					/* end #36 */
					if (IDM_FindFirst(szPRDTmpFile, &st, &stFfblk, 0, &inf_opt) != 0) {
						iidm_fechar_opt(&inf_ogd);
						return(0);
                    }
	                /* We don't care about this error. It must not be declared error because of S_OPT files */
					nFiles = 0;
					done=0;
					for (i=0; done==0; i++) {
						/* res = iidm_load_file (phOpt, szFileLongName, NULL, 0, 0,  "", NULL, 0, 0, pstIOCtrl);
						if (res) {
							iidm_fechar_opt(&inf_ogd);
							return(res);
                        }*/
						pszFileList[nFiles] = (char *) malloc(OMAXFILENAME+1);
						if (pszFileList[nFiles] == NULL) {
                        	IDM_FindClose(0);
							return EALOCAR;
                        }
						if (st == S_DO)
							strcpy(pszFileList[nFiles], inf_opt.nome);
						else
							strcpy(pszFileList[nFiles], stFfblk.ff_name);
						nFiles++;
						done = IDM_FindNext(&st, &stFfblk, &inf_opt);
					}
                   	IDM_FindClose(0);

					stIOCtrlAux = *pstIOCtrl;
					stIOCtrlAux.stOPCIOCtl.printfunc = NULL;

					for (i=0; i<nFiles; i++) {
/*//TRACEMessageBox(NULL,"Calling printfunc","DEBUG",MB_OKCANCEL|MB_ICONEXCLAMATION);*/
						if (pstIOCtrl->stOPCIOCtl.printfunc)
							(*pstIOCtrl->stOPCIOCtl.printfunc)(EDIDM_IOMSG_03, pszFileList[i]);
						/* pjt 27/11/96 #36 */
						if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
							sprintf(szFileLongName, "%s%s%c%s%c%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH,pszFileList[i]);
						else
							sprintf(szFileLongName, "%s%c%s%c%s%c%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH,pszFileList[i]);
						/* end #36 */
						res = iidm_load_file (phOpt, szFileLongName, NULL, 0, 0,  "", NULL, 0, 0, &stIOCtrlAux);
						free(pszFileList[i]);
						if (res) {
							iidm_fechar_opt(&inf_ogd);
							return(res);
						}
                    }


				}
#endif
			}
			iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
			if (wFlag & EDIDM_ONLYPAINT)
				SINT_dispatch_par_is(0L);
#endif
			return 0;
		}
		else {
			iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
			if (wFlag & EDIDM_ONLYPAINT)
				SINT_dispatch_par_is(0L);
#endif
			return st;
		}
	}
	else {
		iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return EEIDM_DOARQX;
	}

}











void WriteLogEX(LPCSTR message)
{
 	FILE *fp = fopen("c:\\optabDll.log","at");
   fwrite(message, strlen(message),1,fp);
   fputc('\n',fp);
   fclose(fp);
}








const long MAX_COLLECTION = 1000;
opt_t *aOptabFiles=NULL;
long OptabFilesCount=0;


extern "C" long far pascal _export GetPAthFilesCount()
{
	if (OptabFilesCount>0)
	 	return OptabFilesCount;
   else
   	return 0;

}


// Returns empty string if no file found in collection
extern "C" LPCSTR far pascal _export GetFileDO(long index)
{
   char NameDO[5000];

   // Se for ultrapassado o tamanho máximo do array
   if (index > OptabFilesCount)
   {
   	 strcpy(NameDO, "\0");
       return strdup(NameDO);
   }
   else if (OptabFilesCount > 0)
   {
      char strIndex[50];
	   ltoa(index,strIndex,10);
      WriteLogEX(strIndex);
      WriteLogEX(aOptabFiles[index].nom_DO);
   	strcpy(NameDO, aOptabFiles[index].nom_DO);
   }
   else
   {
   	strcpy(NameDO, "\0");
   }
 	return strdup(NameDO);
}



// Returns empty string if no file found in collection
extern "C" LPCSTR far pascal _export GetFile(long index)
{
   char FileName[3000];
   // Se for ultrapassado o tamanho máximo do array
   if (index > OptabFilesCount)
   {
   	 strcpy(FileName, "\0");
       return strdup(FileName);
   }
   else  if (OptabFilesCount > 0)
   {
   	strcpy(FileName, aOptabFiles[index].nome);
   }
   else
   {
   	strcpy(FileName, "\0");
   }

 	return strdup(FileName);
}





// Caminho: E:\2001\Entradas\1_Jan\12\*.*
// Se retornar valor >1 => há erro. Retorna código de erro optidoc.
extern "C" int far pascal _export GetPathFiles(char *Caminho)
{
	int i = 0,done = 0;
	int doctype;
   opt_t Optinfo;
   int iResult = 0;
	struct ffblk StrFich;
   long ArrayUpperBound = 0;

	OptabFilesCount = 0;
   if (aOptabFiles != NULL)
   {
   	free(aOptabFiles);
   }

   aOptabFiles = (opt_t *) malloc(sizeof(opt_t)* MAX_COLLECTION);

	if ((iResult = IDM_FindFirst(Caminho, &doctype, &StrFich, 0, &Optinfo)) != 0)
	{
        if (iResult != 1)
        {
           IDM_FindClose(0);
           return iResult;
        }
        else
        {
	        	aOptabFiles[0] = Optinfo;
				OptabFilesCount++;
        }
	}
	else // Há mais ficheiros
	{
	   ArrayUpperBound = MAX_COLLECTION;
		for (i = 0 ; done == 0  ;i++)
		{
   		aOptabFiles[i] = Optinfo;
			OptabFilesCount++;
	   	if (OptabFilesCount == ArrayUpperBound)
   	   {
            ArrayUpperBound += MAX_COLLECTION;
			   aOptabFiles = (opt_t *) realloc(aOptabFiles, ArrayUpperBound * sizeof(opt_t));

      	}
			done = IDM_FindNext (&doctype, &StrFich, &Optinfo);
		} // for
	} // else


   IDM_FindClose(0);

   return iResult;
}







/* -------------------------- Directories ---------------------------------- */
ffblk *aOptabDirectories;
long OptabDirectoriesCount=0;

extern "C" long far pascal _export GetDirectoriesCount()
{
	if (OptabDirectoriesCount>0)
	 	return OptabDirectoriesCount;
   else
   	return 0;
}


// Returns empty string if no file found in collection
extern "C" LPCSTR far pascal _export GetDirectoryName(long index)
{
   char DirectoryName[300];
   if (OptabDirectoriesCount > 0)
   {
   	strcpy(DirectoryName, aOptabDirectories[index].ff_name);
   }
   else
   {
   	strcpy(DirectoryName, "\0");
   }
 	return strdup(DirectoryName);
}

// Caminho: E:\2001\Entradas\1_Jan\12\*.*
extern "C" int far pascal _export GetPathDirectory(char *Caminho)
{
	int i = 0,done = 0;
	int doctype;
   opt_t Infopt;
	struct ffblk StrFich;
   long ArrayUpperBound = 0;


	OptabDirectoriesCount = 0;
   aOptabDirectories = (ffblk *) malloc(sizeof(ffblk)* MAX_COLLECTION);

if ((done = IDM_FindFirst(Caminho, &doctype, &StrFich, 80, &Infopt)) != 0)
{
        if (done == -1)
        {
        	  // nothing found...
           // OAP_ErrOptidoc (HWindow, iResult);
           return done;
        }
        else
        {
            if(StrFich.ff_name[0] != '.')
	   	   {
 		   	  	aOptabDirectories[OptabDirectoriesCount] = StrFich;
					OptabDirectoriesCount++;
		      }
        }
}
else
{
	ArrayUpperBound = MAX_COLLECTION;
	for (i = 0 ; done == 0  ;i++)
	{
     	if ( OptabDirectoriesCount == ArrayUpperBound)
      {
            ArrayUpperBound += MAX_COLLECTION;
			   aOptabDirectories = (ffblk *) realloc(aOptabDirectories, ArrayUpperBound * sizeof(ffblk));
      }


      if(StrFich.ff_name[0] != '.')
      {
 	     	aOptabDirectories[OptabDirectoriesCount] = StrFich;
			OptabDirectoriesCount++;
      }

       if (!done)
       {
       		while(((done = IDM_FindNext(&doctype,&StrFich, &Infopt)) == 0) &&
				(((StrFich.ff_attrib & 0x10 )!= 0x10) ||
				(StrFich.ff_name[0] == '.')));
       }
   } // for
} // else

   IDM_FindClose(80);
}



































#define DOAP_RO_IFPRDNOLOAD   	4 /* Se PRD, vem só pag. 0 */
/*--------------------------------------------------------------------
|
| Funcao   :  OAP_RecuperaOpticoEx
|
| Descricao:  Recupera um ficheiro do disco optico dado o seu nome
|
| Chamadas :  IDM_RecuperaExterior
|
+---------------------------------------------------------------------*/

int hOptHandle=EDIDM_OPTSTART;
extern "C" int far pascal _export OAP_RecuperaOpticoEx(char * Nome_Ficheiro, char *Path_Ficheiro, char *Path_Nome_Ficheiro, int flag)
{
int  ret=0, res_dlg;
char NewFileName[OMAXPATHNAME+1] ;
char szAuxFileName[OMAXPATHNAME+1] ;
char szFileShortName[OMAXFILENAME+1] ;
char pathdoc[OMAXPATHNAME+1] ;
int  versao=0,stinfo;

char szErrorMessage[1000] ;

HWND Hwin;
struct stat  	 filestat;
opt_t        	 info ;
unsigned short   wInitialBlocks[2]={0,1};
char				 *szLoadName = NULL;
bool bLoadPages = false;
char nome_fich[OMAXPATHNAME];


struct ind_versao    *inf_versao = NULL;
int             	 numero_versao /*= 0*/;



	strcpy(nome_fich, Nome_Ficheiro);

	/*------  pjc 18-05-95  Controlo de versoes ----------------*/
	stinfo = IDM_GetOptInfo(Path_Nome_Ficheiro, &info);
	if ( stinfo == 0 )  {
		if (stat(Path_Nome_Ficheiro,&filestat) == 0 ) {
			IDM_AcertaArqx(Path_Nome_Ficheiro, info);
		}
	}

	if ( flag & DOAP_RO_VERSIONS )  {
		if ( IDM_GetOptInfo(Path_Nome_Ficheiro, &info) != ENAOEMMEIO ) {
			if (info.ult_versao == 0)
				info.ult_versao ++ ;
			versao = info.ult_versao ;
		}
		else
			versao = 0;
      NewFileName[0] = '\0' ;
	}
	else
		NewFileName[0] = '\0' ;


	if (hOptHandle != EDIDM_OPTSTART)
   {
	    ret = IDM_InitOptidoc(&hOptHandle);
       if (ret) {
	    	return (int)ret;
       }
   }
	szLoadName = Path_Nome_Ficheiro;

	if ( (flag & DOAP_RO_IFPRDNOLOAD) && info.isPRD && info.status == S_DO)
   {
	   ret = IDM_RecuperaExterior (&hOptHandle, szLoadName, wInitialBlocks, 2, versao, NewFileName, inf_versao, numero_versao, 0, NULL);
	}
	else
   {
     	ret = IDM_RecuperaExterior (&hOptHandle, szLoadName, NULL, 0, versao, NewFileName, inf_versao, numero_versao, (bLoadPages ? EDIDM_LOADSUBFILES : 0), NULL);
   }

   if (inf_versao != NULL)
   	free(inf_versao);

   if (inf_versao != NULL)
   	free(szLoadName);

	if (ret == CLIENTABORT)
   {
        ret = (int)-1;
	}
	else if (ret) {
	}

	return (int)ret;
}












































/*+---------------------------------------------------------------------------+
|    Function : iidm_load_fileEx
+-----------------------------------------------------------------------------+
|
|    Description:  Loads from an external document server a given file,
|                  updating the local structures optab
|                  For PRD's the load must be total for old versions
|
|    Parameters (in ):  wFlag - 0 if normal
|                               EDIDM_LOADSUBFILES  <-.
|								EDIDM_ONLYPAINT		<-´cannot be used together
|               (out):
|
|    Return:  An Optidoc error code
|
+----------------------------------------------------------------------------*/
int
#ifndef OLD_CSTYLE
//iidm_load_fileEx (int *phOpt, char *szFileName, unsigned short *pwBlockList, unsigned short wNBlocks, int versao, char *NewFileName, Pind_versao inf_versao, int min_versao, unsigned short wFlag, ESIDM_IOControl *pstIOCtrl)
iidm_load_fileEx (char *szFileName, int versao, Pind_versao inf_versao, int min_versao, unsigned short wFlag, ESIDM_IOControl *pstIOCtrl)
#else
iidm_load_fileEx (szFileName, versao, inf_versao, min_versao, wFlag, pstIOCtrl)
char			*szFileName;
int 			 versao;
Pind_versao 	 inf_versao;
int 			 min_versao;
unsigned short	 wFlag;
ESIDM_IOControl *pstIOCtrl;
#endif
{

int *phOpt;
unsigned short	*pwBlockList;
unsigned short   wNBlocks;
//char 			*NewFileName;
char NewFileName[OMAXPATHNAME+1];

	opt_t    inf_opt, stAuxOptt, stDummyOptt;
	char     szFileShortName[OMAXFILENAME+1],szFileShortNameAux[OMAXFILENAME+1],
			 szFileLongName[OMAXPATHNAME+1],
			 szOptabname[OMAXPATHNAME+1],
			 NewFileName_aux[OMAXPATHNAME+1];
	char	 szPRDBDTFile[OMAXPATHNAME+1];
	char     szPRDTmpFile[2*OMAXPATHNAME+1];
    char	*pszFileToLoad;
	char	 szFileDirName[OMAXPATHNAME+1];
	char	 szAux[OMAXFILENAME+1], *p;
	int      res, st, tries;
	char     ficha[MAXFICHA];
	unsigned int 	tamficha;
	struct utimbuf 	tempos;
	long     		index;
	NATRIB_STRUCT  *pstat, fstat, auxstat;
	int      		res_dlg;
	ogd_t    	   	inf_ogd;
#ifdef WINDOWS
	struct ffblk   	stFfblk;
#endif
	int            	done,i;
	int			    fdAux;
	unsigned long	dwCurrentOffsetInTmp;
	ESBDT_Record 	stBDTRec, *pstBDTRec=&stBDTRec;
	ESBDT_Control 	stBDTCtrl, *pstBDTCtrl=&stBDTCtrl;
	unsigned short  wAskedInd,wBlock;
	ContVerSt	   *pstAssocFileList;
    unsigned short  wNAssocFiles;
	ESOPC_IOControl *pstTrfIOCtrl;
	ESIDM_IOControl stIOCtrlAux;
	ContVerSt       LVInf_ContVerSt ;


  	strcpy(NewFileName, szFileName );

	tamficha = MAXFICHA;
	res = iidm_init_optidoc(phOpt);
	if (res != OK)
		return res;

	if (pstIOCtrl == NULL) {
		pstIOCtrl = &stIDMNullIO;
		pstTrfIOCtrl = NULL;
	}
	else {
		pstTrfIOCtrl = &(pstIOCtrl->stOPCIOCtl);
    }

/* pjt 12/11/96 */
#ifdef WINDOWS
	if (wFlag & EDIDM_ONLYPAINT)
		SINT_dispatch_par_is(1L);
#endif

	strcpy(NewFileName_aux, NewFileName );
	if (NewFileName[0])
		GEN_SplitPath(NewFileName, szFileDirName, szFileShortNameAux);

	GEN_SplitPath(szFileName, szFileDirName, szFileShortName);
	/* pjt 27/11/96 #36 */
	if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
		sprintf (szOptabname, "%s%s", szFileDirName, OPTTABNAME);
	else
		sprintf (szOptabname, "%s%c%s", szFileDirName, SLASH, OPTTABNAME);
	/* end #36 */
	strcpy (szAux, szFileShortName);
	p = strrchr(szAux, '.');
	if (p)
		*p='\0';

	if (!iidm_file_access ( szOptabname, 02 ) ) {
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return EPRIVILEGIOS;
	}
	iidm_getpath(szFileName,szFileLongName);
    /* Char pointer to use as argument to OPC_Load */
	pszFileToLoad = szFileLongName;

	res = iidm_open_optab(&inf_ogd,szOptabname, "r+b");
	if (res != OK) {
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return res;
	}

	if (!iidm_em_DO_ogd (&inf_ogd, szFileLongName, &inf_opt) /* only opts */ ) {
		iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return ENAOEMMEIO;
	}

	if (wNBlocks > 0) {
		if (!inf_opt.isPRD) {
			wNBlocks = 0; /* ignore absurd situation - loads complete document */
			/*		return EIDM_DOCNOTPRD;*/
		}
	}

	/* pjt 9/10/96  Nao ha' problema em fazer e versao pode vir > 0
	if (versao > 0 && wFlag & EDIDM_LOADSUBFILES)
		wFlag &= !EDIDM_LOADSUBFILES; */
	/* pjt 9/10/96
	if (inf_opt.status==S_DOARQX && inf_opt.isPRD && versao > 0)
		return EEIDM_INVALRECVERS;*/

	/* pjt 14/11/96 #022 inf_opt was out of date; this function refreshes inf_opt */
	if (inf_opt.isPRD)
		/* iidm_acerta_arqx (szFileName, inf_opt); */
		iidm_acerta_arqx_ogd (&inf_ogd, szFileLongName, &inf_opt);
	/* pjt end #022 */

	if (inf_opt.status==S_DOARQX && inf_opt.isPRD /* pjt 17/10/96 */ && versao > 0 /* pjt #025 -> */ && NewFileName[0]=='\0' ) {
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return EEIDM_INVALRECVERS;
	}

	/* pjt 14/11/96 #022 inf_opt was out of date */
	if (inf_opt.status==S_DOARQ && inf_opt.isPRD && versao > 0) {
		iidm_fechar_opt(&inf_ogd);
		iidm_save_file(phOpt, "---", szFileLongName /* #022 wasn't long */, NULL, 0, NULL /* #o22 was Pstioctrl */);
		res = iidm_open_optab(&inf_ogd, szOptabname, "r+b");
		if (res) {
#ifdef WINDOWS
			if (wFlag & EDIDM_ONLYPAINT)
				SINT_dispatch_par_is(0L);
#endif
			return res;
		}
		iidm_em_DO_ogd (&inf_ogd, szFileLongName, &inf_opt);
	}
	/* pjt end #022 */

    iidm_file_2_bdt(szFileLongName, szPRDBDTFile);
	/* pjt 28/10/998
	if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
		sprintf (szPRDBDTFile, "%s%s%c%s%c%s%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH,szAux,OPTEXTBDT);
	else
		sprintf (szPRDBDTFile, "%s%c%s%c%s%c%s%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH,szAux,OPTEXTBDT);
	/* end #36 */

	if (inf_opt.status == S_DO || inf_opt.status == S_DOARQ || (inf_opt.status == S_DOARQX && NewFileName_aux[0] != '\0')   || (inf_opt.status == S_DOARQX && inf_opt.isPRD == EDIDM_PRD_PARTIAL && versao <= 0) ) {

		tamficha=MAXFICHA;
		index = inf_opt.ind;
		if ( NewFileName_aux[0] != '\0' )  {
			if ( iidm_acesso_doc(NewFileName_aux,00) == 0) {
				iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
				if (wFlag & EDIDM_ONLYPAINT)
					SINT_dispatch_par_is(0L);
#endif
				return EIDM_OLDFNAME;
			}
		}
		/* pjc    31-05-95   tirei para poder recuperar de disco optico para a versao existente em disco magnetico. Desde que nao esteja alterada
		if (inf_opt.isPRD && versao > 0 ) {
		  if (access(szFileLongname,00) == 0 ) {
			iidm_fechar_opt(&inf_ogd);
			return EJAEMARQ;
          }
		}*/
		tries = 2;
		PVInf_ContVerSt.index = index ;
		strcpy(PVInf_ContVerSt.disco, inf_opt.nom_DO );
		inf_opt.ver_actual = inf_opt.ult_versao ;

		if ( versao > 0 && versao < inf_opt.ver_actual ) {
			if ( inf_versao ) {
				if ( versao < min_versao )  {
					inf_opt.ver_actual = min_versao ;
					PVInf_ContVerSt.index = inf_versao[inf_opt.ult_versao - min_versao].index ;
					strcpy(PVInf_ContVerSt.disco, inf_versao[inf_opt.ult_versao - min_versao].disco );
				}
				else {
					inf_opt.ver_actual = versao ;
					PVInf_ContVerSt.index = inf_versao[inf_opt.ult_versao - versao].index ;
					strcpy(PVInf_ContVerSt.disco, inf_versao[inf_opt.ult_versao - versao].disco );
				}
			}
			else {
				PVInf_ContVerSt.index = inf_opt.index_LV ;
				strcpy(PVInf_ContVerSt.disco, inf_opt.nom_DO_LV );
				inf_opt.ver_actual--;
			}
		} 

		if ((inf_opt.status==S_DOARQX || inf_opt.status==S_DOARQ)
				&& inf_opt.isPRD==EDIDM_PRD_PARTIAL	&& wNBlocks==0 ) {
	       	/* When loading versions it should never get here */ 
			strcpy(pstBDTCtrl->szBDTFileName,szPRDBDTFile);
			strcpy(pstBDTCtrl->szBDTMode,"rb");
			res = ibdt_open (pstBDTCtrl);
			if (res) {
#ifdef WINDOWS
				if (wFlag & EDIDM_ONLYPAINT)
					SINT_dispatch_par_is(0L);
#endif
				return res;
			}

            wNBlocks = 0;
			pwBlockList	= NULL;
            wBlock = 0;
			while ((res = ibdt_read_record (pstBDTCtrl, pstBDTRec)) == 0) {
				if ((stBDTRec.wStatus & EDBDT_NOTLOADED) == FALSE ) {
                	wBlock++;
					continue;
                }
				if (pwBlockList == NULL)
					pwBlockList = (unsigned short *) malloc(sizeof(unsigned short));
                else
					pwBlockList = (unsigned short *) realloc(pwBlockList,sizeof(unsigned short)*(wNBlocks+1));
				pwBlockList[wNBlocks++] = wBlock++;
		  }
		  ibdt_close (pstBDTCtrl);
        }

		while (tries) {

            /* Version load management */
			if ( versao > 0 ) {

				if ( versao < inf_opt.ver_actual ) {

				  do {
                	/* Get only header */
					if (inf_opt.isPRD)
						st = OPC_LoadOfile (NULL, NULL, NULL, 0, &pstAssocFileList, &wNAssocFiles,
											ficha, &tamficha,
											&LVInf_ContVerSt, PVInf_ContVerSt, NULL);
					else
						st = OPC_LoadOfile (NULL, NULL, NULL, 0, NULL, NULL,
											ficha, &tamficha,
											&LVInf_ContVerSt, PVInf_ContVerSt, NULL);

					if ( st == TIME_ERR && tries > 0 )  {
						st = iidm_init_optidoc(phOpt);
						if (st)  {
							iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return st;
						}
					}
					else if ( st == DSK_NOT_FOUND || st == NOTFOUND || 
								st == WRONGDSK || st == CHANGED || st == WRONGNAME ) {
						res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_VERSIONS,PVInf_ContVerSt.disco);
						tries--;
						if ( res_dlg == 0 )  {
							iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return CLIENTABORT ;
						}
					}
					else if ( st )  {
						iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
						if (wFlag & EDIDM_ONLYPAINT)
							SINT_dispatch_par_is(0L);
#endif
						return st;
					}
					else    {
						if ( versao < inf_opt.ver_actual )  {
							PVInf_ContVerSt.index = LVInf_ContVerSt.index ;
							strcpy(PVInf_ContVerSt.disco, LVInf_ContVerSt.disco );
						}
						inf_opt.ver_actual--;
					}
				  } while ( versao < inf_opt.ver_actual   && tries > 0) ;
				  tries ++ ;

				} /*if ( versao < inf_opt.ver_actual ) {*/

				if ( NewFileName_aux[0] == '\0' ) {
					if (iidm_lock_regist(&inf_ogd, szFileLongName)==EIDM_LOCKOPTAB) {
						iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
						if (wFlag & EDIDM_ONLYPAINT)
							SINT_dispatch_par_is(0L);
#endif
						return EIDM_LOCKOPTAB ;
					}
				}

                /* PRD VERSION LOAD: */
				if (inf_opt.isPRD) {
					BOOL bAssocsEqual=TRUE;
                    int auxtries=2;

					do {
						st = OPC_LoadOfile (NULL, NULL, NULL, 0, &pstAssocFileList, &wNAssocFiles,
											ficha, &tamficha,
											&LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);

						if ( st == TIME_ERR && auxtries > 0 )  {
							st = iidm_init_optidoc(phOpt);
							if (st)  {
								iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
								if (wFlag & EDIDM_ONLYPAINT)
									SINT_dispatch_par_is(0L);
#endif
								return st;
							}
						}
						else if ( st == DSK_NOT_FOUND || st == NOTFOUND ||
									st == WRONGDSK || st == CHANGED || st == WRONGNAME ) {
                            if (auxtries == 0) {
								iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
								if (wFlag & EDIDM_ONLYPAINT)
									SINT_dispatch_par_is(0L);
#endif
								return st;
							}
							res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_VERSIONS,PVInf_ContVerSt.disco);
							auxtries--;
							if ( res_dlg == 0 )  {
								iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
								if (wFlag & EDIDM_ONLYPAINT)
									SINT_dispatch_par_is(0L);
#endif
								return CLIENTABORT ;
							}
						}
						else if ( st )  {
							iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return st;
						}
						else    {
							/* ok */
                            break;
							/*if ( versao < inf_opt.ver_actual )  {
								PVInf_ContVerSt.index = LVInf_ContVerSt.index ;
								strcpy(PVInf_ContVerSt.disco, LVInf_ContVerSt.disco );
							}
							inf_opt.ver_actual--;*/
						}
					} while ( 1 /*versao < inf_opt.ver_actual   && tries > 0*/ ) ;

					for (i=0; i<wNAssocFiles; i++) {
							/* pjt 27/11/96 #36 */
							if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
								sprintf (szPRDTmpFile, "%s%s%c%s%c%08d.TIF",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH,i+1);
							else
								sprintf (szPRDTmpFile, "%s%c%s%c%s%c%08d.TIF",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH,i+1);
							/* end #36 */
							if (iidm_em_DO(szPRDTmpFile,&stAuxOptt) != 1) {
								bAssocsEqual = FALSE;
								break;
							}
							if (stricmp(stAuxOptt.nom_DO,pstAssocFileList[i].disco) || stAuxOptt.ind != pstAssocFileList[i].index) {
								bAssocsEqual = FALSE;
								break;
							}
					}
                    if (bAssocsEqual) {
							/* pjt 27/11/96 #36 */
							if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
								sprintf (szPRDTmpFile, "%s%s%c%s%c%08d.TIF",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH,i+1);
							else
								sprintf (szPRDTmpFile, "%s%c%s%c%s%c%08d.TIF",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH,i+1);
							/* end #36 */
							if (iidm_em_DO(szPRDTmpFile,&stAuxOptt) == 1)
								bAssocsEqual = FALSE;
					}
					if (!bAssocsEqual ) {
							/* pjt 15/11/96 -> */
							if (NewFileName_aux[0] == '\0') {
								strcpy(szFileShortNameAux,szFileShortName);
								res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_NEWFILENAME,szFileShortNameAux);
								if (res_dlg == FALSE) {
#ifdef WINDOWS
									if (wFlag & EDIDM_ONLYPAINT)
										SINT_dispatch_par_is(0L);
#endif
									return EIDM_OPCANCEL;
								}
								/* pjt 27/11/96 #36 */
								if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
									sprintf (szPRDTmpFile, "%s%s",szFileDirName,szFileShortNameAux);
								else
									sprintf (szPRDTmpFile, "%s%c%s",szFileDirName,SLASH,szFileShortNameAux);
								/* end #36 */
								strcpy (NewFileName_aux,szPRDTmpFile);
								if (iidm_em_DO(NewFileName_aux, &stDummyOptt) || access(NewFileName_aux,0)==0) {
#ifdef WINDOWS
									if (wFlag & EDIDM_ONLYPAINT)
										SINT_dispatch_par_is(0L);
#endif
									return EEIDM_FILEEXISTS;
								}
							}
							strcpy (szAux, szFileShortNameAux);
							p = strrchr(szAux, '.');
							if (p)
								*p='\0';

                        	/* pjt 28/10/998 */
							if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
								sprintf (szPRDBDTFile, "%s%s%c%s%c%s%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortNameAux,SLASH,szAux,OPTBDTNAME);
							else
								sprintf (szPRDBDTFile, "%s%c%s%c%s%c%s%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortNameAux,SLASH,OPTBDTNAME);
					}
				}

				if ( NewFileName_aux[0] != '\0' ) {
					pszFileToLoad = NewFileName_aux;  /* pjt 6-8-96 achei que estava mal */
					if (inf_opt.isPRD) {
						/* pjt 27/11/96 #36 */
						if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
							sprintf (szPRDTmpFile, "%s%s%c%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortNameAux);
						else
							sprintf (szPRDTmpFile, "%s%c%s%c%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortNameAux);
						/* end #36 */

						/* pjt 27/11/96 #37 */
						{
						 char szFullPath[OMAXPATHNAME*2+1];
						 iidm_getpath(szPRDTmpFile, szFullPath);
                         /* pjt 13/11/98 - prever logo comprimento dos fichs das paginas */
						 if (strlen(szFullPath)+1+12 > /*MAXDIR*/MAXPATH-1)
                         /* o teste devera' quando possivel passar a ser feito a ED_MAXFILENAME (eletipo def dependente do sist.oper. */
							return (EEIDM_PGDIRTOOBIG);
                        }
 						/* end #37 */

						if (IDM_Mkdir(szPRDTmpFile)) {
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return EEIDM_MKDIR;
						}


						for (i=0; i<wNAssocFiles; i++) {
							sprintf (stAuxOptt.nome, "%08d.TIF",i+1);
							strcpy (stAuxOptt.nom_DO,pstAssocFileList[i].disco);
							stAuxOptt.ind = pstAssocFileList[i].index;
							stAuxOptt.status = S_DO;
                            /* Verificar bem se se pode fazer isto: */
							stAuxOptt.filestat = inf_opt.filestat;
							stAuxOptt.ult_versao = 1;
							stAuxOptt.isPRD = 0;
							/*st = IDM_SetOptEntry (szPRDTmpFile, stAuxOptt);*/
							/* pjt 27/11/96 #36 */
							if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
								sprintf (szPRDTmpFile, "%s%s%c%s%c%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortNameAux,SLASH,stAuxOptt.nome);
							else
								sprintf (szPRDTmpFile, "%s%c%s%c%s%c%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortNameAux,SLASH,stAuxOptt.nome);
							/* end #36 */
							if (!iidm_em_DO(szPRDTmpFile, &stDummyOptt) && access(szPRDTmpFile,0)) {
								st = iidm_inserir_opt (szPRDTmpFile, stAuxOptt);
								if (st) {
#ifdef WINDOWS
									if (wFlag & EDIDM_ONLYPAINT)
										SINT_dispatch_par_is(0L);
#endif
									return EEIDM_NEWFILEPGS;
								}
							}
                            else {
#ifdef WINDOWS
								if (wFlag & EDIDM_ONLYPAINT)
									SINT_dispatch_par_is(0L);
#endif
								return EEIDM_NEWFILEPGS;
							}
						}
					}
                }

				st = OPC_LoadOfile (pszFileToLoad, (inf_opt.isPRD ? szPRDBDTFile : NULL),
									NULL, 0, NULL, NULL,
									ficha, &tamficha,	&LVInf_ContVerSt,
									PVInf_ContVerSt, pstTrfIOCtrl);

				tries--;
				if (st == TIME_ERR && tries > 0) {
					st = iidm_init_optidoc(phOpt);
					if (st){
						if ( NewFileName_aux[0] == '\0' ) 
							iidm_unlock_regist(&inf_ogd, szFileLongName);
						break;
					}
				}
				else  {
					if ( !st && NewFileName_aux[0] == '\0' ) {
						iidm_get_atrib_from_ficha(ficha, &fstat);
						inf_opt.ind_VR = PVInf_ContVerSt.index ; ;
						strcpy(inf_opt.nom_DO_VR ,PVInf_ContVerSt.disco) ;
						inf_opt.filestat_VR = fstat ;
						iidm_alterar_opt_ogd(&inf_ogd, szFileLongName, inf_opt );
                    }
					break;
				}

			}
			else { /* NOT VERSION */

				if ( NewFileName_aux[0] == '\0' ) {
					if (iidm_lock_regist(&inf_ogd, szFileLongName) == EIDM_LOCKOPTAB) {
						iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
						if (wFlag & EDIDM_ONLYPAINT)
							SINT_dispatch_par_is(0L);
#endif
						return EIDM_LOCKOPTAB ;
					}

					if (versao /*<= 0  pjt 4-8-96 seems to be wrong */) {
						if (access(szFileLongName,00) == 0 ) {
							iidm_unlock_regist(&inf_ogd, szFileLongName);
							iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
							if (wFlag & EDIDM_ONLYPAINT)
								SINT_dispatch_par_is(0L);
#endif
							return EJAEMARQ;
						} 
					}
				}
				else
					pszFileToLoad = NewFileName_aux;  /* pjt 6-8-96 achei que estava mal */

#ifdef WINDOWS
				if (inf_opt.isPRD == EDIDM_PRD_PARTIAL && inf_opt.status != S_DO) {
					fdAux = open(pszFileToLoad, O_RDONLY | O_BINARY);
					dwCurrentOffsetInTmp = ((unsigned long) filelength(fdAux));
					close(fdAux);
					st = OPC_LoadOfile (pszFileToLoad, NULL, pwBlockList, wNBlocks, NULL, NULL, ficha, &tamficha, &LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);
                }
				else {
#endif
					/*//TRACE//MessageBox(NULL,"Calling Load","DEBUG",MB_OKCANCEL|MB_ICONEXCLAMATION);
					if (versao)
						st = OPC_LoadOfile (pszFileToLoad, szPRDBDTFile, pwBlockList, wNBlocks, &pstAssocFileList, &wNAssocFiles, ficha, &tamficha, &LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);
                    else*/

					if (inf_opt.isPRD)
						st = OPC_LoadOfile (pszFileToLoad, szPRDBDTFile, pwBlockList, wNBlocks, NULL, NULL, ficha, &tamficha, &LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);
                    else
						st = OPC_LoadOfile (pszFileToLoad, NULL, NULL, 0, NULL, NULL, ficha, &tamficha, &LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);
#ifdef WINDOWS
                }
#endif

				tries--;
				if (st == TIME_ERR && tries > 0) {
					st = iidm_init_optidoc(phOpt);
					if (st) {
						if ( NewFileName_aux[0] == '\0' ) 
							iidm_unlock_regist(&inf_ogd, szFileLongName);
						break;
					}
				}
				else {
					iidm_get_atrib_from_ficha(ficha, &fstat);
					inf_opt.ind_VR = PVInf_ContVerSt.index ; ;
					strcpy(inf_opt.nom_DO_VR ,PVInf_ContVerSt.disco) ;
					inf_opt.filestat_VR = fstat ;
					iidm_alterar_opt_ogd(&inf_ogd, szFileLongName, inf_opt );
					break;
				}
			}
		}

        /* pjt 12/11/96 */
		if ((st == 0 && NewFileName_aux[0] == '\0') || (NewFileName_aux[0] && inf_opt.isPRD)) {
			if (NewFileName_aux[0] && inf_opt.isPRD) {
				iidm_fechar_opt(&inf_ogd);
				iidm_new_PRD_entry(NewFileName_aux);
				iidm_open_optab(&inf_ogd,szOptabname, "r+b");
			}

			/* Passa a ser admitida ficha vazia. Os ficheiros ficam como foram carregados. */
			if (tamficha) {

				if (!(NewFileName_aux[0] && inf_opt.isPRD)) 
					iidm_alterar_status_ogd (&inf_ogd, szFileLongName, S_DOARQ);

				if (wNBlocks > 0) { 
					iidm_set_prd_ogd (&inf_ogd, szFileLongName, EDIDM_PRD_PARTIAL);
					if (inf_opt.isPRD == EDIDM_PRD_PARTIAL) {
						strcpy(pstBDTCtrl->szBDTFileName,szPRDBDTFile);
						strcpy(pstBDTCtrl->szBDTMode,"r+b");
						res = ibdt_open (pstBDTCtrl);
    					if (res == 0) {
					      for (wAskedInd=0; wAskedInd<wNBlocks; wAskedInd++) {
							res = ibdt_read_nth_record (pstBDTCtrl, pwBlockList[wAskedInd], pstBDTRec);
							if (res) {
								ibdt_close (pstBDTCtrl);
								break;
                            }
							stBDTRec.dwOffsetInTmp = dwCurrentOffsetInTmp;
							stBDTRec.wStatus = 0;
							stBDTRec.dwLenInTmp = stBDTRec.dwBlockLen;
							/* //stBDTRec.wOldBlock  = wAskedInd+1; */
							/* //fseek(pstBDTCtrl->fp, ((long) (-sizeof(ESBDT_Record))), SEEK_CUR); */
							res = ibdt_write_nth_record (pstBDTCtrl, pwBlockList[wAskedInd], pstBDTRec);
							if (res) {
								ibdt_close (pstBDTCtrl);
								break;
                            }
							dwCurrentOffsetInTmp += stBDTRec.dwBlockLen;
							/*ibdt_regist_block (pstBDTCtrl, stBDTRec.dwBlockLen);*/
                          }
						  ibdt_close (pstBDTCtrl);
						}
					}
				}
				else if (inf_opt.isPRD) {
				  iidm_set_prd_ogd (&inf_ogd, szFileLongName, EDIDM_PRD_COMPLETE);
                  /* pjt 25/11/96 #35 --------------------------------- */
				  if (NewFileName_aux[0]) {
					strcpy(pstBDTCtrl->szBDTFileName,szPRDBDTFile);
					strcpy(pstBDTCtrl->szBDTMode,"r+b");
					res = ibdt_open (pstBDTCtrl);
   					if (res == 0) {
					     pstBDTCtrl->stHeader.dwTotalDataChanged = 0L;
					     for (i=0; i<pstBDTCtrl->stHeader.wNBlocks; i++) {
							res = ibdt_read_nth_record (pstBDTCtrl, i, pstBDTRec);
							if (res) {
								ibdt_close (pstBDTCtrl);
								break;
                            }
							pstBDTCtrl->stHeader.dwTotalDataChanged += pstBDTRec->dwBlockLen;
							pstBDTRec->wStatus |= EDBDT_CHANGED;
							res = ibdt_write_nth_record (pstBDTCtrl, i, pstBDTRec);
							if (res) {
								ibdt_close (pstBDTCtrl);
								break;
                            }
						 }
						 pstBDTCtrl->stHeader.wNBlocksChanged = pstBDTCtrl->stHeader.wNBlocks;
						 ibdt_close (pstBDTCtrl);
					}
                  }
				  /* end ------------ pjt 25/11/96 #35 --------------------------------- */
				}

				iidm_get_atrib_from_ficha(ficha, &fstat);
				pstat = &fstat;

//				if (!(NewFileName_aux[0] && inf_opt.isPRD)) {
#if !defined(MSDOS) && !defined(WIN32)                                              
				chmod(pszFileToLoad, (mode_t)pstat->mode);
				if (pstat->env == IDM_AMB_UNIX)
					chown(pszFileToLoad, pstat->uid, pstat->gid);
#else
				chmod(pszFileToLoad, (int)pstat->mode);
#endif
				tempos.actime  = pstat->atime;
				tempos.modtime = pstat->mtime;
				utime(pszFileToLoad, &tempos);
				iidm_n_atributos(pszFileToLoad, &auxstat);
                /* Sera' que nao deve ser cortado para todas as sits de versoes ???  para as de newfilename */
				if (!(NewFileName_aux[0] && inf_opt.isPRD)) 
					res = iidm_alterar_ltime_ogd (&inf_ogd, szFileLongName, auxstat.mtime);
				iidm_unlock_regist(&inf_ogd, szFileLongName);

#ifdef WINDOWS
				if (inf_opt.isPRD && (wFlag&EDIDM_LOADSUBFILES) &&
									!(NewFileName_aux[0] && inf_opt.isPRD)) {

					char *pszFileList[256];
                    int   nFiles;

					/* pjt 27/11/96 #36 */
					if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
						sprintf (szPRDTmpFile, "%s%s%c%s%c*.TIF",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH);
					else
						sprintf (szPRDTmpFile, "%s%c%s%c%s%c*.TIF",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH);
					/* end #36 */
					if (IDM_FindFirst(szPRDTmpFile, &st, &stFfblk, 0, &inf_opt) != 0) {
						iidm_fechar_opt(&inf_ogd);
						return(0);
                    }
	                /* We don't care about this error. It must not be declared error because of S_OPT files */
					nFiles = 0;
					done=0;
					for (i=0; done==0; i++) {
						/* res = iidm_load_file (phOpt, szFileLongName, NULL, 0, 0,  "", NULL, 0, 0, pstIOCtrl);
						if (res) { 
							iidm_fechar_opt(&inf_ogd);
							return(res);
                        }*/
						pszFileList[nFiles] = (char *) malloc(OMAXFILENAME+1);
						if (pszFileList[nFiles] == NULL) {
                        	IDM_FindClose(0);
							return EALOCAR;
                        }
						if (st == S_DO)
							strcpy(pszFileList[nFiles], inf_opt.nome);
						else
							strcpy(pszFileList[nFiles], stFfblk.ff_name);
						nFiles++;
						done = IDM_FindNext(&st, &stFfblk, &inf_opt);
					}
                   	IDM_FindClose(0);

					stIOCtrlAux = *pstIOCtrl;
					stIOCtrlAux.stOPCIOCtl.printfunc = NULL;

					for (i=0; i<nFiles; i++) {
/*//TRACEMessageBox(NULL,"Calling printfunc","DEBUG",MB_OKCANCEL|MB_ICONEXCLAMATION);*/
						if (pstIOCtrl->stOPCIOCtl.printfunc)
							(*pstIOCtrl->stOPCIOCtl.printfunc)(EDIDM_IOMSG_03, pszFileList[i]);
						/* pjt 27/11/96 #36 */
						if (szFileDirName[strlen(szFileDirName)-1] == SLASH)
							sprintf(szFileLongName, "%s%s%c%s%c%s",szFileDirName,OPTDIRNAME,SLASH,szFileShortName,SLASH,pszFileList[i]);
						else
							sprintf(szFileLongName, "%s%c%s%c%s%c%s",szFileDirName,SLASH,OPTDIRNAME,SLASH,szFileShortName,SLASH,pszFileList[i]);
						/* end #36 */
						res = iidm_load_file (phOpt, szFileLongName, NULL, 0, 0,  "", NULL, 0, 0, &stIOCtrlAux);
						free(pszFileList[i]);
						if (res) {
							iidm_fechar_opt(&inf_ogd);
							return(res);
						}
                    }


				}
#endif
			}
			iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
			if (wFlag & EDIDM_ONLYPAINT)
				SINT_dispatch_par_is(0L);
#endif
			return 0;
		}
		else {
			iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
			if (wFlag & EDIDM_ONLYPAINT)
				SINT_dispatch_par_is(0L);
#endif
			return st;
		}
	}
	else {
		iidm_fechar_opt(&inf_ogd);
#ifdef WINDOWS
		if (wFlag & EDIDM_ONLYPAINT)
			SINT_dispatch_par_is(0L);
#endif
		return EEIDM_DOARQX;
	}

}












/*+---------------------------------------------------------------------------+
|    Rotina : IDM_LerFichaExterior
+-----------------------------------------------------------------------------+
|
|    Descricao:
|
|    Parametros (Entrada)   :  tipo : 1 - fichaplic
|                                     2 - stat
|                                     3 - stat + fichaplic
|               (Saida)     :
|
|    Retorna :
|
|   SO' E' USADA NO CLASSICO
|
+----------------------------------------------------------------------------*/
#ifdef WINDOWS
extern "C" int far pascal _export IDM_LerFichaExterior (int   *phOpt,
											 char  *szFileName,
											 int    tipo,
											 char  *fichaplic,
											 int   *tamfichaplic,
											 opt_t *popt_inf,
											 int    versao,
											 Pind_versao      inf_versao,
											 int             *min_versao,
											 int             *flag_inf,
											 ESIDM_IOControl *pstIOCtrl)
#else
int IDM_LerFichaExterior (phOpt, szFileName, tipo, fichaplic, tamfichaplic, popt_inf, versao, inf_versao, min_versao, flag_inf, pstIOCtrl)
int     *phOpt;
char    *szFileName;
int      tipo;
char    *fichaplic;           /* A aplicacao tem o array da sua ficha */
int     *tamfichaplic;
opt_t   *popt_inf;         /* A aplicacao tem a struct */
int      versao;
Pind_versao      inf_versao ;
int             *min_versao ;
int             *flag_inf ;
ESIDM_IOControl *pstIOCtrl;
#endif
{
ContVerSt       LVInf_ContVerSt ;
char      pfich[OMAXPATHNAME+1];
unsigned  int  tamficha;
char      ficha[MAXFICHA];
opt_t     inf_opt;
int       len_aux;
int       PathFileSize;
int       res, st, tries, res_dlg;

	/* tamficha deve ficar com o maximo suportado, para passar isso `a optlib */
	tamficha = MAXFICHA;

#ifdef WINDOWS
	if (DLL_ocupada==1)
		return(EDLL_BUSY);
	 else
		DLL_ocupada=1;
#endif

	res = iidm_init_optidoc(phOpt);
	if (res != OK) {
		DLL_ocupada=0;
		return res;
	}

	if (pstIOCtrl == NULL)
		pstIOCtrl = &stIDMNullIO;

	iidm_getpath(szFileName,pfich);
	if (iidm_em_DO (pfich, &inf_opt) ) {

	  PVInf_ContVerSt.index = inf_opt.ind ;
	  strcpy(PVInf_ContVerSt.disco, inf_opt.nom_DO );
	  if ( inf_versao ) {
		inf_versao[0].index = PVInf_ContVerSt.index ;
		strcpy(inf_versao[0].disco, inf_opt.nom_DO );
	  }
	  inf_opt.ver_actual = inf_opt.ult_versao ;

	  if ( versao > 0 && versao < inf_opt.ver_actual ) {
		if ( inf_versao && *flag_inf == TRUE) {
			if ( versao < *min_versao )  {
				inf_opt.ver_actual = *min_versao ;
				PVInf_ContVerSt.index = inf_versao[inf_opt.ult_versao - *min_versao].index ;
				strcpy(PVInf_ContVerSt.disco, inf_versao[inf_opt.ult_versao - *min_versao].disco );
			}
			else {
				inf_opt.ver_actual = versao ;
				PVInf_ContVerSt.index = inf_versao[inf_opt.ult_versao - versao].index ;
				strcpy(PVInf_ContVerSt.disco, inf_versao[inf_opt.ult_versao - versao].disco );
			}
		 }
		 else {
			PVInf_ContVerSt.index = inf_opt.index_LV ;
			strcpy(PVInf_ContVerSt.disco, inf_opt.nom_DO_LV );
			inf_opt.ver_actual --;
			if ( inf_versao ) {
				*flag_inf = TRUE ;
				inf_versao[inf_opt.ult_versao - inf_opt.ver_actual].index = PVInf_ContVerSt.index ;
				strcpy(inf_versao[inf_opt.ult_versao - inf_opt.ver_actual].disco,PVInf_ContVerSt.disco );
				*min_versao = inf_opt.ver_actual ;
			}
		 }
	  }

	  /* PJT 20-09-94 Como nivel opclient valida users, acusa os resets do servidor.
							Este ciclo e' para recuperar UMA vez dessa situacao */
	  tries = 2;
	  while (tries) {

			if ( versao > 0 && versao < inf_opt.ver_actual ) {

				do   {
					st = OPC_LoadOfile (NULL, NULL, NULL, 0, NULL,NULL,ficha, &tamficha, &LVInf_ContVerSt, PVInf_ContVerSt, NULL/*no output*/);
					if ( st == TIME_ERR && tries > 0 )  {
						st = iidm_init_optidoc(phOpt);
						if (st)  {
							DLL_ocupada=0;
							return st;
						}
					}

					else if ( st == DSK_NOT_FOUND || st == NOTFOUND || st == WRONGDSK || st == CHANGED || st == WRONGNAME ) {
						res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_VERSIONS,PVInf_ContVerSt.disco);
						tries--;
						if ( res_dlg == 0 )  {
							DLL_ocupada=0;
							return CLIENTABORT ;
						}
					}
					else if ( st )  {
						DLL_ocupada=0;
						return st;
					}
					else    {
						if ( inf_versao ) {
							*flag_inf = TRUE ;
							inf_versao[inf_opt.ult_versao - inf_opt.ver_actual].index = PVInf_ContVerSt.index ;
							strcpy(inf_versao[inf_opt.ult_versao - inf_opt.ver_actual].disco,PVInf_ContVerSt.disco );
							*min_versao = inf_opt.ver_actual ;
						}

						if ( versao < inf_opt.ver_actual ) {
							PVInf_ContVerSt.index = LVInf_ContVerSt.index ;
							strcpy(PVInf_ContVerSt.disco, LVInf_ContVerSt.disco );
						}
						inf_opt.ver_actual--;
					}

				} while ( versao <= inf_opt.ver_actual  && tries > 0) ;
				break;
			}
			else {  
				/* Saca ficha mesmo se tb em DM */
				st=OPC_LoadOfile (NULL, NULL, NULL, 0, NULL,NULL,ficha, &tamficha,  &LVInf_ContVerSt, PVInf_ContVerSt, NULL);
				tries--;
				if (st == TIME_ERR && tries > 0) {
					st = iidm_init_optidoc(phOpt);
					if (st)
						break;
				}
				else
					break;
			}
	  }
	  if (st == 0) {
		 /* neste caso ficha recebe os 3 blocos */
		 if (tamficha) {
			 if (tipo == 2 || tipo == 3)
				iidm_get_atrib_from_ficha (ficha, &popt_inf->filestat);
				popt_inf->filestat_VR = popt_inf->filestat ;
				strcpy(popt_inf->nom_DO_VR, PVInf_ContVerSt.disco);
				popt_inf->ind_VR = popt_inf->ind ;

			 if (tipo == 1 || tipo == 3) {
				if (strncmp(ficha, "R51", 3) == 0 ) {
					PathFileSize = strlen (ficha + F_CABSIZE + F_STATSIZE) + 1;
					len_aux = F_CABSIZE + F_STATSIZE + PathFileSize +
								strlen (ficha + F_CABSIZE + F_STATSIZE + PathFileSize) + 1 
																/*+ ContVerStSize + 1*/;
				}
				else {
					PathFileSize = strlen (ficha + F_CABSIZE + F_STATSIZE_V4) + 1;
					len_aux = F_CABSIZE + F_STATSIZE_V4 + PathFileSize;
				}
				*tamfichaplic = tamficha - len_aux;
				if (*tamfichaplic)
					memcpy (fichaplic, ficha + len_aux, *tamfichaplic);
			 }
		 }
		 else {
			*tamfichaplic = 0;
			strcpy (fichaplic, "");
		 }
		 DLL_ocupada=0;
		 return 0;
	  }
	  else {
		 DLL_ocupada=0;
		 return st;
	  }
	}    /* if not iidm_em_DO */

	DLL_ocupada=0;
	return ENAOEMMEIO;
}




/*+---------------------------------------------------------------------------+
|    Rotina : IDM_SetOptEntry
+-----------------------------------------------------------------------------+
|
|    Descricao:  Escreve uma nova entrada relativa a um ficheiro
|                que esta em disco optico numa dada directoria.
|
|    Parametros (Entrada) :   nome_directoria - nome da directoria
|                         :   optinfo         - toda a informacao optica do ficheiro
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_SetOptEntry (char *nome_directoria, opt_t inf)
#else
	IDM_SetOptEntry (nome_directoria,inf)
	char *nome_directoria;
	opt_t inf;
#endif
{
	int     ret;
	opt_t   aux;
	char    nome_ficheiro[OMAXPATHNAME+1];

#ifdef WINDOWS
	if (DLL_ocupada==1)
		return(EDLL_BUSY);
	else
		DLL_ocupada=1;
#endif

	if (nome_directoria != NULL)
		sprintf (nome_ficheiro, "%s/%s", nome_directoria, inf.nome);
	else
		sprintf (nome_ficheiro, "%s", inf.nome);
	if (!iidm_em_DO(nome_ficheiro, &aux))
		ret = iidm_inserir_opt (nome_ficheiro, inf);
	else
		ret = EJAEMMEIO;

#ifdef WINDOWS
	DLL_ocupada = 0;
#endif

	return ret;
}






/*+---------------------------------------------------------------------------+
|    Rotina : IDM_SetOptEntryTidm
+-----------------------------------------------------------------------------+
|
|    Descricao:  Escreve uma nova entrada relativa a um ficheiro
|                que esta em disco optico numa dada directoria.
|
|    Parametros (Entrada) :   nome_directoria - nome da directoria
|                         :   optinfo         - toda a informacao optica do ficheiro
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_SetOptEntryTidm (char *nome_ficheiro, opt_t inf)
#else
	IDM_SetOptEntryTidm (nome_ficheiro,inf)
	char *nome_ficheiro;
	opt_t inf;
#endif
{
	int     ret;
	opt_t   aux;

#ifdef WINDOWS
	if (DLL_ocupada==1)
		return(EDLL_BUSY);
	else
		DLL_ocupada=1;
#endif

	if (!iidm_em_DO(nome_ficheiro, &aux))
		ret = iidm_inserir_opt (nome_ficheiro, inf);
	else
		ret = EJAEMMEIO;

#ifdef WINDOWS
	DLL_ocupada = 0;
#endif

	return ret;
}

#if 0

extern "C" int
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
	LerOptTab (char *pathdir, int modo, opt_t *inf)
#else
	LerOptTab (pathdir,modo,inf)
	char *pathdir;
	int modo;
	opt_t *inf;
#endif
{
	char                    path_opt[OMAXPATHNAME+1];
	char                    path_file[OMAXPATHNAME+1];
	int                     ret;
	static ogd_t    Ogd;
	int                     nOpenSt;
	/*static FILE  *fp=NULL;*/

	if (modo == GET_FIRST) {
		if (Ogd.fp != NULL)
			return ELEROPT_OPEN;

		if ( pathdir[strlen(pathdir) - 1] != SLASH )
			sprintf (path_opt, "%s%c%s",pathdir,SLASH,OPTTABNAME);
        else
			sprintf (path_opt, "%s%s",pathdir,OPTTABNAME);
		nOpenSt =iidm_open_optab(&Ogd, path_opt, "r+b") ;
		if (nOpenSt == EABRIROPT) {
			return 0;
		}
		if (nOpenSt != 0) {
			Ogd.fp = NULL;
			return 0;
		}
	}
	else if (modo == GET_NEXT) {
		if (Ogd.fp == NULL)
			return 0;
	}
	for (;;) {
		ret = iidm_read_opt_reg (Ogd.fp, inf);
		if (ret != 1) {
			iidm_fechar_opt(&Ogd);
			Ogd.fp = NULL;
			return 0;
		}
		/* PJT 03-11-95 Forcar nomes de ficheiros upper ou lower */
		if (Ogd.conf_CaseSens == FALSE)
			iidm_conv_filename(&Ogd,inf->nome);
		if (inf->status == S_VAZIO || inf->status == S_ARQ) /* pjt 31-1-97 p/ unix */
			continue;
		else if (inf->status == S_DOARQ || inf->status == S_DOARQX) {
			if ( pathdir[strlen(pathdir) - 1] != SLASH )
				sprintf (path_file, "%s%c%s",pathdir,SLASH,inf->nome);
			else                                            /* ????? nao deveriam ser iguais ?????  pjt, 27/11/96 deixo porque esta funcao so e usada do listadir unix */
				sprintf (path_opt, "%s%s",pathdir,OPTTABNAME);
			if (access(path_file,00) == 0 ) {
				break;
			}
			if (iidm_is_locked(&Ogd, path_file ) == TRUE ) {
				break;
			}
			ret = iidm_alterar_status_ogd (&Ogd, path_file, S_DO);
			inf->status = S_DO;
			break;
		}
		else
			break;
	}
	return 1;
}

#endif





/*+---------------------------------------------------------------------------+
|    Rotina : IDM_GuardaExtDirecto
+-----------------------------------------------------------------------------+
|
|    Descricao:    
|
|    Parametros (Entrada)   :   
|               (Saida)     :  
|
|
+----------------------------------------------------------------------------*/
extern "C" int 
#ifdef WINDOWS
	far pascal _export
#endif  
#ifndef OLD_CSTYLE
	IDM_GuardaExtDirecto(int *phOpt,char *pszDiskName, char *szFileName, char *ficha_cli, int tamficha_cli, unsigned long *index, ESIDM_IOControl *pstIOCtrl)
#else
	IDM_GuardaExtDirecto(phOpt,pszDiskName,szFileName,ficha_cli,tamficha_cli,index,pstIOCtrl)
	int *phOpt;
	char *pszDiskName;
	char *szFileName;
	char *ficha_cli;
	int tamficha_cli;
	unsigned long *index;
	ESIDM_IOControl *pstIOCtrl;
#endif
{
ContVerSt       LVInf_ContVerSt ;
	ESOPC_IOControl *pstTrfIOCtrl;
	unsigned int auxuint;
	long    auxlong;
	int     res,st,i,tries;

#ifdef WINDOWS
 if (DLL_ocupada==1)
			return(EDLL_BUSY);
		else
			DLL_ocupada=1;
#endif

	res = iidm_init_optidoc(phOpt);
	if (res != OK) {
		DLL_ocupada=0;
		return res;
	}

	if (pstIOCtrl == NULL) {
		pstIOCtrl = &stIDMNullIO;
		pstTrfIOCtrl = NULL;
	}
	else {
		pstTrfIOCtrl = &(pstIOCtrl->stOPCIOCtl);
    }

	/* PJT - JUNHO93 - Esta interface passa a ter sempre os nomes */
	/*                 dos discos opticos com maiusculas          */
	/* printf("TRACE interdm: %d,%s,%s,%s,%d\n",meio, posto,szFileName,ficha_cli,tamficha_cli); */

	for (i=0; pszDiskName[i]; i++)
		pszDiskName[i] = toupper(pszDiskName[i]);
/*
	switch (meio) {
	 case OPTICO:*/

			auxuint = (unsigned int) tamficha_cli;
			/* PJT 20-09-94 Como nivel opclient valida users, acusa os resets do servidor.
							Este ciclo e' para recuperar UMA vez dessa situacao */
			tries = 2;
			strcpy(LVInf_ContVerSt.disco, "");
			LVInf_ContVerSt.index = 0;
			strcpy(PVInf_ContVerSt.disco, pszDiskName);
			while (tries) {
				st = OPC_SaveOfile (szFileName, NULL, NULL, 0, ficha_cli, &auxuint, LVInf_ContVerSt, &PVInf_ContVerSt, pstTrfIOCtrl);
				auxlong = PVInf_ContVerSt.index ;
				tries--;
				if (st == TIME_ERR && tries > 0) {
					st = iidm_init_optidoc(phOpt);
					if (st)
						break;
				}
				else
					break;
			}
	*index = (unsigned long) auxlong;


#ifdef WINDOWS
	DLL_ocupada=0;
#endif
	return  st;

}


/*+---------------------------------------------------------------------------+
|    Rotina : IDM_RecuperaExtDirecto
+-----------------------------------------------------------------------------+
|
|    Descricao:
|
|    Parametros (Entrada)   :
|               (Saida)     :
|
|    Retorna :
|
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
IDM_RecuperaExtDirecto(int *phOpt,char *nome_DO, unsigned long index, char *szFileName, char *ficha_cli, int *tamficha_cli, ESIDM_IOControl *pstIOCtrl)
#else
IDM_RecuperaExtDirecto(phOpt,nome_DO,index,szFileName,ficha_cli,tamficha_cli, pstIOCtrl)
int *phOpt;
char *nome_DO;
unsigned long index;
char *szFileName;
char *ficha_cli;
int *tamficha_cli;
ESIDM_IOControl *pstIOCtrl;
#endif
{
	int      st,tries;
	unsigned int auxuint;
	ESOPC_IOControl *pstTrfIOCtrl;
	ContVerSt       LVInf_ContVerSt ;

#ifdef WINDOWS
	if (DLL_ocupada==1)
			return(EDLL_BUSY);
	else
			DLL_ocupada=1;
#endif

	st = iidm_init_optidoc(phOpt);
	if (st != OK) {
#ifdef WINDOWS
		DLL_ocupada=0;
#endif
		return st;
	}

	if (pstIOCtrl == NULL) {
		pstIOCtrl = &stIDMNullIO;
		pstTrfIOCtrl = NULL;
	}
	else {
		pstTrfIOCtrl = &(pstIOCtrl->stOPCIOCtl);
    }

	tries = 2;
	PVInf_ContVerSt.index = index ;
	strcpy(PVInf_ContVerSt.disco, nome_DO );
	while (tries) {
		st = OPC_LoadOfile (szFileName, NULL, NULL, 0, NULL,NULL,ficha_cli, &auxuint, &LVInf_ContVerSt, PVInf_ContVerSt, pstTrfIOCtrl);
		tries--;
		if (st == TIME_ERR && tries > 0) {
			st = iidm_init_optidoc(phOpt);
			if (st)
				break;
		}
		else
			break;
	}

	if (tamficha_cli)
		*tamficha_cli = (int) auxuint;

#ifdef WINDOWS
	DLL_ocupada=0;
#endif
	return st;
}



extern "C" int
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_ReadOptab (char *pathdir, char *mask, int modo, opt_t *inf)
#else
	IDM_ReadOptab (pathdir,mask, modo,inf)
	char  *pathdir;
	char  *mask;
	int    modo;
	opt_t *inf;
#endif
{
	return (iidm_read_optab (pathdir, mask, modo, inf));

}






extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
IDM_GetAtribFromFicha (char *f, NATRIB_STRUCT *atrib)
#else
IDM_GetAtribFromFicha (f, atrib)
char *f;
NATRIB_STRUCT *atrib;
#endif
{

	iidm_get_atrib_from_ficha(f, atrib);
	return 0;
}


/*+---------------------------------------------------------------------------+
|    Rotina : IDM_DumpOfile
+-----------------------------------------------------------------------------+
|
|    Descricao:  Escreve uma nova entrada relativa a um ficheiro
|                que esta em disco optico numa dada directoria.
|
|    Parametros (Entrada) :   nome_directoria - nome da directoria
|                         :   optinfo         - toda a informacao optica do ficheiro
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_DumpOfile (char *servidor,char *disco, long *endereco, char *file_name, char *file_path, long *file_size,
				  char *file_time, long *file_idxStart, unsigned short *file_headersize, char *file_header,
                  ContVerSt	   **ppstAssocFileList,  unsigned short  *pwNAssocFiles)
#else
	IDM_DumpOfile(servidor, disco, endereco, file_name, file_path, file_size,
				  file_time, file_idxStart, file_headersize, file_header, pstAssocFileList, pwNAssocFiles)
	char           *servidor;
	char           *disco;
	long           *endereco;
	char           *file_name;
	char           *file_path;
	long           *file_size;
	char           *file_time;
	long           *file_idxStart;
	unsigned short *file_headersize;
	char           *file_header;
   	ContVerSt	   **ppstAssocFileList;
    unsigned short *pwNAssocFiles;
#endif
{

	int     erro;


	erro = OPC_DumpOfile(disco, endereco, file_name, file_path, file_size,
				  file_time, file_idxStart, file_headersize, file_header, ppstAssocFileList, pwNAssocFiles);

	return (erro);
}






/* So far, only to MSDOS */
#ifdef MSDOS

extern "C" int
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
  IDM_FindFirst(char *pathname, int *doctype, struct ffblk *ffblk, int attrib, opt_t *infopt)
#else
  IDM_FindFirst(pathname, doctype, ffblk, attrib, infopt)
  char   *pathname;
  int    *doctype;
  struct ffblk *ffblk;
  int    attrib;
  opt_t  *infopt;
#endif
{
	return( iidm_find_first(pathname, doctype, ffblk, attrib, infopt) );
}

/*+---------------------------------------------------------------------------+

	Funcao:       IDM_FindNext

	Prototipo:    int IDM_FindNext(int *doctype, struct ffblk *ffblk, opt_t *infopt)
	Descricao:    Works together with IDM_FindFirst. See that function.
	Parametros:   see IDM_FindFirst
	Retorno:      see IDM_FindFirst
	Notas:
	Ver tambem:

----------------------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_FindNext(int *doctype, struct ffblk *ffblk, opt_t *infopt)
#else
	IDM_FindNext(doctype, ffblk, infopt)
	int *doctype;
	struct ffblk *ffblk;
	opt_t *infopt;
#endif
{
	return (iidm_find_next(doctype, ffblk, infopt));
}

#endif


extern "C" void
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
  IDM_FindClose(int iAttrib)
#else
  IDM_FindClose()
#endif
{
    iidm_find_close(iAttrib);
	return;
}


/*+-----------------------------------------------------------------------------------------+

	Funcao:       IDM_ApagarDoc

	Prototipo:    IDM_ApagarDoc (char nome_ficheiro)
	Descricao:    Apaga uma entrada relativa a um ficheiro independentemente
				  de estar ou nao em disco optico
	Parametros:
	Retorno:      Codigo de erro Optidoc

-------------------------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_ApagarDoc (int *phOpt, char *nome_ficheiro, unsigned short wFlag, int *output_mode,ESIDM_IOControl *pstIOCtrl)
#else
	IDM_ApagarDoc (phOpt,nome_ficheiro, wFlag, output_mode,pstIOCtrl)
	int     	    *phOpt;
	char    		*nome_ficheiro;
	unsigned short   wFlag;
	int     		*output_mode;
	ESIDM_IOControl *pstIOCtrl;
#endif
{
	return ( iidm_apagar (phOpt, nome_ficheiro, wFlag, output_mode,pstIOCtrl));
}






/*+---------------------------------------------------------------------------+

	Funcao:       IDM_CopiarDoc

	Prototipo:    IDM_CopiarDoc (char *szFileName, char *destino, int nao_apaga_se_existir)
	Descricao:    Copia um documento independentemente de estar ou nao em disco optico.
				  Depois, insere esses dados na directoria / Ficheiro de destino
	Parametros:
	Retorno:      Codigo de erro Optidoc
	Notas:        

----------------------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE                                      /* argumento duvidoso */
	IDM_CopiarDoc (int *phOpt,char *szFileName, char *destino, int nao_apaga_se_existir, int copia_do_e_arq, int *output_mode,ESIDM_IOControl *pstIOCtrl)
#else
	IDM_CopiarDoc (phOpt,szFileName,destino,nao_apaga_se_existir,copia_do_e_arq,output_mode,pstIOCtrl)
	int  *phOpt;
	char *szFileName;
	char *destino;
	int   nao_apaga_se_existir;
	int   copia_do_e_arq;
	int  *output_mode;
	ESIDM_IOControl *pstIOCtrl;
#endif
{
	int     st, storig, orig_em_DO, orig_em_DM, ret, i, done;
	opt_t   inf, aux, stOpttAux;
	char    pathdest[2*OMAXPATHNAME+1], szAuxPath_1[OMAXPATHNAME+1], szDestDir[OMAXPATHNAME], sfndest[OMAXFILENAME+1];
	char    file_path[OMAXPATHNAME+1], auxstr[OMAXPATHNAME+1],szAuxPath_2[OMAXPATHNAME+1], sfnorig[OMAXFILENAME+1];
	char    *p, szAux[OMAXFILENAME+1];
	int     destino_em_DO, destino_em_DM;
	struct  stat statbuf;
#ifdef UNIX
	char    comando[2*OMAXPATHNAME+1];
#else
	struct ffblk   	stFfblk;
#endif

	ret = 0;
	storig = iidm_get_info (szFileName, &inf, EDIDM_ALLFILES);
	if (storig == ERESERVNAME)
		return ERESERVNAME;

	if (storig == 0)
		iidm_acerta_arqx (szFileName, inf);

	if (storig == ENAOEMMEIO || (storig == 0 &&
								 (inf.status == S_ARQ ||inf.status == S_DOARQ || inf.status == S_DOARQX)) )
		orig_em_DM = 1;
	else
		orig_em_DM = 0;

	/* PJT: LIMITATION -> to avoid increasing complexity, we DO NOT support copy to an existing PRD */
	if (storig == 0  &&  inf.isPRD)
    	copia_do_e_arq = TRUE;

	if (storig == 0)
		orig_em_DO = 1; /* includes S_ARQS PRDS */
	else
		orig_em_DO = 0;

#if defined(MSDOS) && !defined(_WIN32)
	for (i=0; destino[i]; i++)
		destino[i] = toupper(destino[i]);
#endif

	GEN_SplitPath(szFileName, file_path, sfnorig);

	strcpy (pathdest, destino);
	if (stat(destino, &statbuf) == 0) {
		if (statbuf.st_mode & S_IFDIR) {
			if ( destino[strlen(destino) - 1] != SLASH )
				sprintf (pathdest, "%s%c%s", destino, SLASH, sfnorig);
			else
				sprintf (pathdest, "%s%s", destino, sfnorig);
		}
	}

	GEN_SplitPath(pathdest, szDestDir, sfndest);
	if (iidm_isreserved(sfndest))
		return ERESERVNAME;

	/* pjt 27/11/96 #37 */
	if (storig == 0 && inf.isPRD) {
		char szFullPath[2*OMAXPATHNAME+1];
		iidm_getpath(szDestDir, szFullPath);
        /* o teste devera' quando possivel passar a ser feito a ED_MAXFILENAME (eletipo def dependente do sist.oper. */
        if (inf.isPRD)
			if (strlen(szFullPath)+1+strlen(OPTDIRNAME)+1+strlen(sfndest) > /*MAXDIR*/MAXPATH-1)
				return (EEIDM_PGDIRTOOBIG);
        else
			if (strlen(szFullPath) > /*MAXDIR*/MAXPATH-1)
				return (EIDM_BADFILENAME);
	}
    /* end #37 */

	destino_em_DM = (stat(pathdest, &statbuf) == 0);
	if (destino_em_DM) {
		if (statbuf.st_mode & S_IFDIR) {
			return EDIR;
		}
	}

	ret = iidm_get_info (pathdest, &aux, EDIDM_ALLFILES);

	/*destino_em_DO = iidm_em_DO(pathdest, &aux);*/
	if (ret == 0) {
		if (aux.isPRD == EDIDM_PRD_PARTIAL)
			destino_em_DM = TRUE;
	}
	if (ret == 0)
		destino_em_DO = TRUE; /* INCLUDES S_ARQ */
	else
		destino_em_DO = FALSE;

	if (destino_em_DO || destino_em_DM) {

		/* PJT: LIMITATION -> to avoid increasing complexity, we DO NOT support copy to an existing PRD */
		if (ret == 0 && aux.isPRD)
			return EEIDM_PRDCOPYINVAL;

		if (nao_apaga_se_existir == 0) {
			/* APAGAR REF. OPTICA DE DESTINO. */
			if (destino_em_DO && orig_em_DO &&
					(copia_do_e_arq || (!copia_do_e_arq && !orig_em_DM) ) ) {
				ret = iidm_apagar(phOpt,pathdest, /*TRUE*/EDIDM_DELDOARQ, output_mode,pstIOCtrl);
				if (ret) 
					return ret;
			}
			else {
				;
			}
		}
		else {
			return EIDM_DESTFILERM;
		}
	}

	if ( storig == ENAOEMMEIO  || (storig == 0  && inf.status == S_DOARQ /* && inf.isPRD != EDIDM_PRD_PARTIAL*/)
							   || (storig == 0  && inf.status == S_ARQ)
							   || (storig == 0  && inf.status == S_DOARQX /*&& inf.isPRD != EDIDM_PRD_PARTIAL*/) ) {
#ifdef UNIX
		sprintf (comando, "cp %s %s", szFileName, pathdest);
		ret = system (comando);
		if (ret) 
			return ECOPIARDOC;
#else
		ret = ELWCopyFile(szFileName, pathdest);
		if (ret) {
			/* pjt 18/11/96 #30 uniformizacao dos erros com o mover */
			if (ret < 0 && errno == EACCES)
				return EPRIVILEGIOS;
            else
				return ret;
        }
		else
			chmod (pathdest, S_IREAD | S_IWRITE);
#endif
	}

	if (copia_do_e_arq) {
		if (storig == 0)
			ret = iidm_inserir_opt (pathdest, inf);
	}
	else {
		if (storig == 0 && (inf.status == S_DO || inf.status == S_ARQ)) 
			ret = iidm_inserir_opt (pathdest, inf);
	}

	if (ret)
    	return ret;

#ifdef WINDOWS
	if (storig == 0 && inf.isPRD) {
		/* pjt 27/11/96 #36 */
		if (file_path[strlen(file_path)-1] == SLASH)
			sprintf (szAuxPath_1, "%s%s%c%s%c*.*",file_path,OPTDIRNAME,SLASH,sfnorig,SLASH);
		else
			sprintf (szAuxPath_1, "%s%c%s%c%s%c*.*",file_path,SLASH,OPTDIRNAME,SLASH,sfnorig,SLASH);
		/* end #36 */
		if (IDM_FindFirst(szAuxPath_1, &st, &stFfblk, 0, &stOpttAux) == 0) {
			done=0;
			for (i=0; done==0; i++) {

				if (i==0) {
                	/* pjt 27/11/96 #36 */
					if (szDestDir[strlen(szDestDir)-1] == SLASH)
						sprintf(szAuxPath_2, "%s%s",szDestDir,OPTDIRNAME);
                    else
						sprintf(szAuxPath_2, "%s%c%s",szDestDir,SLASH,OPTDIRNAME);
                    /* end #36 */
					if (IDM_AcessoDoc(szAuxPath_2, 0)) {  /* if OPTIDOC.DIR doesn't exist ... */
						ret = IDM_Mkdir(szAuxPath_2);
						/*  pjt  23 julho  --> ret = mkdir(szAuxPath_2); */
						if (ret) {
                        	IDM_FindClose(0);
							return EEIDM_MKDIR;
                        }
					}
					/* pjt 27/11/96 #36 */
					if (szDestDir[strlen(szDestDir)-1] == SLASH)
						sprintf(szAuxPath_2, "%s%s%c%s",szDestDir,OPTDIRNAME,SLASH,sfndest);
					else
						sprintf(szAuxPath_2, "%s%c%s%c%s",szDestDir,SLASH,OPTDIRNAME,SLASH,sfndest);
					/* end #36 */
					if (IDM_AcessoDoc(szAuxPath_2, 0) == 0) /* if directory DOCXXX exists ... */
						; /* //return EIDM_MKDIREXIST; */
                    else {
						ret = IDM_Mkdir(szAuxPath_2);
						if (ret) {
                        	IDM_FindClose(0);
							return EEIDM_MKDIR;
                        }
                    }
				}
                else {
					/* pjt 27/11/96 #36 */
					if (szDestDir[strlen(szDestDir)-1] == SLASH)
						sprintf(szAuxPath_2, "%s%s%c%s",szDestDir,OPTDIRNAME,SLASH,sfndest);
                    else
						sprintf(szAuxPath_2, "%s%c%s%c%s",szDestDir,SLASH,OPTDIRNAME,SLASH,sfndest);
					/* end #36 */
				}

				if (st == S_DO)
					strcpy (szAux, stOpttAux.nome);
				else
					strcpy (szAux, stFfblk.ff_name);
				p = strrchr(szAux, '.');

				if (p) {
				  char szExt[10];
				  *p='\0';
				  strcpy (szExt, ".");
                  strcat (szExt, p+1);
				  if (/* TMP_KILL: stricmp(szExt,OPTEXTTMP)==0 ||*/ stricmp(szExt,OPTEXTBDT)==0) {
					/* pjt 27/11/96 #36 */
					if (szDestDir[strlen(szDestDir)-1] == SLASH)
						sprintf(szAuxPath_2, "%s%s%c%s%c%s",szDestDir,OPTDIRNAME,SLASH,sfndest,SLASH,sfndest);
                    else
						sprintf(szAuxPath_2, "%s%c%s%c%s%c%s",szDestDir,SLASH,OPTDIRNAME,SLASH,sfndest,SLASH,sfndest);
					/* end #36 */
					/* pjt 25/2/97 #50  */
					if (strrchr(sfndest, '.')) {
						p = strrchr(szAuxPath_2, '.');
						if (p)
							*p='\0';
                    }
					strcat (szAuxPath_2, szExt);
				  }
				}
				/* pjt 27/11/96 #36 */
				if (file_path[strlen(file_path)-1] == SLASH)
					sprintf(auxstr, "%s%s%c%s%c%s",file_path,OPTDIRNAME,SLASH,sfnorig,SLASH,(st == S_DO ? stOpttAux.nome : stFfblk.ff_name ));
				else
					sprintf(auxstr, "%s%c%s%c%s%c%s",file_path,SLASH,OPTDIRNAME,SLASH,sfnorig,SLASH,(st == S_DO ? stOpttAux.nome : stFfblk.ff_name ));
				/* end #36 */

				ret = IDM_CopiarDoc (phOpt,auxstr, szAuxPath_2, 1, 1, NULL,NULL); /* era: output_mode,pstIOCtrl);  pjt, 9/9/96 */
				if (ret)
					return(ret);
				done = IDM_FindNext(&st, &stFfblk, &stOpttAux);
			}
           	IDM_FindClose(0);
		}
	}
#endif

	return 0;
}

/*+---------------------------------------------------------------------------+

	Funcao:       IDM_MoverDoc

	Prototipo:    IDM_MoverDoc (char *szFileName, char *destino, int nao_apaga_se_existir)
	Descricao:    Move um documento independentemente de estar ou nao em disco optico.
	Parametros:   valores para wFlag -  EDIDM_NOPRIVTEST   2
    									EDIDM_COPYDOARQ    1
                                        EIDM_CASESENSITIVE 4 -> Mover ser case sensitive
	Retorno:      Codigo de erro Optidoc
	Notas:

----------------------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_MoverDoc (int *phOpt,char *origem, char *destino,  int wFlag /*copia_do_e_arq*/, int *output_mode, ESIDM_IOControl *pstIOCtrl)
#else
	IDM_MoverDoc (phOpt,origem,destino,copia_do_e_arq, output_mode, pstIOCtrl)
	int  *phOpt;
	char *origem;
	char *destino;
    int  wFlag;
	int  *output_mode;
	ESIDM_IOControl *pstIOCtrl;
    int
#endif
{
	int     copia_do_e_arq;
	int     storig, stdest;
	int		orig_is_dir, dest_is_dir;
	int		orig_is_prd, dest_is_prd;
	int		orig_em_DO, orig_em_DM;
	int     dest_em_DO, dest_em_DM;
	opt_t   inforig,infdest;
	opt_t	stOpttAux;
	int		ret, res_dlg,i,done, st;
	char    *p, pathorig[OMAXPATHNAME+1], pathdest[OMAXPATHNAME+1];
	char    sfnorig[OMAXFILENAME+1], sfndest[OMAXFILENAME+1], szAux[OMAXFILENAME+1];
	char    destfilepath[2*OMAXPATHNAME+1], optname[OMAXPATHNAME+1];
	char    szAuxPath_1[OMAXPATHNAME+1],auxstr[OMAXPATHNAME+1],szAuxPath_2[OMAXPATHNAME+1];
	int     separa_opt_mag;
	struct  stat statbuf;
	int 	res;
#ifdef UNIX
	char    comando[2*OMAXPATHNAME+1];
#else
	struct ffblk stFfblk;
#endif

	if (pstIOCtrl == NULL)
		pstIOCtrl = &stIDMNullIO;

	/* #100 */
    copia_do_e_arq = wFlag&EDIDM_COPYDOARQ;

	storig = iidm_get_info (origem,  &inforig, EDIDM_ALLFILES);
	stdest = iidm_get_info (destino, &infdest, EDIDM_ALLFILES);

	if (storig == ERESERVNAME)
		return ERESERVNAME;

	if (stdest == ERESERVNAME)
		return ERESERVNAME;

	if (storig == 0  && inforig.isPRD)
		orig_is_prd = 1;
	else
		orig_is_prd = 0;

	if (stdest == 0  && infdest.isPRD)
		dest_is_prd = 1;
	else
		dest_is_prd = 0;

	if (storig == 0)
		iidm_acerta_arqx (origem, inforig);
	if (stdest == 0)
		iidm_acerta_arqx (destino, infdest);

	if (storig == ENAOEMMEIO || (storig == 0 &&
								 (inforig.status == S_DOARQ || inforig.status == S_DOARQX || inforig.status == S_ARQ)) )
		orig_em_DM = 1; /* Includes S_ARQs */
	else
		orig_em_DM = 0;

	if (storig == 0 && inforig.status != S_ARQ)
		orig_em_DO = 1; /* Excludes S_ARQs */
	else
		orig_em_DO = 0;

    if (orig_em_DO && !(orig_em_DO && orig_em_DM && !copia_do_e_arq)) {
		if (!(wFlag&EDIDM_NOPRIVTEST)) {		/* #100 */
			ret = iidm_privil_apagar(phOpt, origem, copia_do_e_arq);
			if (ret)
				return ret;
        }
	}

#if defined(MSDOS) && !defined(_WIN32)
	for (i=0; destino[i]; i++)
		destino[i] = toupper(destino[i]);
#endif

	/* testar escrita na directoria de origem */
	GEN_SplitPath(origem, pathorig, sfnorig);
	if (access(pathorig,02) != 0 )
		return EPRIVILEGIOS;

	/* ... e na optab de origem  */
	if (storig == 0 /* orig_em_DO , because of S_ARQs */) {
		if ( pathorig[strlen(pathorig) - 1] != SLASH )
			sprintf(optname, "%s%c%s", pathorig, SLASH, OPTTABNAME);
		else
			sprintf(optname, "%s%s", pathorig, OPTTABNAME);
		if (access(optname,02) != 0 )
			return EPRIVILEGIOS;
    }

    orig_is_dir = 0;
	dest_is_dir = 0;
	if (storig == ENAOEMMEIO) {
	/* testar se origem e' directoria */
		stat(origem, &statbuf);
		if (statbuf.st_mode & S_IFDIR)
			orig_is_dir = 1;
	}

	/* PJT 16-1-95
	Substituir por um "limpador" de . e .. nas paths */
	if (destino[strlen(destino) - 1] == SLASH )
		destino[strlen(destino) - 1] = '\0';
	if ( destino[strlen(destino) - 1] == '.' )
		if (destino[strlen(destino) - 2] == SLASH )
			destino[strlen(destino) - 2] = '\0';

	/* Verificar se destino e' pathname completo ou so' directoria ... */
	strcpy(destfilepath, destino);
	if (stat(destino, &statbuf) == 0) {
		if (statbuf.st_mode & S_IFDIR) {
			if (!orig_is_dir) {
				if ( destino[strlen(destino) - 1] != SLASH )
					sprintf(destfilepath, "%s%c%s", destino, SLASH, sfnorig);
				else
					sprintf(destfilepath, "%s%s", destino, sfnorig);
            }
			else
				dest_is_dir = 1;
		}
	}

	if ((!dest_is_dir && !orig_is_dir) || (orig_is_dir && dest_is_dir) )
		// 1234567890
    	// Se quer que o mover seja case sensitive
		if (wFlag & EIDM_CASESENSITIVE)
        {
				if (strcmp(destfilepath,origem) == 0)
        			return 0;
        }
		else
        {
			if (stricmp(destfilepath,origem) == 0)
    	    	return 0;
        }


	/* ... e testar escrita na directoria de destino ... */
    /*     mover dir para dir faz tambem teste 'a dir de cima */
	GEN_SplitPath (destfilepath, pathdest, sfndest);
	if (iidm_isreserved(sfndest))
		return ERESERVNAME;

	/* pjt 27/11/96 #37 */
	if (storig == 0 && inforig.isPRD) {
		char szFullPath[2*OMAXPATHNAME+1];
		iidm_getpath(pathdest, szFullPath);
        /* o teste devera' quando possivel passar a ser feito a ED_MAXFILENAME (eletipo def dependente do sist.oper. */
		if (inforig.isPRD)
			if (strlen(szFullPath)+1+strlen(OPTDIRNAME)+1+strlen(sfndest) > /*MAXDIR*/MAXPATH-1)
				return (EEIDM_PGDIRTOOBIG);
        else
			if (strlen(szFullPath) > /*MAXDIR*/MAXPATH-1)
				return (EIDM_BADFILENAME);
	}
    /* end #37 */

	/* #59 */
	if (!dest_is_dir && access(pathdest,00) != 0 )
		return EEIDM_DIRINEX;
	/* end #59 */

	if (access(pathdest,02) != 0 )
		return EPRIVILEGIOS;

	dest_em_DM = (stat(destfilepath, &statbuf) == 0); /* Includes S_ARQs */
/* //	dest_em_DO = iidm_em_DO(destfilepath, &infdest); */
	stdest = iidm_get_info (destfilepath, &infdest, EDIDM_ALLFILES);
	if (stdest == 0 && infdest.status != S_ARQ)
		dest_em_DO = 1; /* Excludes S_ARQs */
	else 
		dest_em_DO = 0;

	if (orig_is_dir && !dest_is_dir && (dest_em_DM || dest_em_DO))
		return EDIR;

	/* ... e na optab de destino  */
	if (dest_em_DO) {
		if ( pathdest[strlen(pathdest) - 1] != SLASH )
			sprintf(optname, "%s%c%s", pathdest, SLASH, OPTTABNAME);
		else
			sprintf(optname, "%s%s", pathdest, OPTTABNAME);
		if (access(optname,02) != 0 )
			return EPRIVILEGIOS;
    }

	/* Flag Auxiliar que determina se doc nos 2 meios se dissocia */
	separa_opt_mag = orig_em_DO && orig_em_DM && !copia_do_e_arq;

	/* PJT: LIMITATION -> to avoid increasing complexity, we DO NOT support this on PRDs */
	if (separa_opt_mag && inforig.isPRD)
		return EEIDM_PRDINVALSEPAR;

	/* Testar se destino ja' existe (tem de ser apagado)*/ 
	if (dest_em_DO || dest_em_DM) {

		/* PJT: LIMITATION -> to avoid increasing complexity, we DO NOT support moves to an existing PRD */
		if (stdest == 0 && infdest.isPRD)
        	return EEIDM_PRDMOVEINVAL;

		if (!dest_em_DO) {
        	/* O if seguinte foi posto em 30-11-95 PJT para forcar merge nos moves DO->DM */
			if (orig_em_DM) {
				ret = iidm_privil_apagar(phOpt, destfilepath, FALSE);
				if (ret)
					return ret;
            }
		}
		else if (!orig_em_DO || separa_opt_mag) {
			if (!dest_em_DM) {
				;
			}
	    	else {
				ret = iidm_privil_apagar(phOpt,destfilepath, FALSE);
		    	if (ret)
					return ret;
			}
		}
		else {
			ret = iidm_privil_apagar(phOpt,destfilepath, TRUE);
			if (ret)
				return ret;
		}
	}

	/* pjt 14/11/96 ->  It is necessary to test in first place if all pages are
    					moveable in case of a PRD */
#ifdef WINDOWS
	if (storig == 0 && inforig.isPRD) {
		/* pjt 27/11/96 #36 */
		if (pathorig[strlen(pathorig)-1] == SLASH)
			sprintf (szAuxPath_1, "%s%s%c%s%c*.TIF",pathorig,OPTDIRNAME,SLASH,sfnorig,SLASH);
		else
			sprintf (szAuxPath_1, "%s%c%s%c%s%c*.TIF",pathorig,SLASH,OPTDIRNAME,SLASH,sfnorig,SLASH);
		/* end #36 */
		if (IDM_FindFirst(szAuxPath_1, &st, &stFfblk, 0, &stOpttAux) == 0) {
			done=0;
			for (i=0; done==0; i++) {
				/* pjt 27/11/96 #36 */
				if (pathorig[strlen(pathorig)-1] == SLASH)
					sprintf(auxstr, "%s%s%c%s%c%s",pathorig,OPTDIRNAME,SLASH,sfnorig,SLASH,(st == S_DO ? stOpttAux.nome : stFfblk.ff_name ));
				else
					sprintf(auxstr, "%s%c%s%c%s%c%s",pathorig,SLASH,OPTDIRNAME,SLASH,sfnorig,SLASH,(st == S_DO ? stOpttAux.nome : stFfblk.ff_name ));
				/* end #36 */
				if (st == S_DO || st == S_DOARQ || st == S_DOARQX) {
					ret = iidm_privil_apagar(phOpt, auxstr, copia_do_e_arq);
					if (ret) {
                       	IDM_FindClose(0);
						return ret;
                    }
                }
				done = IDM_FindNext(&st, &stFfblk, &stOpttAux);
			}
			IDM_FindClose(0);
		}
	}
#endif     /* end pjt 14/11/96*/

	if (orig_em_DM) {
#ifdef UNIX
		sprintf (comando, "mv %s %s", origem, destfilepath);
		ret = system (comando);
		if (ret)
			return EMOVERDOC;
#else

		if (orig_em_DO  && inforig.status == S_DOARQX
										  && separa_opt_mag && output_mode && *output_mode!=IDM_IO_SILENT) {

			if (*output_mode==IDM_IO_YESALL) {
				res = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_MVARQX_YNA, sfnorig);
				if ( res == 0 )
					return EIDM_OPCANCEL;
				if ( res == 2 )
					*output_mode = IDM_IO_SILENT;
			}
		    else {
				res = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_MVARQX_YN, sfnorig);
				if ( res == 0 )
					return EIDM_OPCANCEL;
			}
		}

		if (dest_em_DO  && infdest.status == S_DOARQX && output_mode && *output_mode!=IDM_IO_SILENT) {

			if (*output_mode==IDM_IO_YESALL) {
				res = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_RMARQX_YNA, sfndest);
				if ( res == 0 )
					return EIDM_OPCANCEL;
				if ( res == 2 )
					*output_mode = IDM_IO_SILENT;
			}
		    else {
				res = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_RMARQX_YN, sfndest);
				if ( res == 0 )
					return EIDM_OPCANCEL;
			}
		}

/*		if ( !(orig_em_DO && inforig.isPRD == EDIDM_PRD_PARTIAL)) {*/
			ret = ELWRenameFile(origem, destfilepath);
			if (ret) 
				return  ret;
/*        }*/
#endif

	}
	else {
		;/* PJT 30-11-95 Moves de opticos para cima de so' magneticos não apagam  
		if (dest_em_DM) {
			ret = unlink(destfilepath);
			if (ret != 0)
				return EREMOVER;
		}*/
	}

	/* APAGAR REF. OPTICA DE DESTINO. */
	if (dest_em_DO && orig_em_DO && !separa_opt_mag ) {
		if (output_mode && *output_mode!=IDM_IO_SILENT) {
			if (*output_mode==IDM_IO_YESALL)
            {
            	// Se o ficheiro de origem e destino sao o mesmo
            	if (!stricmp(sfndest, inforig.nome))
                {
                	// nao apaga o destino
					res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_OPTDELET_YNA, sfndest);
					if ( res_dlg == 0 )
						return EIDM_OPCANCEL;
					if ( res_dlg == 2 )
						*output_mode = IDM_IO_SILENT;
                }
			}
			else
            {
            	// Se o ficheiro de origem e destino sao o mesmo
            	if (!stricmp(sfndest, inforig.nome))
                {
                	// nao apaga o destino
					res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_OPTDELET_YN, sfndest);
					if ( res_dlg == 0 )
						return EIDM_OPCANCEL;
                }
			}
		}

	/* pjt 20-9-95 Alternativa: Faz sempre validacao de apagar opticos
		res_dlg = (*pstIOCtrl->Avisofunc)(IDM_DIALOG_OPTDELET_YN, sfndest);
		if ( res_dlg == 0 )
			return EIDM_OPCANCEL;*/

		ret = iidm_alterar_status (destfilepath, S_VAZIO);
		if (ret != OK)
			return ret;
	}

    /* CRIACAO DO FICHEIRO (OPT) DE DESTINO */
	if (!separa_opt_mag) { /* situacao normal */
		if (orig_em_DO || (storig == 0 && inforig.status == S_ARQ)) {
			/* feito la' dentro...
			strcpy(inforig.nome, sfndest);*/
			ret = iidm_inserir_opt (destfilepath, inforig);
		}
	}
	else {
		if (orig_em_DO && !orig_em_DM) {
			/* feito la' dentro...
			strcpy(inforig.nome, sfndest);*/
			ret = iidm_inserir_opt (destfilepath, inforig);
		}
	}
	if (ret)
		return ret;

#ifdef WINDOWS
	if (storig == 0 && inforig.isPRD) {
		/* pjt 27/11/96 #36 */
		if (pathorig[strlen(pathorig)-1] == SLASH)
			sprintf (szAuxPath_1, "%s%s%c%s%c*.*",pathorig,OPTDIRNAME,SLASH,sfnorig,SLASH);
		else
			sprintf (szAuxPath_1, "%s%c%s%c%s%c*.*",pathorig,SLASH,OPTDIRNAME,SLASH,sfnorig,SLASH);
		/* end #36 */
		if (IDM_FindFirst(szAuxPath_1, &st, &stFfblk, 0, &stOpttAux) == 0) {
			done=0;
			for (i=0; done==0; i++) {

				if (i==0) {
					/* pjt 27/11/96 #36 */
					if (pathdest[strlen(pathdest)-1] == SLASH)
						sprintf(szAuxPath_2, "%s%s",pathdest,OPTDIRNAME);
                    else
						sprintf(szAuxPath_2, "%s%c%s",pathdest,SLASH,OPTDIRNAME);
                    /* end #36 */
					if (IDM_AcessoDoc(szAuxPath_2, 0)) {  /* if OPTIDOC.DIR doesn't exist ... */
						ret = IDM_Mkdir(szAuxPath_2);
						/*  pjt 23 julho ->  ret = mkdir(szAuxPath_2); */
						if (ret) {
                        	IDM_FindClose(0);
							return EEIDM_MKDIR;
                        }
					}
					/* pjt 27/11/96 #36 */
					if (pathdest[strlen(pathdest)-1] == SLASH)
						sprintf(szAuxPath_2, "%s%s%c%s",pathdest,OPTDIRNAME,SLASH,sfndest);
                    else
						sprintf(szAuxPath_2, "%s%c%s%c%s",pathdest,SLASH,OPTDIRNAME,SLASH,sfndest);
					/* end #36 */
					if (IDM_AcessoDoc(szAuxPath_2, 0) == 0) /* if directory DOCXXX exists ... */
						; /* //return EIDM_MKDIREXIST; */
					else {
						ret = IDM_Mkdir(szAuxPath_2);
						if (ret) {
                        	IDM_FindClose(0);
							return EEIDM_MKDIR;
                        }
                    }
				}
                else {
					/* pjt 27/11/96 #36 */
					if (pathdest[strlen(pathdest)-1] == SLASH)
						sprintf(szAuxPath_2, "%s%s%c%s",pathdest,OPTDIRNAME,SLASH,sfndest);
                    else
						sprintf(szAuxPath_2, "%s%c%s%c%s",pathdest,SLASH,OPTDIRNAME,SLASH,sfndest);
					/* end #36 */
				}

				if (st == S_DO)
					strcpy (szAux, stOpttAux.nome);
				else
					strcpy (szAux, stFfblk.ff_name);
				p = strrchr(szAux, '.');

				if (p) {
				  char szExt[10];
				  *p='\0';
				  strcpy (szExt, ".");
                  strcat (szExt, p+1);
				  if (/* TMP_KILL: stricmp(szExt,OPTEXTTMP)==0 || */ stricmp(szExt,OPTEXTBDT)==0) {
					/* pjt 27/11/96 #36 */
					if (pathdest[strlen(pathdest)-1] == SLASH)
						sprintf(szAuxPath_2, "%s%s%c%s%c%s",pathdest,OPTDIRNAME,SLASH,sfndest,SLASH,sfndest);
                    else
						sprintf(szAuxPath_2, "%s%c%s%c%s%c%s",pathdest,SLASH,OPTDIRNAME,SLASH,sfndest,SLASH,sfndest);
					/* end #36 */
                    /* pjt 25/2/97 #50  */
					if (strrchr(sfndest, '.')) {
						p = strrchr(szAuxPath_2, '.');
						if (p)
							*p='\0';
                    }
					strcat (szAuxPath_2, szExt);
				  }
				}

				/* pjt 27/11/96 #36 */
				if (pathorig[strlen(pathorig)-1] == SLASH)
					sprintf(auxstr, "%s%s%c%s%c%s",pathorig,OPTDIRNAME,SLASH,sfnorig,SLASH,(st == S_DO ? stOpttAux.nome : stFfblk.ff_name ));
				else
					sprintf(auxstr, "%s%c%s%c%s%c%s",pathorig,SLASH,OPTDIRNAME,SLASH,sfnorig,SLASH,(st == S_DO ? stOpttAux.nome : stFfblk.ff_name ));
				/* end #36 */
				ret = IDM_MoverDoc (phOpt,auxstr, szAuxPath_2, 1, NULL,NULL); /* era: output_mode,pstIOCtrl);  pjt, 9/9/96 */
				if (ret) {
                   	IDM_FindClose(0);
					return(ret);
                }
				done = IDM_FindNext(&st, &stFfblk, &stOpttAux);
			}
			IDM_FindClose(0);
		}
		/* pjt 27/11/96 #36 */
		if (pathorig[strlen(pathorig)-1] == SLASH)
			sprintf (szAuxPath_1, "%s%s%c%s",pathorig,OPTDIRNAME,SLASH,sfnorig);
		else
			sprintf (szAuxPath_1, "%s%c%s%c%s",pathorig,SLASH,OPTDIRNAME,SLASH,sfnorig);
		/* end #36 */
		ret = IDM_Rmdir(phOpt, szAuxPath_1);
		if (ret)
			return(ret);
	}
#endif

	/* Delete original file */
    // Se o ficheiro de origem e destino sao o mesmo
    if (!stricmp(sfndest, inforig.nome))
    {

		if (!separa_opt_mag) {
			if (orig_em_DO || (storig == 0 && inforig.status == S_ARQ))
				ret = iidm_alterar_status (origem, S_VAZIO);
		}
		else {
			if (orig_em_DO && !orig_em_DM)
				ret = iidm_alterar_status (origem, S_VAZIO);
	    }
    }
    return ret;

}


/*+---------------------------------------------------------------------------+

	Funcao:       IDM_Rmdir

	Prototipo:    IDM_Rmdir (char *pathdir)
	Descricao:    Apaga a directoria dada no argumento. 
	Parametros:   
	Retorno:      Igual 'a rotina rmdir
	Notas:        Nao apaga se existirem documentos opticos.
	Ver tambem:

----------------------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_Rmdir (int *phopt, char *pathdir)
#else
	IDM_Rmdir (phopt, pathdir)
	int   *phopt;
	char  *pathdir;
#endif
{
	return (iidm_rmdir (phopt, pathdir));
}


/*+---------------------------------------------------------------------------+

	Funcao:       IDM_Mkdir

	Prototipo:    IDM_Mkdir (char *pathdir)
	Descricao:    Cria a directoria dada no argumento.
	Parametros:
	Retorno:      Igual 'a rotina mkdir
	Notas:        Nao cria se existir algo com esse nome.
	Ver tambem:

----------------------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_Mkdir (char *pathdir)
#else
	IDM_Mkdir (pathdir)
	char  *pathdir;
#endif
{
 	return (iidm_mkdir (pathdir));
}




/*+---------------------------------------------------------------------------+

	Funcao:       IDM_EstadoDoc

	Prototipo:    IDM_EstadoDoc (char *szFileName, int *iidm_estado)
	Descricao:    Devolve o estado optidoc de um ficheiro e o seu stat
				  Estende a funcao stat. Para documentos em DO e ARQ
				  devolve o stat da versao em magnetico.    
	Parametros:
	Retorno:      Identico ao stat
	Notas:        
	Ver tambem:

----------------------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_EstadoDoc (char *szFileName, int *iidm_estado, struct stat *atribs)
#else
	IDM_EstadoDoc (szFileName, iidm_estado, atribs)
	char *szFileName;
	int *iidm_estado;
	struct stat *atribs;
#endif
{
	return (iidm_estado_doc (szFileName, iidm_estado, atribs));
}





/* ------------------------------------------
Opcoes para modo:
06  Check for read and write permission
04  Check for read permission
02  Check for write permission
01  Execute (ignored)
00  Check for existence of file
Retorna 0 se ha' acesso ou -1 se nao houver
-----------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_AcessoDoc (char *szFileName,int  modo)
#else
	IDM_AcessoDoc (szFileName,modo)
	char *szFileName;
	int  modo;
#endif
{
	return (iidm_acesso_doc(szFileName,modo));
}



extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_IsReserved (char *szFileName)
#else
	IDM_IsReserved (szFileName)
	char *szFileName;
#endif
{
	return (iidm_isreserved(szFileName));
}



/*---------------------------------------------------------

	Returns -1 for bad optab, 0 for mag only (including
			S_ARQS (mag.SIFS)) or 1 for all kinds of opticals

---------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_IsOptical (char *szFileName, opt_t *infopt)
#else
	IDM_IsOptical (szFileName,infopt)
	char *szFileName;
	opt_t *infopt;
#endif
{
	return (iidm_em_DO(szFileName,infopt));
}


extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_AcertaArqx (char *fn, opt_t infopt)
#else
	IDM_AcertaArqx (fn, infopt)
	char *fn;
	opt_t infopt;
#endif
{
	return (iidm_acerta_arqx(fn, infopt));
}


/*+---------------------------------------------------------------------------+
|    Function name: IDM_NewPRDEntry
+-----------------------------------------------------------------------------+
|
|    Description:  
|
|    Parameters (In) : Complete file name
|               (Out): 
|
|    Notes:	This function doesn't check if file exists (and that can't happen!)
|			The caller must previously do so. 
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_NewPRDEntry(char *pszFile)
#else
	IDM_NewPRDEntry(pszFile)
	char *pszFile;
#endif
{
	return (iidm_new_PRD_entry(pszFile));
}



/*+---------------------------------------------------------------------------+
|    Function name: IDM_IsPRD
+-----------------------------------------------------------------------------+
|
|    Description:  
|
|    Parameters (In) : Complete file name
|               (Out): 
|
|    Notes:	This function doesn't check if file is PRD
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_IsPRD(char *pszFile)
#else
	IDM_IsPRD(pszFile)
	char *pszFile;
#endif
{
	return (iidm_is_PRD(pszFile));
}



/*+---------------------------------------------------------------------------+
|    Rotina : IDM_AlterarStatus
+-----------------------------------------------------------------------------+
|
|    Descricao:  Dado o nome de um ficheiro, altera na tabela .OPT a variavel 
|               status  correspondente.
|
|    Parametros (Entrada)   : szFileName - nome do ficheiro
|                             novo_status - novo status a atribuir
|               (Saida)     : 
|               (Implicitos): 
|
|    Chamadas : iidm_caminho
|
|
+----------------------------------------------------------------------------*/
extern "C" int 
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
IDM_AlterarStatus (char *szFileName, char novo_status)
#else
IDM_AlterarStatus (szFileName, novo_status)
char *szFileName;
char novo_status;
#endif
{
int ret;

#ifdef WINDOWS
	if (DLL_ocupada==1)
		return(EDLL_BUSY);
	else
		DLL_ocupada=1;
#endif

	ret = iidm_alterar_status (szFileName, novo_status);

#ifdef WINDOWS
	DLL_ocupada=0;
#endif

	return ret;

}

/*+---------------------------------------------------------------------------+
|    Rotina : IDM_OptEstado
+-----------------------------------------------------------------------------+
|
|    Descricao:  Dado o nome de um ficheiro, devolve o status do ficheiro,
|                e os seus atributos (quando foi para optico).
|                Isto, se o ficheiro existir na tabela, caso contrario devolve
|                o erro correspondente.
|
|    Parametros (Entrada)   : szFileName - nome do ficheiro
|                             status        - iidm_estado do ficheiro.
|                             atribs        - NATRIBSTRUCT do ficheiro
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_OptEstado (char  *szFileName, char  *status, NATRIB_STRUCT  *atribs)
#else
	IDM_OptEstado (szFileName,status,atribs)
	char *szFileName;
	char *status;
	NATRIB_STRUCT *atribs;
#endif
{
	int     ret;
	opt_t   inf;

#ifdef WINDOWS
	if (DLL_ocupada==1)
		return(EDLL_BUSY);
	else
		DLL_ocupada=1;
#endif
	ret = iidm_get_info (szFileName, &inf, EDIDM_ONLYOPTS);
	if (ret != 0) {
		DLL_ocupada = 0;
		return ret;
	}
	*status=inf.status;
	*atribs=inf.filestat;
	DLL_ocupada=0;
	return 0;
}




/*+---------------------------------------------------------------------------+
|    Rotina : IDM_GetOptEntry
+-----------------------------------------------------------------------------+
|
|    Descricao:  Le todos os dados de uma entrada relativa a um ficheiro
|                que esta em disco optico.
|                Isto, se o ficheiro existir na tabela opt, caso contrario devolve
|                o erro correspondente.
|
|    Parametros (Entrada) :   szFileName - nome do ficheiro
|               (Saida)   :   optinfo       - toda a informacao optica do ficheiro
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_GetOptEntry (char *szFileName,opt_t *inf)
#else
	IDM_GetOptEntry (szFileName,inf)
	char *szFileName;
	opt_t *inf;
#endif
{
	int     ret;

#ifdef WINDOWS
	if (DLL_ocupada==1)
		return(EDLL_BUSY);
	else
		DLL_ocupada=1;
#endif

	ret = iidm_get_info (szFileName, inf, EDIDM_ONLYOPTS);
	DLL_ocupada = 0;
	return ret;
}





/*+---------------------------------------------------------------------------+
|    Function :  IDM_GetOptInfo
+-----------------------------------------------------------------------------+
|
|    Description:    
|
|    Parameters (in ):     
|               (out):
|
|    Return:   informa‡ƒo relativa a um ficheiro em disco optico
|
+----------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
IDM_GetOptInfo (char  *nome_fich_ptr,opt_t  *inf)
#else
IDM_GetOptInfo (nome_fich_ptr,inf)
char *nome_fich_ptr;
opt_t *inf ;

#endif

{
	 return (iidm_get_info (nome_fich_ptr,inf, EDIDM_ONLYOPTS));
}



extern "C" int
#ifdef WINDOWS
far pascal _export
#endif
#ifndef OLD_CSTYLE
IDM_GetOptInfoAll (char  *nome_fich_ptr,opt_t  *inf)
#else
IDM_GetOptInfoAll (nome_fich_ptr,inf)
char *nome_fich_ptr;
opt_t *inf ;

#endif

{
	 return (iidm_get_info (nome_fich_ptr,inf, EDIDM_ALLFILES));
}

extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_PrivilApagar (int *phElwOpt, char *nome_ficheiro, int do_e_arq)
#else
	IDM_PrivilApagar (phElwOpt, nome_ficheiro, do_e_arq)
	int  *phElwOpt;
	char *nome_ficheiro;
	int   do_e_arq;
#endif
{
	return (iidm_privil_apagar (phElwOpt, nome_ficheiro, do_e_arq));
}



/*+-----------------------------------------------------------------------------------------+

	Funcao:       IDM_ValidPrivApagar

	Prototipo:    IDM_PrivApagar (char nome_ficheiro, int do_e_arq, int *output_mode)
	Descricao:    Testa as permissoes para apagar o doc
	Parametros:
	Retorno:      Codigo de erro Optidoc

-------------------------------------------------------------------------------------------*/

extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_ValidPrivApagar (int *phOpt,char *nome_ficheiro, int *do_e_arq, int *output_mode,ESIDM_IOControl *pstIOCtrl)
#else
	IDM_ValidPrivApagar (phOpt,nome_ficheiro, do_e_arq, output_mode,pstIOCtrl)
	int *phOpt;
	char    *nome_ficheiro;
	int     *do_e_arq;
	int     *output_mode;
	ESIDM_IOControl *pstIOCtrl;
#endif
{
	return (iidm_valid_priv_apagar (phOpt,nome_ficheiro, do_e_arq,output_mode,pstIOCtrl));
}



extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
	IDM_File2Bdt (char *pszFileName, char *pszBDTFile)
#else
	IDM_File2Bdt (pszFileName, pszBDTFile)
	char *pszFileName;
	char *pszBDTFile;
#endif
{
	return (iidm_file_2_bdt (pszFileName, pszBDTFile));
}




#ifdef MSDOS
/*---------------------------------------------------------------------------+

	Function:     IDM_RemoveTree

	Description:  
	Args:			wFlag:  BitMask with values EDIDM_DELDOARQ, EDIDM_HARDDEL
	Return:
	Notes:

------------------------------------------------------------------------------*/
extern "C" int
#ifdef WINDOWS
 far pascal _export
#endif
#ifndef OLD_CSTYLE
IDM_RemoveTree(int *phOpt, char *szPath, unsigned short  wFlag, int *output_mode,ESIDM_IOControl *pstIOCtrl)
#else
IDM_RemoveTree(phOpt, szPath, wFlag, output_mode, pstIOCtrl)
int	 			*phOpt;
char 			*szPath;
unsigned short   wFlag;
int 			*output_mode;
ESIDM_IOControl *pstIOCtrl;
#endif
{
	return (iidm_remove_tree (phOpt, szPath, wFlag, output_mode, pstIOCtrl));
}
#endif


#ifdef WINDOWS
extern "C" int far pascal _export
	IDM_GetTmpFileName(char *szTemplate, char *szFileName, unsigned short wLen)
{
char *pRet;

AGAIN:;
	pRet = ELWMakeTmpFile(szTemplate, szFileName, wLen);
	if (pRet == NULL || pRet[0] == '\0')
		return EEIDM_BADTMPNAME;

	if (iidm_acesso_doc(szFileName,00) == 0) {
		if (toupper(szTemplate[1]) < 'Z') {
			szTemplate[2]++;
			goto AGAIN;
		}
		else
			return EEIDM_BADTMPNAME;
	}
	return 0;
}
#endif



