Class HL7Loader.bs.INT007Generator Extends HL7Loader.bs.HL7Generator
{

/// arameter SETTINGS = "pdf1MB:Basic,pdf5MB:Basic,pdf10MB:Basic,pdf20MB:Basic,pdf40MB:Basic";
Property pdf1mb As %String(MAXLEN = "") [ InitialExpression = "C:\InterSystems\IRISHealth\mgr\user\sample_discharge_summary_1MB.pdf" ];

Property pdf5mb As %String(MAXLEN = "") [ InitialExpression = "C:\InterSystems\IRISHealth\mgr\user\sample_discharge_summary_5MB.pdf" ];

Property pdf10mb As %String(MAXLEN = "") [ InitialExpression = "C:\InterSystems\IRISHealth\mgr\user\sample_discharge_summary_10MB.pdf" ];

Property pdf20mb As %String(MAXLEN = "") [ InitialExpression = "C:\InterSystems\IRISHealth\mgr\user\sample_discharge_summary_20MB.pdf" ];

Property pdf40mb As %String(MAXLEN = "") [ InitialExpression = "C:\InterSystems\IRISHealth\mgr\user\sample_discharge_summary_40MB.pdf" ];

/// Override this method to perform any pre-dispatch processing of ANY of the loaded HL7 messages.
/// This method is called for each message before it is sent to the hl7(s). The HL7 message is passed by reference and can be modified in place. 
/// The XDataItem parameter indicates which XData block the message was loaded from.    
/// NOTE:  HL7 MessageID is automatically incremented with each message and does not need to be done.
/// Use this method to (for example) randamise Patient or Provider name, or, Number of OBX segments and values.
/// 
/// Add 1/5/10/20/40 MB PDF attachements to OBX
/// 
Method OnBeforeDispatch(ByRef hl7 As EnsLib.HL7.Message, XDataItem As %String = "") As %Status
{
    // Perform Basic message variations	
    do hl7.SetValueAt($translate($zdt($h,3)," -:",""),"PIDgrpgrp(1).ORCgrpgrp(1).OBR:ObservationDateTime")
    
    // Remove existing OBX segments
    for i=1:1:hl7.GetValueAt("PIDgrpgrp(1).ORCgrp(1).OBXgrp(*)") {
        do hl7.RemoveSegmentAt("PIDgrpgrp(1).ORCgrp(1).OBXgrp("_i_").OBX")
    }

    set pdfStream=##class(%Stream.FileBinary).%New()

    if XDataItem = "ORUR01v1MB" {
        do pdfStream.LinkToFile(..pdf1mb)
    } elseif XDataItem = "ORUR01v5MB" {
        do pdfStream.LinkToFile(..pdf5mb)
    } elseif XDataItem = "ORUR01v10MB" {
        do pdfStream.LinkToFile(..pdf10mb)
    } elseif XDataItem = "ORUR01v20MB" {
        do pdfStream.LinkToFile(..pdf20mb)
    } elseif XDataItem = "ORUR01v40MB" {
        do pdfStream.LinkToFile(..pdf40mb)
    } 

    do pdfStream.Rewind()
    set cleanFilename=##class(%File).GetFilename(pdfStream.Filename)

    set obxStart=hl7.GetValueAt("PIDgrpgrp(1).ORCGrp(1).OBXgrp(*)")+1

    ; in Chunks:
    set base64=##class(%SYSTEM.Encryption).Base64EncodeStream(pdfStream)
    for idOBX=obxStart:1 {
        set pdfPart=base64.Read(30000) quit:pdfPart=""
        // set OBX properties
        do hl7.SetValueAt(idOBX,"PIDgrpgrp(1).ORCgrp(1).OBXgrp("_idOBX_").OBX:SetIDOBX")
        do hl7.SetValueAt("ED","PIDgrpgrp(1).ORCgrp(1).OBXgrp("_idOBX_").OBX:2")
        do hl7.SetValueAt("51852-2^"_cleanFilename_"^LOINC","PIDgrpgrp(1).ORCgrp(1).OBXgrp("_idOBX_").OBX:3")
        // set OBX PDF Part (chunk)
        do hl7.SetValueAt("^^PDF^BASE64^"_pdfPart,"PIDgrpgrp(1).ORCgrp(1).OBXgrp("_idOBX_").OBX:ObservationValue")
    }

    /*
    ; in Full
        do hl7.SetValueAt(idOBX,"PIDgrpgrp(1).ORCgrp(1).OBXgrp("_idOBX_").OBX:SetIDOBX")
        do hl7.SetValueAt("ED","PIDgrpgrp(1).ORCgrp(1).OBXgrp("_idOBX_").OBX:2")
        do hl7.SetValueAt("51852-2^"_cleanFilename_"^LOINC","PIDgrpgrp(1).ORCgrp(1).OBXgrp("_idOBX_").OBX:3")
        /// copy '^^PDF^BASE64^' to the front of stream before adding.
        do hl7.StoreFieldStreamBase64(pdfStream,"OBX(1):ObservationValue")
    */
}

}
