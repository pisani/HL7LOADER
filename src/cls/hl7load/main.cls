Class hl7load.main Extends Ens.Production [ Not ProcedureBlock ]
{

Parameter SETTINGS = "ReArm All:HL7 Generation";

/// Prime all Business Services as 'enabled' in order to start sendingn messages
Property "ReArm All" As %Boolean;

/// This method is called when config changes to the Production or any item are saved from the portal
ClassMethod OnConfigChange(pProduction As Ens.Config.Production, pItem As Ens.Config.Item)
{
  for i=1:1:pProduction.Settings.Count() {
    set setting= pProduction.Settings.GetAt(i)
    if setting.Name="ReArm All",setting.Value=1 {
      // Enable all HL7 Generator services.
      job ##class(Ens.Director).EnableConfigItem(("Generate HL7 ORU_R01"), 1, 1) 
      job ##class(Ens.Director).EnableConfigItem(("Generate HL7 ADT_A01"), 1, 1) 
      job ##class(Ens.Director).EnableConfigItem(("Generate HL7 ADT_A08"), 1, 1) 
      job ##class(hl7load.main).resetReArm(0)
    }
  }
}

ClassMethod resetReArm(value)
{
  set p=##class(Ens.Config.Production).%OpenId("hl7load.main")
  set ns=1,ns(1)=$lb("Adapter","ReArm All",value)
  do p.UpdateSettings(.ns),p.%Save()
}

XData ProductionDefinition
{
<Production Name="hl7load.main" LogGeneralTraceEvents="false">
  <Description>Test Change. Sample to manage HL7 broadcast to target ports</Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Setting Target="Adapter" Name="ReArm All">0</Setting>
  <Item Name="Generate HL7 ORU_R01" Category="" ClassName="hl7load.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageVolume">50</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">3</Setting>
  </Item>
  <Item Name="Generate HL7 ADT_A01" Category="" ClassName="hl7load.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageVolume">25</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="HL7Type">ADT_A01</Setting>
  </Item>
  <Item Name="Generate HL7 ADT_A08" Category="" ClassName="hl7load.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageVolume">50</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">1</Setting>
    <Setting Target="Host" Name="HL7Type">ADT_A08</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5001" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="spisani-rh-loadbalancer-f0f698f4706c5fc7.elb.ap-southeast-2.amazonaws.com" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">5001</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5002" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="spisani-rh-loadbalancer-f0f698f4706c5fc7.elb.ap-southeast-2.amazonaws.com" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">5002</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="Other Devices 5000" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="spisani-rh-loadbalancer-f0f698f4706c5fc7.elb.ap-southeast-2.amazonaws.com" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">5000</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
</Production>
}

}
