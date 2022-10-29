CREATE OR REPLACE PACKAGE PCK_GENERADOR_TURNOS IS
--------------------------------------------------------------------------------
-- AUTOR : David Ramirez E
-- PROPOSITO : Genera los turnos con base a los servicios de los comercios
--------------------------------------------------------------------------------

  PROCEDURE PRC_GENERA_TURNO(P_FEC_INI     DATE
                            ,P_FEC_FIN     DATE 
                            ,P_ID_SERVICIO AS_SERVICIO.ID_SERVICIO%TYPE);
  
  FUNCTION FC_STR_TO_BASE64(P_VAL VARCHAR2)
    RETURN VARCHAR2;
  
  FUNCTION FC_BASE64_TO_STR(P_VAL VARCHAR2)
    RETURN VARCHAR2;

END PCK_GENERADOR_TURNOS;
/
