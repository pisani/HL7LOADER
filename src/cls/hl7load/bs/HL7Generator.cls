Class hl7load.bs.HL7Generator Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Parameter SETTINGS = "MessageVolume:Basic,MessageSendDelay:Basic,HL7Type:Basic";

Property MessageVolume As %Integer(MINVAL = 1) [ InitialExpression = 1 ];

Property MessageSendDelay As %Integer(MINVAL = 0) [ InitialExpression = 1 ];

Property HL7Type As %String(VALUELIST = ",ORU_R01,ADT_A01,ADT_A08") [ InitialExpression = "ORU_R01" ];

Property MessageCounter As %Integer [ InitialExpression = 0 ];

Property MessageBatch As %String [ InitialExpression = {"BATCH"_$TR($zt($P($h,",",2),1),":")} ];

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    	
    do {
        hang ..MessageSendDelay

        set hl7=..getMsg(..HL7Type,.target) 
        set ..MessageCounter=..MessageCounter+1

        // Incremenet Mesage ControlID 
        set mNum=$tr($j(..MessageCounter,$l(..MessageVolume)+1)," ","0")
        do hl7.SetValueAt(..MessageBatch_"."_mNum,"MSH:10")
        do hl7.%Save()
        w !,mNum," ",hl7.GetValueAt("1:10")

        // Send..
        do ..SendRequestSync(target,hl7)
        set ..%SessionId=""
        
    
    } while ..MessageCounter<(..MessageVolume) 
    
    /// disable item once done.
    Do ##class(Ens.Director).EnableConfigItem(("Generate HL7 "_..HL7Type), 0, 1) 
    set ..MessageCounter=0

    Quit $$$OK
}

ClassMethod getMsg(type, ByRef target) As EnsLib.HL7.Message
{

	set crlf=$C(13,10)

    if type="ADT_A01" {
        
        set msg="MSH|^~\&|MEDITECH^QLD||||201707211356||ADT^A01|8883760|P|2.4|||AL|NE|"
        set msg=msg_crlf_"EVN||201707211356||||201707211356|"
        set msg=msg_crlf_"PID|1||NN00123154^^^^MR^STA~22222222002^^^^SS^STA~NN112981^^^^PI^STA||STANTON^DOREEN^^^^^L||19490628|F||AUS|67 PISTOL CORNER^^ERRINUNDRA^VIC^3889||03 1375 7635||ENG|MAR|COE|BN01305697|2222222200|"
        set msg=msg_crlf_"PD1||"
        set msg=msg_crlf_"NK1|1|PAUL^FELIX^|HUS^Husband|67 PISTOL CORNER^^ERRINUNDRA^VIC^3889|03 1375 7635|0484 710 227|NOK|"
        set msg=msg_crlf_"NK1|2|PAUL^FELIX^|HUS^Husband|67 PISTOL CORNER^^ERRINUNDRA^VIC^3889|03 1375 7635|0484 710 227|NOT|"
        set msg=msg_crlf_"PV1|1|I|STADONC^STAICO01^001|CHE|||VASPAU00P^Vasey^Paul^A^^^^^^^^^ONC^^^Oncologist|4BHARAJ002^BHARATHI^RAJINI||AONC|||2|HPO|||VASPAU00P^Vasey^Paul^A|IN|BN01305697|NIB|||||||||||||||||||STA||ADM|||201707211356|"
        set msg=msg_crlf_"PV2||ADAYMED^Day Medical|NIVOLUMAB|||||20170721||||||||||||||||ADM IN|"
        set msg=msg_crlf_"IN1|1|HFNIB||NIB Health Fund|Locked Bag 2010^^Newcastle^NSW^2300||+1300 853 530|||||||||PARKER^WENDY|SEL||||||||||||20170717|STASHA01||||||11223344|||||||||VERIFIED|"

        set hl7=##class(EnsLib.HL7.Message).ImportFromString(msg)
    	do hl7.PokeDocType("2.4:ADT_A01")  
        
        set target="HL7 Dispatch 5002"
        quit hl7

    } elseif type="ADT_A08" {

        set msg="MSH|^~\&|MEDITECH^QLD||||201707211356||ADT^A08|8883746|P|2.4|||AL|NE|"
        set msg=msg_crlf_"EVN||201707211355||||201707251355|"
        set msg=msg_crlf_"PID|1||ON01037888^^^^MR^PGC~22222222002^^^^SS^PGC~ON303232^^^^PI^PGC~22222222004^^^^PEN^PGC||SLADE^TAYLOR^^^^^L||19480601|M||AUS|83 GALLAGHER BYPASS^^MOSSMAN^QLD^4873||07 6533 1566||ENG|MAR|COE|CN03208410|2222222200|"
        set msg=msg_crlf_"PD1||"
        set msg=msg_crlf_"NK1|1|SCHOFIELD^CATERINA^|WIF^Wife|83 GALLAGHER BYPASS^^MOSSMAN^QLD^4873|07 6533 1566|0474 050 753|NOK|"
        set msg=msg_crlf_"NK1|2|SCHOFIELD^CATERINA^|WIF^Wife|83 GALLAGHER BYPASS^^MOSSMAN^QLD^4873|07 6533 1566|0474 050 753|NOT|"
        set msg=msg_crlf_"PV1|1|P||ELE|||RICHEN00P^Rice^Henry(Hal)^A^^^^^^^^^RAD^^^Radiologist|4FELSOR004^FELIX^SORAYA||ADAY03|||1|HPO|||RICHEN00P^Rice^Henry(Hal)^A|IN|CN03208410|NIB|||||||||||||||||||PGC||PRE|||201707251355|"
        set msg=msg_crlf_"PV2|||PORTACATH INSERTION|||||20170725||||||||||||||||PRE IN|"
        set msg=msg_crlf_"OBX|1|TX|ADACCID^Accident/Emergency^ADM||^N||||||F|"
        set msg=msg_crlf_"OBX|2|CE|ADBARR^Arrival Mode^ADM||PRV^Private Transport||||||F|"
        set msg=msg_crlf_"OBX|3|CE|ADCOMPEN^Compensable Status^ADM||N^No||||||F|"
        set msg=msg_crlf_"OBX|4|CE|ADDISINT^Discharge Intention^ADM||UR^Usual Residence||||||F|"
        set msg=msg_crlf_"OBX|5|TX|ADMCOM^Admission Comments^ADM||19/7/17||||||F|"
        set msg=msg_crlf_"OBX|6|CE|ADPTAUSSSI^Aust.South Sea Islander^ADM||N^No||||||F|"
        set msg=msg_crlf_"OBX|7|TX|ADPTDVACAR^DVA Card^ADM||||||||F|"
        set msg=msg_crlf_"OBX|8|TX|ADPTDVAESO^ESO Visit?^ADM||||||||F|"
        set msg=msg_crlf_"OBX|9|TX|ADPTDVAFOR^Force^ADM||||||||F|"
        set msg=msg_crlf_"OBX|10|TX|ADPTDVANUM^DVA Card #^ADM||||||||F|"
        set msg=msg_crlf_"OBX|11|TX|ADPTDVARSO^RSO^ADM||||||||F|"
        set msg=msg_crlf_"OBX|12|TX|ADPTDVATPI^TPI?^ADM||||||||F|"
        set msg=msg_crlf_"OBX|13|TX|ADPTDVAWID^War Widow?^ADM||||||||F|"
        set msg=msg_crlf_"OBX|14|CE|ADPTEMPSTA^Employment Status^ADM||RET^Retired for age||||||F|"
        set msg=msg_crlf_"OBX|15|TX|ADPTEXPBDN^Bed^ADM||||||||F|"
        set msg=msg_crlf_"OBX|16|TX|ADPTEXPCOM^Comment^ADM||^ADM 24.07 FOR OT 25.07||||||F|"
        set msg=msg_crlf_"OBX|17|TX|ADPTEXPDAT^Date^ADM||^20170724||||||F|"
        set msg=msg_crlf_"OBX|18|CE|ADPTEXPLOC^Proposed Adm Loc^ADM||PGCDDAY^Day Surgery Unit||||||F|"
        set msg=msg_crlf_"OBX|19|CE|ADPTEXPPOL^Post Op Location^ADM||PGCDDAY^Day Surgery Unit||||||F|"
        set msg=msg_crlf_"OBX|20|TX|ADPTEXPTI^Time^ADM||^0730||||||F|"
        set msg=msg_crlf_"OBX|21|CE|ADPTINDIG^Indigenous Status^ADM||NEI^Neither Aborig or Torres||||||F|"
        set msg=msg_crlf_"OBX|22|TX|ADPTINTERP^Interpreter Required^ADM||^N||||||F|"
        set msg=msg_crlf_"OBX|23|CE|ADPTINTLOS^Intended LOS^ADM||SAM^Sameday Patient||||||F|"
        set msg=msg_crlf_"OBX|24|CE|ADPTLANG^Language Spoken at Home^ADM||ENG^English||||||F|"
        set msg=msg_crlf_"OBX|25|CE|ADPTMCELI^MC Elig Status^ADM||ELI^Eligible||||||F|"
        set msg=msg_crlf_"OBX|26|TX|ADPTMCEXP^MC Expiry^ADM||^08/2020||||||F|"
        set msg=msg_crlf_"OBX|27|TX|ADPTMCREF^MC Ref #^ADM||^12345678||||||F|"
        set msg=msg_crlf_"OBX|28|TX|ADPTOUTBAL^Print Outstanding Balances?^ADM||^N||||||F|"
        set msg=msg_crlf_"OBX|29|TX|ADPTPENS^Pension/HCC #^ADM||^12345678||||||F|"
        set msg=msg_crlf_"OBX|30|TX|ADPTPENSTA^Pension Status^ADM||||||||F|"
        set msg=msg_crlf_"OBX|31|TX|ADPTPHABEN^Phar Benefit #^ADM||||||||F|"
        set msg=msg_crlf_"OBX|32|TX|ADPTPRIGAL^Consent to receiving Gallipoli Medical Research Fdt Info^ADM||^N||||||F|"
        set msg=msg_crlf_"OBX|33|TX|ADPTPRIVET^Consent to Visit by Member of Veteran Community^ADM||^N||||||F|"
        set msg=msg_crlf_"OBX|34|TX|ADPTSNET^Safety Net #^ADM||||||||F|"
        set msg=msg_crlf_"OBX|35|TX|ADPTVISHIS^Print Visit History?^ADM||^N||||||F|"
        set msg=msg_crlf_"OBX|36|CE|ADPTXFERT^Transfer Type (In)^ADM||X^Unknown||||||F|"
        set msg=msg_crlf_"OBX|37|TX|ADSNTITLE^Title^ADM||||||||F|"
        set msg=msg_crlf_"OBX|38|TX|BAFROMDAT1^1.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|39|TX|BAFROMDAT2^2.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|40|TX|BAFROMDAT3^3.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|41|TX|BAFROMDAT4^4.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|42|TX|BAHOSP1^1.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|43|TX|BAHOSP2^2.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|44|TX|BAHOSP3^3.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|45|TX|BAHOSP4^4.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|46|TX|BATHRUDAT1^1.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|47|TX|BATHRUDAT2^2.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|48|TX|BATHRUDAT3^3.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|49|TX|BATHRUDAT4^4.^ADM||||||||F|"
        set msg=msg_crlf_"OBX|50|TX|ZABREADM28^Readmission within 28 days^ADM||^N||||||F|"
        set msg=msg_crlf_"OBX|51|CE|ZABREADMT^Type^ADM||NRA^No Readmission||||||F|"
        set msg=msg_crlf_"OBX|52|TX|ZADGFAXP^Guar Fax^ADM||||||||F|"
        set msg=msg_crlf_"OBX|53|TX|ZADGOTHP^Guar  O#^ADM||^0474 050 753||||||F|"
        set msg=msg_crlf_"OBX|54|CE|ZADGTITLE^Guar Title^ADM||MR^MR||||||F|"
        set msg=msg_crlf_"OBX|55|TX|ZADGWORKP^Work Ph^ADM||||||||F|"
        set msg=msg_crlf_"OBX|56|CE|ZADNKLANG^Language^ADM||ENG^English||||||F|"
        set msg=msg_crlf_"OBX|57|TX|ZADNKOTHPH^Other Ph^ADM||^07 6533 1566||||||F|"
        set msg=msg_crlf_"OBX|58|CE|ZADNKTITLE^Title^ADM||MRS^MRS||||||F|"
        set msg=msg_crlf_"OBX|59|CE|ZADPNLANG^Language^ADM||ENG^English||||||F|"
        set msg=msg_crlf_"OBX|60|TX|ZADPNOTHPH^Other Ph^ADM||^0474 050 753||||||F|"
        set msg=msg_crlf_"OBX|61|CE|ZADPNTITLE^Title^ADM||MRS^MRS||||||F|"
        set msg=msg_crlf_"OBX|62|TX|ZADPTBPAY^BPAY Number^ADM||^888888||||||F|"
        set msg=msg_crlf_"OBX|63|TX|ZADPTCHAP^Consent Chaplain Visit^ADM||^N||||||F|"
        set msg=msg_crlf_"OBX|64|CE|ZADPTTITLE^Pt Title^ADM||MR^MR||||||F|"
        set msg=msg_crlf_"OBX|65|TX|ZBAACC^Requested Accommodation^ADM||^000 EIT||||||F|"
        set msg=msg_crlf_"OBX|66|TX|ZADPTOTHPH^Patient Other Phone^ADM||^07 6533 1566||||||F|"
        set msg=msg_crlf_"OBX|67|TX|ZABSSTATUS^ABS Patient Status^ABS||^NONE||||||F|"
        set msg=msg_crlf_"OBX|68|TX|ZHIMRECLOC^HIM MR Location^HIM||^PGCPAC||||||F|"
        set msg=msg_crlf_"OBX|69|TX|ZADCAPPED^^INS^^^HFNIB||^1000.00||||||F|"
        set msg=msg_crlf_"OBX|70|CE|ZADCOVLEV^Level of cover from Insurance^INS^^^HFNIB||NIB MIDP^Mid Plus||||||F|"
        set msg=msg_crlf_"OBX|71|TX|ZADELISRC^Eligibility Source^INS^^^HFNIB||||||||F|"
        set msg=msg_crlf_"OBX|72|TX|ZADFIN^Financial^INS^^^HFNIB||^Y||||||F|"
        set msg=msg_crlf_"OBX|73|TX|ZADICOPMAX^Copay Max^INS^^^HFNIB||^0.00||||||F|"
        set msg=msg_crlf_"OBX|74|TX|ZADINFO^Information provided by:^INS^^^HFNIB||^500.00||||||F|"
        set msg=msg_crlf_"OBX|75|TX|ZADMTOT^MAX COPAY^INS^^^HFNIB||^0.00||||||F|"
        set msg=msg_crlf_"OBX|76|TX|ZADREST^Restrictions^INS^^^HFNIB||CAT||||||F|"
        set msg=msg_crlf_"OBX|77|TX|ZADSUBPEA^Subject to PEA^INS^^^HFNIB||^N||||||F|"
        set msg=msg_crlf_"OBX|78|TX|ZADTHEACOP^Theatre Copay^INS^^^HFNIB||^0.00||||||F|"
        set msg=msg_crlf_"OBX|79|TX|ZBAREST^Billing Restrictions^INS^^^HFNIB||^N||||||F|"
        set msg=msg_crlf_"OBX|80|TX|ZGP_CODE||4FELSOR004_200088RL^FELIX^SORAYA^^^^SHOP 47 NICCON PLAZA^19 VICTORIA AVE^BROADBEACH^4218^QLD|"
        set msg=msg_crlf_"IN1|1|HFNIB||NIB Health Fund|Locked Bag 2010^^Newcastle^NSW^2300||+1300 853 530||||||||||||||||||||||20170719|COTCAR00||||||11223344|||||||||VERIFIED|"

        set hl7=##class(EnsLib.HL7.Message).ImportFromString(msg)
    	do hl7.PokeDocType("2.4:ADT_A08")  

        set target="HL7 Dispatch 5002"
        quit hl7

    } elseif type="ORU_R01" {
       	set msg="MSH|^~\&|LabSystemA|D227|||20250319100000||ORU^R01|Q3577075326T6038788633||2.4||||||8859/1"
        set msg=msg_crlf_"PID|1|AA816402^^^D227^MRN|AA816402^^^D227^MR~AA8571947^^^EMRUPI^CMRN||WARDTRF^MyEdDr^^^^^L||19990425|1||||||||||18984841^^^CD:313339243^CD:91|||||||0"
        set msg=msg_crlf_"PD1|||^^0"
        set msg=msg_crlf_"PV1|1|E|Emergency^^^D227^^Ambulatory(s)^Northmead OPD||||AA784033856^^^UWMC^MR^UWMC~2348062L^SMITH^MATTHEW^^^^^^A208 RP^P^^^DOCNUM~|||EMG|Emergency^^^^^Ambulatory(s)||||||2348062L^SMITH^MATTHEW^^^^^^A208 RP^P^^^DOCNUM~BNK/RPAH^SMITH^MATTHEW^^^^^^CD:18500574^P^^^DOCUPIN~MED0001190654^SMITH^MATTHEW^^^^^^CD:13639^P^^^DOCDEA~2348064K^SMITH^MATTHEW^^^^^^D227 BK^P^^^DOCNUM~234806^SMITH^MATTHEW^^^^^^CD:18500574^P^^^DOCUPIN~2132033^SMITH^MATTHEW^^^^^^^P^^^Healthe Prescriber Id~25050482^SMITH^MATTHEW^^^^^^^P^^^PRSNLID|E|6563182^^^CD:13644370^VID||||||||||||||||||||D227||Active|||20240404125200"
        set msg=msg_crlf_"OBR|1||28530551747^HNAM_RESULT_GROUP_ID|VITALSIGNS Pass1|||20240404125400|||||||||60114881^Alvarez^Tryston^^^^^^^P^^^PRSNLID||||||20240404125529||LAB|Final"
        set msg=msg_crlf_"OBX|1|NUM|5812702^Respiratory Rate|9941526049|18|br pm^br pm|10-25^10^25|NORMAL|||Final|||20240404125424||60114881^Alvarez^Tryston^^^^^^^P^^^PRSNLID"
        set msg=msg_crlf_"OBX|2|NUM|5846800^SpO2|9941526051|96|%^%|95-100^95^100|NORMAL|||Final|||20240404125424||60114881^Alvarez^Tryston^^^^^^^P^^^PRSNLID"
        set msg=msg_crlf_"OBX|3|NUM|5812693^Pulse Rate|9941526055|78|bpm^bpm|50-120^50^120|NORMAL|||Final|||20240404125424||60114881^Alvarez^Tryston^^^^^^^P^^^PRSNLID"


        set hl7=##class(EnsLib.HL7.Message).ImportFromString(msg)
    	do hl7.PokeDocType("2.4:ORU_R01")  

        // Add random results
        set obx(1)=11+$r(15)
        set obx(2)=95+$r(5)
        set obx(3)=50+$r(70)
        do hl7.SetValueAt(obx(1),"PIDgrpgrp(1).ORCgrp(1).OBXgrp(1).OBX:5")
        do hl7.SetValueAt(obx(2),"PIDgrpgrp(1).ORCgrp(1).OBXgrp(2).OBX:5")
        do hl7.SetValueAt(obx(3),"PIDgrpgrp(1).ORCgrp(1).OBXgrp(3).OBX:5")

        set target="HL7 Dispatch 5001"
        quit hl7
    
    }
}

Method OnStart() As %Status
{
    set ..MessageCounter=0
    quit $$$OK
}

}
