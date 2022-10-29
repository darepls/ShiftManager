CREATE OR REPLACE PACKAGE BODY PCK_GENERADOR_TURNOS AS
--------------------------------------------------------------------------------
-- AUTOR : David Ramirez E
-- PROPOSITO : Genera los turnos con base a los servicios de los comercios
--------------------------------------------------------------------------------

  PROCEDURE PRC_GENERA_TURNO(P_FEC_INI     DATE
                            ,P_FEC_FIN     DATE 
                            ,P_ID_SERVICIO AS_SERVICIO.ID_SERVICIO%TYPE) IS
--VARIABLES
-----------  
  V_H_APERTURA TIMESTAMP;
  V_H_CIERRE   TIMESTAMP;
  V_H_ACUM     TIMESTAMP;
  V_DURACION   AS_SERVICIO.DURACION%TYPE;
  ------------------------------------------------------------------------------
  --DESCRIPCION:     Genera los turnos de acuerdo a la duraci�n del servicio
  --                 comprendida por una hora inicial y final parametrizada
  --                 durante un rango de fechas
  --ELABORADO POR :  David Ramirez E
  --FECHA ELABORA :  10-05-2022
  ------------------------------------------------------------------------------
  BEGIN
    SELECT  TO_TIMESTAMP(TO_CHAR(SE.HORA_APERTURA, 'DDMMYYYY HH24:MI'), 'DD/MM/YYYY HH24:MI')
           ,TO_TIMESTAMP(TO_CHAR(SE.HORA_CIERRE,   'DDMMYYYY HH24:MI'), 'DD/MM/YYYY HH24:MI')
           ,SE.DURACION
    INTO    V_H_APERTURA
           ,V_H_CIERRE
           ,V_DURACION
    FROM    AS_COMERCIO CO
           ,AS_SERVICIO SE
    WHERE   CO.ID_COMERCIO = SE.ID_COMERCIO
      AND   SE.ID_SERVICIO = P_ID_SERVICIO;

    FOR DIA IN TO_NUMBER(TO_CHAR(P_FEC_INI, 'J')) .. TO_NUMBER(TO_CHAR(P_FEC_FIN, 'J'))
    LOOP
        V_H_ACUM := V_H_APERTURA;
        WHILE V_H_ACUM < V_H_CIERRE
        LOOP
            INSERT INTO AS_TURNO
            VALUES (
              AS_TURNO_SEQ.NEXTVAL,
              P_ID_SERVICIO,
              TO_DATE(TO_CHAR(DIA), 'J'),
              V_H_ACUM,
              V_H_ACUM + (1 / 1440 * V_DURACION),
              'A'
            );
            COMMIT;
            V_H_ACUM := V_H_ACUM + (1 / 1440 * V_DURACION);
        END LOOP;
    END LOOP;
  EXCEPTION 
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE || '-' || SQLERRM);
  END PRC_GENERA_TURNO;
  
  FUNCTION FC_STR_TO_BASE64(P_VAL VARCHAR2)
    RETURN VARCHAR2 IS
  
  BEGIN
    RETURN UTL_RAW.CAST_TO_VARCHAR2(
             UTL_ENCODE.BASE64_ENCODE(
               UTL_RAW.CAST_TO_RAW(P_VAL)
             )
           );
  END FC_STR_TO_BASE64;
  
  FUNCTION FC_BASE64_TO_STR(P_VAL VARCHAR2)
    RETURN VARCHAR2 IS
  
  BEGIN
    RETURN UTL_RAW.CAST_TO_VARCHAR2(
             UTL_ENCODE.BASE64_DECODE(
               UTL_RAW.CAST_TO_RAW(P_VAL)
             )
           );
  END FC_BASE64_TO_STR;
  
END PCK_GENERADOR_TURNOS;
/
