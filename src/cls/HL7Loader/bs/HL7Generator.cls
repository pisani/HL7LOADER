Class HL7Loader.bs.HL7Generator Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Parameter SETTINGS = "MessageVolume:Basic,MessageSendDelay:Basic,TargetConfigNames:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}:Basic,DocType:Basic,XDataBlockName:Basic, IncrementMessageID:Basic";

Property MessageVolume As %Integer(MINVAL = 1) [ InitialExpression = 1 ];

Property MessageSendDelay As %Integer(MINVAL = 0) [ InitialExpression = 1 ];

/// Version:DocStructure to poke HL7 message retrieved from XDATA block specified in class and referenced in setting XDataBlockName
Property DocType As %String;

/// Name of XDATA Block in this class to populate an HL7 message with. Requires corresponding PokeDocType configuration setting.
Property XDataBlockName As %String;

/// increment message header ID with each transmission
Property IncrementMessageID As %Boolean [ InitialExpression = 1 ];

/// Receiving HL7 target component
Property TargetConfigNames As %String(MAXLEN = "");

Property MessageCounter As %Integer [ InitialExpression = 0 ];

Property MessageBatch As %String [ InitialExpression = {"BATCH"_$TR($zt($P($h,",",2),1),":")} ];

Property SampleMessagesClass As %String [ InitialExpression = "HL7Loader.hl7.samples.cls" ];

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    	
    do {
	    
        hang ..MessageSendDelay   

        set crlf=$C(13,10)
        set SampleMessagesClass=..SampleMessagesClass set:SampleMessagesClass="" SampleMessagesClass=..%ClassName(1)
		set stream=##class(%Dictionary.XDataDefinition).%OpenId(SampleMessagesClass_"||"_..XDataBlockName)
    	do stream.Data.Rewind()
    	set hl7=##class(EnsLib.HL7.Message).ImportFromLibraryStream(stream.Data)
    	
    	do hl7.PokeDocType(..DocType)  
   
        set ..MessageCounter=..MessageCounter+1

        // Incremenet Mesage ControlID 
        if ..IncrementMessageID {
        	set mNum=$tr($j(..MessageCounter,$l(..MessageVolume)+1)," ","0")
        	do hl7.SetValueAt(..MessageBatch_"."_mNum,"MSH:10")
        	do hl7.%Save()
        	;w !,mNum," ",hl7.GetValueAt("1:10")
        }
        
        do ..ProcessMessageBeforeDispatch(.hl7)
        do hl7.%Save()
        
        
        // Send to all targets with each iteration.
        for i=1:1:$length(..TargetConfigNames,",") {
	        set target=$piece(..TargetConfigNames,",",i)
        	do ..SendRequestAsync(target,hl7)
        	set ..%SessionId=""
        }
        
    
    } while ..MessageCounter<(..MessageVolume) 
    
    /// disable item once done.
	hang ..MessageSendDelay
    Do ##class(Ens.Director).EnableConfigItem(..%ConfigName,0,1) 
   
    set ..MessageCounter=0

    Quit $$$OK
}

Method ProcessMessageBeforeDispatch(ByRef hl7 As EnsLib.HL7.Message)
{

	set currentIteration =..MessageCounter
	if ..XDataBlockName = "ORUR01" {
		// Vary the message sample in xdata block ORUR01
		
		do hl7.SetValueAt($translate($zdt($h,3)," -:",""),"PIDgrpgrp(1).ORCgrpgrp(1).OBR:ObservationDateTime")
		
		// Add random results
        set obx(3)=8+$r(5)
        set obx(5)=60+$r(15)
        set obx(6)=40+$r(20)
        do hl7.SetValueAt(obx(3),"PIDgrpgrp(1).ORCgrpgrp(1).OBXgrp(3).OBX:5")
        do hl7.SetValueAt(obx(5),"PIDgrpgrp(1).ORCgrpgrp(1).OBXgrp(5).OBX:5")
        do hl7.SetValueAt(obx(6),"PIDgrpgrp(1).ORCgrpgrp(1).OBXgrp(6).OBX:5")
		
	}
}

Method OnStart() As %Status
{
    set ..MessageCounter=0
    quit $$$OK
}

}
