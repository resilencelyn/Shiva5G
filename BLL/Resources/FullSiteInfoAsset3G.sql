﻿  select  
                        b1.umtscellid as CellID, c2.IDNAME AS CellName, la.INDEXNO as LOGINDEX,substr(c2.IDNAME,5, 1) as Sector	,
                        c1.idname as SiteID,
                        substr(h.IDNAME,11, 1) as Candidate,
                        h.TOWN as SiteAddress,
                        h.ADDRESS1 as SiteAddress1,
                        h.ADDRESS2 as SiteAddress2,
                        c1.NAME as SiteName,
                        0 as GSM_TRX,
                        0 as GSM_Pwr_per_TRX ,
                        1 as UMTS_TRX ,
                        ucc.MAXTXPOWER as UMTS_Pwr_per_TRX,
                        0 as LTE_TRX,
                        0 as LTE_Pwr_per_TRX ,
                        0 as NR_TRX ,
                        0 as NR_Pwr_per_TRX,
                       'U' as LAYER_TECHNOLOGY,
                        dn.IDNAME as Controler,

                        CASE 
                        WHEN ut.DOWNLINKCH > 10000  THEN '2100'   ELSE '900'
                        END as Band,

                        pa.PHYINDEX as PHYINDEX,
                        pa.AZIMUTH as Azimuth,
                        pa.HEIGHT as AGL,
                        pa.HEIGHTOFFSET as ARTL,
                        ad.IDNAME as AntennaType,
                        f.FEEDERLEN as FEEDERLENGTH,
                        fe.IDNAME as FEEDERTYPE,
                        pa.TILT as MECHANICAL_TILT,

                        CASE WHEN la.INHERITMASTERPATTERN=0 THEN ap.downtilt
                        WHEN la.INHERITMASTERPATTERN=1 THEN ap1.downtilt 
                        WHEN la.INHERITMASTERPATTERN=2 THEN ap2.downtilt
                        WHEN la.INHERITMASTERPATTERN=3 THEN ap3.downtilt
                        WHEN la.INHERITMASTERPATTERN=4 THEN ap4.downtilt
                        END AS Etilt, 
                        
                        la.PORTS as PortNumber,

                        (SELECT flg.FLAGID 
                        FROM FLAGS flg
                        JOIN FLAGVALUES flgv ON flgv.OBJECTKEY = b1.LOGCELLFK AND flg.FLAGKEY = flgv.FLAGKEY AND flgv.PROJECTNO = 1
                        JOIN FLAGGROUPS flgg ON flgg.FLAGGROUPKEY = flgv.FLAGGROUPKEY AND flgg.PROJECTNO = 1
                        WHERE flgg.FLAGGROUPID = 'RRU type') AS RRU_Type,

                        (SELECT flg.FLAGID 
                        FROM FLAGS flg
                        JOIN FLAGVALUES flgv ON flgv.OBJECTKEY = b1.LOGCELLFK AND flg.FLAGKEY = flgv.FLAGKEY AND flgv.PROJECTNO = 1
                        JOIN FLAGGROUPS flgg ON flgg.FLAGGROUPKEY = flgv.FLAGGROUPKEY AND flgg.PROJECTNO = 1
                        WHERE flgg.FLAGGROUPID = 'TMA') AS TMA,

                        (SELECT flg.FLAGID 
                        FROM FLAGS flg
                        JOIN FLAGVALUES flgv ON flgv.OBJECTKEY = b1.LOGCELLFK AND flg.FLAGKEY = flgv.FLAGKEY AND flgv.PROJECTNO = 1
                        JOIN FLAGGROUPS flgg ON flgg.FLAGGROUPKEY = flgv.FLAGGROUPKEY AND flgg.PROJECTNO = 1
                        WHERE flgg.FLAGGROUPID = 'Combiner/Splitter') AS COMBINER_SPLITTER,

                        (SELECT flg.FLAGID 
                        FROM FLAGS flg
                        JOIN FLAGVALUES flgv ON flgv.OBJECTKEY = b1.LOGCELLFK AND flg.FLAGKEY = flgv.FLAGKEY AND flgv.PROJECTNO = 1
                        JOIN FLAGGROUPS flgg ON flgg.FLAGGROUPKEY = flgv.FLAGGROUPKEY AND flgg.PROJECTNO = 1
                        WHERE flgg.FLAGGROUPID = '2nd Combiner') AS SEC_COMBINER_SPLITTER,

                        (SELECT flg.FLAGID 
                        FROM FLAGS flg
                        JOIN FLAGVALUES flgv ON flgv.OBJECTKEY = c1.LOGNODEPK AND flg.FLAGKEY = flgv.FLAGKEY AND flgv.PROJECTNO = 1
                        JOIN FLAGGROUPS flgg ON flgg.FLAGGROUPKEY = flgv.FLAGGROUPKEY AND flgg.PROJECTNO = 1
                        WHERE flgg.FLAGGROUPID = 'Co-Location') AS CoLocation,

                        (SELECT flg.FLAGID 
                        FROM FLAGS flg
                        JOIN FLAGVALUES flgv ON flgv.OBJECTKEY = b1.LOGCELLFK AND flg.FLAGKEY = flgv.FLAGKEY AND flgv.PROJECTNO = 1
                        JOIN FLAGGROUPS flgg ON flgg.FLAGGROUPKEY = flgv.FLAGGROUPKEY AND flgg.PROJECTNO = 1
                        WHERE flgg.FLAGGROUPID = 'Antenna Mounting') AS ANTENNA_MOUNT

                        from  network_planning.LOGUMTSCELL b1 
                        INNER JOIN network_planning.LOGCELL c2 ON b1.PROJECTNO = c2.PROJECTNO AND b1.LOGCELLFK = c2.LOGCELLPK 
                        INNER JOIN network_planning.LOGNODE c1 ON c2.PROJECTNO = c1.PROJECTNO AND c2.LOGNODEFK = c1.LOGNODEPK 
                        INNER JOIN network_planning.LOGUMTSCELLCAR ucc ON b1.PROJECTNO = ucc.PROJECTNO AND b1.LOGCELLfK = ucc.LOGCELLFK 
                        INNER JOIN network_planning.LOGUMTSCAR uc ON ucc.projectno = uc.projectno AND ucc.CARRIERFK = uc.UMTSCARPK 
                        INNER JOIN network_planning.TGCARRIER ut ON uc.projectno = ut.projectno AND uc.tgcarrierfk = ut.carrierkey 
                        INNER JOIN network_planning.SITEADDRESS h ON c1.projectno = h.projectno AND c1.addressfk = h.addresskey 
                        INNER JOIN network_planning.LOGCONNECTION d1 ON c1.PROJECTNO = d1.PROJECTNO AND c1.LOGNODEPK = d1.LOGNODEBFK 
                        INNER JOIN network_planning.LOGRNC e1 ON d1.PROJECTNO = e1.PROJECTNO AND d1.lognodeafk = e1.lognodepk 
                        INNER JOIN network_planning.LOGcellFEEDER f ON b1.PROJECTNO = f.projectno AND b1.LOGCELLfk = f.logcellfk 
                        INNER JOIN network_planning.FEEDER fe on f.FEEDERFK = fe.FEEDERKEY
                        INNER JOIN  network_planning.LOGNODE dn ON e1.PROJECTNO = dn.PROJECTNO and e1.LOGNODEPK = dn.LOGNODEPK
                        INNER JOIN logicalantenna la on la.PROJECTno=f.PROJECTno and la.LOGANTENNAPK =f.LOGANTENNAFK
                        INNER JOIN phyantenna pa on pa.PROJECTNO = la.PROJECTNO and pa.PHYANTENNAPK = la.PHYANTENNAFK
                        INNER JOIN  ANTENNAPATTERN ap  on ap.PROJECTNO = la.PROJECTNO and la.anttypefk = ap.patternpk 
                        INNER JOIN ANTENNAPATTERN ap1 on ap1.PROJECTNO = pa.PROJECTNO and ap1.PATTERNPK = pa.MASTERPATTERN1FK
                        INNER JOIN ANTENNAPATTERN ap2 on ap2.PROJECTNO = pa.PROJECTNO and ap2.PATTERNPK = pa.MASTERPATTERN2FK
                        INNER JOIN ANTENNAPATTERN ap3 on ap3.PROJECTNO = pa.PROJECTNO and ap3.PATTERNPK = pa.MASTERPATTERN3FK
                        INNER JOIN ANTENNAPATTERN ap4 on ap4.PROJECTNO = pa.PROJECTNO and ap4.PATTERNPK = pa.MASTERPATTERN4FK
                        INNER JOIN antennaDevice ad on ad.PROJECTNO = pa.PROJECTNO and ad.DEVICEPK = pa.DEVICEFK
                        INNER JOIN network_planning.FLAGVALUES z ON c1.projectno = z.projectno AND c1.lognodepk = z.objectkey 
                        INNER JOIN network_planning.FLAGS y ON y.PROJECTNO = z.PROJECTNO AND y.FLAGGROUPKEY = z.FLAGGROUPKEY AND y.FLAGKEY = z.FLAGKEY 
                        INNER JOIN network_planning.FLAGGROUPS x ON x.PROJECTNO = y.PROJECTNO AND x.FLAGGROUPKEY = y.FLAGGROUPKEY
                        INNER JOIN network_planning.FLAGVALUES z1 ON c1.projectno = z1.projectno AND c2.logcellpk = z1.objectkey 
                        INNER JOIN network_planning.FLAGS y1 ON y1.PROJECTNO = z.PROJECTNO AND y1.FLAGGROUPKEY = z1.FLAGGROUPKEY AND y1.FLAGKEY = z1.FLAGKEY 
                        INNER JOIN network_planning.FLAGGROUPS x1 ON x1.PROJECTNO = y1.PROJECTNO AND x1.FLAGGROUPKEY = y1.FLAGGROUPKEY

                        where 
                        (x.flaggroupid = 'Candidate')  AND (y.flagid ='Accepted') 
                        AND (x1.flaggroupid = 'Site Progress') AND (y1.flagid ='On Air') 
                        AND (b1.PROJECTNO = 1) 
                        and c1.idname like '%@@@@@@%'

