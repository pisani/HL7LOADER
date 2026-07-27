Class HL7Loader.bs.INT009Generator Extends HL7Loader.bs.HL7Generator
{

/// Override this method to perform any pre-dispatch processing of ANY of the loaded HL7 messages.
/// This method is called for each message before it is sent to the target(s). The HL7 message is passed by reference and can be modified in place. 
/// The XDataItem parameter indicates which XData block the message was loaded from.    
/// NOTE:  HL7 MessageID is automatically incremented with each message and does not need to be done.
/// Use this method to (for example) randamise Patient or Provider name, or, Number of OBX segments and values.
Method OnBeforeDispatch(ByRef hl7 As EnsLib.HL7.Message, XDataItem As %String = "") As %Status
{

    // Add random amount of additional OBX Segments 
    set currentOBXCount=hl7.GetValueAt("PIDgrpgrp(1).ORCgrp(1).OBXgrp(*)")
    
	if XDataItem = "ORUR01v20" {
        set additionalOBXCount=20-currentOBXCount+1

	} elseif XDataItem = "ORUR01v40" {
        set additionalOBXCount=40-currentOBXCount+1

    } elseif XDataItem = "ORUR01v80" {
        set additionalOBXCount=90-currentOBXCount+1
    }


    do {
		// Perform Basic message variations	
		do hl7.SetValueAt($translate($zdt($h,3)," -:",""),"PIDgrpgrp(1).ORCgrpgrp(1).OBR:ObservationDateTime")
		
		// Add random results
        set obx(3)=8+$r(5)
        set obx(5)=60+$r(15)
        set obx(6)=40+$r(20)
        do hl7.SetValueAt(obx(3),"PIDgrpgrp(1).ORCgr(1).OBXgrp(3).OBX:5")
        do hl7.SetValueAt(obx(5),"PIDgrpgrp(1).ORCgr(1).OBXgrp(5).OBX:5")
        do hl7.SetValueAt(obx(6),"PIDgrpgrp(1).ORCgr(1).OBXgrp(6).OBX:5")

        set sampleOBX="OBX|$$$|ST|REPST^FBE Report Status^NATA555||$$$||||||C|||202605221622|LAB-2024-0815$$$^SYDNEY_PATHOLOGY^LAB"
        for i=currentOBXCount+1:1:(currentOBXCount+additionalOBXCount) {
            set newOBX=sampleOBX
            set $PIECE(newOBX,"|",2)=i
            set $PIECE(newOBX,"|",4)="SAMPLE^Sample Test^NATA555"
            set $PIECE(newOBX,"|",6)=$R(50)+1
            do hl7.SetValueAt(newOBX,"PIDgrpgrp(1).ORCgrp(1).OBXgrp("_i_").OBX")
        }
    } while 0
}

}
