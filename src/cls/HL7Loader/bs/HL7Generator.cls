Class HL7Loader.bs.HL7Generator Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Parameter SETTINGS = "MessageVolume:Basic,MessageSendDelay:Basic,Targets:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},SampleMessagesClass:Basic,XDataBlockName:Basic, IncrementMessageID:Basic";

Property MessageVolume As %String [ InitialExpression = 1 ];

Property MessageSendDelay As %Integer(MINVAL = 0) [ InitialExpression = 1 ];

/// Name(S) of XDATA Block in this class to populate an HL7 message with. Requires corresponding PokeDocType configuration setting.
Property XDataBlockName As %String(MAXLEN="");

Property CleanXDataBlockNames as %String(MAXLEN="");

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
    
    KILL ..MessageCounter  
    set ..MessageCounter=0
    set ..MessageVolDistrib=0
    
    set xx=($TR(..XDataBlockName,$C(10),"$"))  ; Add true line seperator
    set xx=$tr(xx,",","")  ; remove commas
    set ..CleanXDataBlockNames=$tr(xx,"$",",") ; put in commas for true item distinction
    $$$TRACE(xx)

    // Cater for Split message count by type
    if ..MessageVolume["," {
        
        for block=1:1:$length(..CleanXDataBlockNames,",") {
            set itemCount=+$piece(..MessageVolume,",",block),itemCount=$select(itemCount<1:"done",1:itemCount)

            set ..MessageVolDistrib($piece(..CleanXDataBlockNames,",",block))=itemCount
            set ..MessageVolDistrib=$g(..MessageVolDistrib)+(+itemCount) 
        }
    } else {
        set ..MessageVolDistrib=..MessageVolume  ; if not sending different per Message volumes, then the total = MessagVolume
    }
    
    set crlf=$C(13,10)
    set SampleMessagesClass=..SampleMessagesClass set:SampleMessagesClass="" SampleMessagesClass=..%ClassName(1)

    do {
	
        for block=1:1:$length(..CleanXDataBlockNames,",") {
            set stream=""
            set XDataItem=$piece(..CleanXDataBlockNames,",",block) 

            set stream=##class(%Dictionary.XDataDefinition).%OpenId(SampleMessagesClass_"||"_XDataItem)
            if '$IsObject(stream) {
                $$$LOGALERT("XData Block "_XDataItem_" not found in class "_SampleMessagesClass) 
                continue
            }

            continue:$get(..MessageVolDistrib(XDataItem))="done"  ; skip if we have sent enough of this type.
            $$$TRACE("Processing "_XDataItem_" in loop: "_(..MessageCounter+1) )

            set hl7=##class(EnsLib.HL7.Message).ImportFromLibraryStream(stream.Data)
            
            set DocType=hl7.GetValueAt("1:12.1")_":"_$e(XDataItem,1,3)_"_"_$e(XDataItem,4,6) 
            do hl7.PokeDocType(DocType)  


            // Incremenet Mesage ControlID 
            if ..IncrementMessageID {
                set mNum=$tr($j(..MessageCounter,$l(..MessageVolume)+1)," ","0")  //<fix this
                do hl7.SetValueAt(..MessageBatch_"."_mNum,"MSH:10")
                do hl7.%Save()
            }
            
            do ..OnBeforeDispatch(.hl7,XDataItem)
            do hl7.%Save()
            
            
            // Send to all BUSINESS HOST targets with each iteration.
            for i=1:1:$length(..Targets,",") {
                set target=$piece(..Targets,",",i)
                do ..SendRequestAsync(target,hl7)
                set ..%SessionId=""
            }

            set ..MessageCounter=..MessageCounter+1  ; add overall counter sent
            set ..MessageCounter(XDataItem)=$get(..MessageCounter(XDataItem))+1  ; add counter by XDataItem

        }        
    
        // if we have sent enough of this type, mark it as done for the next loop.
        if +$g(..MessageVolDistrib(XDataItem))=$get(..MessageCounter(XDataItem)) set ..MessageVolDistrib(XDataItem)="done"

    } while ..MessageCounter<(..MessageVolDistrib-1)
    
    /// disable item once done.
	hang ..MessageSendDelay
    Do ##class(Ens.Director).EnableConfigItem(..%ConfigName,0,1) 
    hang 2
    KILL ..MessageCounter
    set ..MessageCounter=0

    Quit $$$OK
}

/// Override this method to perform any pre-dispatch processing of ANY of the loaded HL7 messages.
/// This method is called for each message before it is sent to the target(s). The HL7 message is passed by reference and can be modified in place. 
/// The XDataItem parameter indicates which XData block the message was loaded from.    
/// NOTE:  HL7 MessageID is automatically incremented with each message and does not need to be done.
/// Use this method to (for example) randamise Patient or Provider name, or, Number of OBX segments and values.
Method OnBeforeDispatch(ByRef hl7 As EnsLib.HL7.Message, XDataItem As %String = "") As %Status
{

	if XDataItem = "ORUR01" {
		// Perform Basic message variations	
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
