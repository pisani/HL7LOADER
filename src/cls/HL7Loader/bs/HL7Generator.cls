Class HL7Loader.bs.HL7Generator Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Parameter SETTINGS = "MessageVolume:Basic,MessageSendDelay:Basic,Targets:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}:Basic,SampleMessagesClass:Basic,XDataBlockName:Basic, IncrementMessageID:Basic";

Property MessageVolume As %String [ InitialExpression = 1 ];

Property MessageSendDelay As %Integer(MINVAL = 0) [ InitialExpression = 1 ];

/// Name(S) of XDATA Block in this class to populate an HL7 message with. Requires corresponding PokeDocType configuration setting.
Property XDataBlockName As %String;

/// increment message header ID with each transmission
Property IncrementMessageID As %Boolean [ InitialExpression = 1 ];

/// Receiving HL7 target component
Property Targets As %String(MAXLEN = "");

Property MessageBatch As %String [ InitialExpression = {"BATCH"_$TR($zt($P($h,",",2),1),":")} ];

Property MessageCounter As %Integer [ MultiDimensional ];

Property MessageVolDistrib As %String [ MultiDimensional ];

/// Internal Sample messages class with HL7 messages under XDATA block to be used for testing
Property SampleMessagesClass As %String [ InitialExpression = "HL7Loader.hl7.samples" ];

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    hang ..MessageSendDelay   
    
    KILL ..MessageCounter  set ..MessageCounter=0
    
    set ..MessageVolDistrib=0

    // Cater for Split message count by type
    if ..MessageVolume["," {
        
        for block=1:1:$length(..XDataBlockName,",") {
            set ..MessageVolDistrib($piece(..XDataBlockName,",",block))=+$piece(..MessageVolume,",",block)
            set ..MessageVolDistrib=$g(..MessageVolDistrib)+$piece(..MessageVolume,",",block)
        }
    } else {
        set ..MessageVolDistrib=..MessageVolume
    }

    set crlf=$C(13,10)
    set SampleMessagesClass=..SampleMessagesClass set:SampleMessagesClass="" SampleMessagesClass=..%ClassName(1)

    do {
	
        for block=1:1:$length(..XDataBlockName,",") {
            set stream=""
            set XDataItem=$piece(..XDataBlockName,",",block) 

            continue:$get(..MessageVolDistrib(XDataItem))="done"  ; skip if we have sent enough of this type.

            set stream=##class(%Dictionary.XDataDefinition).%OpenId(SampleMessagesClass_"||"_XDataItem)
            if '$IsObject(stream) {
                $$$LOGALERT("XData Block "_XDataItem_" not found in class "_SampleMessagesClass) 
                set ..MessageVolDistrib(XDataItem)="done"
                continue
            }

            set hl7=##class(EnsLib.HL7.Message).ImportFromLibraryStream(stream.Data)
            
            set DocType=hl7.GetValueAt("1:12.1")_":"_$e(XDataItem,1,3)_"_"_$e(XDataItem,4,6) 
            do hl7.PokeDocType(DocType)  

            set ..MessageCounter=..MessageCounter+1
            set ..MessageCounter(XDataItem)=$get(..MessageCounter(XDataItem))+1

            // Incremenet Mesage ControlID 
            if ..IncrementMessageID {
                set mNum=$tr($j(..MessageCounter,$l(..MessageVolume)+1)," ","0")
                do hl7.SetValueAt(..MessageBatch_"."_mNum,"MSH:10")
                do hl7.%Save()
            }
            
            do ..ProcessMessageBeforeDispatch(.hl7,XDataItem)
            do hl7.%Save()
            
            
            // Send to all targets with each iteration.
            for i=1:1:$length(..Targets,",") {
                set target=$piece(..Targets,",",i)
                do ..SendRequestAsync(target,hl7)
                set ..%SessionId=""
            }
        }        
    
        // Continue if we have sent enough of this type.
        if ..MessageVolDistrib(XDataItem)=+$get(..MessageCounter(XDataItem)) set ..MessageVolDistrib(XDataItem)="done"

    } while ..MessageCounter<(..MessageVolDistrib) 
    
    /// disable item once done.
	hang ..MessageSendDelay
    Do ##class(Ens.Director).EnableConfigItem(..%ConfigName,0,1) 
   
    KILL ..MessageCounter
    set ..MessageCounter=0

    Quit $$$OK
}

Method ProcessMessageBeforeDispatch(ByRef hl7 As EnsLib.HL7.Message, XDataItem As %String = "") As %Status
{

	set currentIteration =..MessageCounter
	if XDataItem = "ORUR01" {
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

ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
    do ##super(.pArray,pItem)
    If pItem.GetModifiedSetting("Targets",.tValue) {
        For i=1:1:$L(tValue,",") {
            Set tOne=$ZStrip($P(tValue,",",i),"<>W")
            Continue:""=tOne
            Set pArray(tOne)=""
        }
    }
}
}
