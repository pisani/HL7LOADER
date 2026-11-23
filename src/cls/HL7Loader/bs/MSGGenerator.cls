Class HL7Loader.bs.BasicGenerator Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Parameter SETTINGS As %String = "MessageCount:Basic,MessageDelaySec:Basic,";

Property MessageDelaySec As %Integer [ InitialExpression = 5 ];

Property MessageCount As %Integer;

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	set crlf=$C(13,10)
	for i=1:1:..MessageCount {
	
		set msg="MSH|^~\&|HIS|MAYO|LIS|MAYO|202204150830^M|Security|ADT^A01|MSG003368|T|2.5|1863||||USA"
		set msg=msg_crlf_"EVN|A01|202204150830||C"
		set msg=msg_crlf_"PID|1|57508819^^^MAYO^MR^MAYO|57508819^^^MAYO^MR^MAYO||SANSON^ULYSSES^I|THOMAS|20020522^D|O||I|94 Pine Lane^^Oaklands Park^SA^5046^Australia|Oaklands Park|(286) 993-7515^^^test+57508819@intersystems.com|(286) 556-8472||D||ACCT000000000087|794863354|130192631^MN^07012016"
		set msg=msg_crlf_"PD1||||NPI-1015302422^LAWRANCE^ LARRY^^^^^^MAYO"
		set msg=msg_crlf_"NK1|0001|SANSON,QUINTON|OTHER||4445551212"
		set msg=msg_crlf_"PV1|1|E|N7^R416^B2^Mayo Clinic|Admission|||NPI-1015302422^LAWRANCE^LARRY^^^^^^MAYO|||C|||||B8||NPI-1015302422^LAWRANCE^LARRY^^^^MD^^MAYO|I|MAYO87784106759965232|||||||||||||||||||||||||202204150815"
		set msg=msg_crlf_"DG1|0001|IN|E10^Diabetes, Mellitus^ICD1|Diabetes, Mellitus||A||||||||||LAWRANCE, LARRY"
		set hl7=##class(EnsLib.HL7.Message).ImportFromString(msg)
		do ..SendRequestSync("test.Distribute",hl7)
		hang ..MessageDelaySec
		set ..%SessionId=""
	}
	Quit $$$OK
}

}
