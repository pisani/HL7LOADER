/// 
Class HL7Loader.bpl.DistributeBPL Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.HL7.Message' response='EnsLib.HL7.Message' height='2000' width='2000' >
<context>
<property name='targetBOIdx' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='450' >
<code name='get target BO' xpos='200' ypos='250' >
<![CDATA[ set context.targetBOIdx=(process.%SessionId#4)+1
 ]]>
</code>
<call name='Target' target='@("TCPOut_"_context.targetBOIdx)' async='1' xpos='200' ypos='350' >
<request type='EnsLib.HL7.Message' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='EnsLib.HL7.Message' />
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
