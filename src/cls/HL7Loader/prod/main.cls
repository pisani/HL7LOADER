Class HL7Loader.prod.main Extends Ens.Production [ Not ProcedureBlock ]
{

Parameter SETTINGS = "ReArm:ReArm Details,Services:ReArm Details:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?services=1&productionName=@productionId}";

/// Enable re-enabling armed services
Property ReArm As %Boolean;

/// Specify the Business Service to rearm, - use wildcardsPATTERN Matching to identify services to re-arm
Property Services As %Library.String(MAXLEN = 2048);

Property TargetConfigNames As %Library.String(MAXLEN = 2048);

/// This method is called when config changes to the Production or any item are saved from the portal
ClassMethod OnConfigChange(pProduction As Ens.Config.Production, pItem As Ens.Config.Item)
{
  for i=1:1:pProduction.Settings.Count() {
    set setting= pProduction.Settings.GetAt(i)
    if setting.Name="ReArm",setting.Value=1 {
      // Enable all HL7 Generator services.
      do ..QueueReArm(pProduction)
      job ##class(HL7Loader.prod.main).resetReArm(0)
    }
  }
}

ClassMethod QueueReArm(pProduction)
{
  // Open the production
  for i=1:1:pProduction.Settings.Count() {
    set setting=pProduction.Settings.GetAt(i)
    if setting.Name="Services" {
        set ReArmServices=setting.Value
        for j=1:1:$length(ReArmServices,",") {
          // Enable the service
          job ##class(Ens.Director).EnableConfigItem($piece(ReArmServices,",",j), 1, 1)
        }
        quit
      }    
    }
}

ClassMethod resetReArm(value)
{
  set p=##class(Ens.Config.Production).%OpenId("HL7Loader.prod.main")
  set ns=1,ns(1)=$lb("Adapter","ReArm",value)
  do p.UpdateSettings(.ns),p.%Save()
}

XData ProductionDefinition
{
<Production Name="HL7Loader.prod.main" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description>Test Change. Sample to manage HL7 broadcast to target ports</Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Setting Target="Adapter" Name="ReArm All">0</Setting>
  <Setting Target="Adapter" Name="ReArmPatternMatch"></Setting>
  <Item Name="HL7 Dispatch 5001" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="15.134.154.17" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5001</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5002" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="15.134.154.17" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5002</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5003" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5003</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5004" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5004</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5005" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5005</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5006" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5006</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5007" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5007</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5008" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5008</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5009" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5009</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5010" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5010</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5011" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5011</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5012" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5012</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5013" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5013</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="TEST1_INT002" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST1</Setting>
    <Setting Target="Host" Name="MessageVolume">4</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5002</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01,ORUR01,ORMR01</Setting>
  </Item>
  <Item Name="TEST2_INT004" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST2</Setting>
    <Setting Target="Host" Name="MessageVolume">10</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5004</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01</Setting>
  </Item>
  <Item Name="TEST2_INT005" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST2</Setting>
    <Setting Target="Host" Name="MessageVolume">10</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5005</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01</Setting>
  </Item>
  <Item Name="TEST3_INT006" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST3</Setting>
    <Setting Target="Host" Name="MessageVolume">10</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5006</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01</Setting>
  </Item>
  <Item Name="TEST3_INT001" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST3</Setting>
    <Setting Target="Host" Name="MessageVolume">2,2,2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5001</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01,ORUR01,ORMR01</Setting>
  </Item>
  <Item Name="TEST4_INT003" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST4</Setting>
    <Setting Target="Host" Name="MessageVolume">2,2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5003</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v1BAD,ADTA01v1GOOD</Setting>
  </Item>
  <Item Name="TEST4_INT011" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST4</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5011</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01vNONSTANDARD</Setting>
  </Item>
  <Item Name="TEST4_INT013" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST4</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5012</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01vNONSTANDARD,ORUR01vOK</Setting>
  </Item>
  <Item Name="TEST4_INT012" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST4</Setting>
    <Setting Target="Host" Name="MessageVolume">2,2,2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5012</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v1EXCLUDE,ADTA01v1GOOD,ORUR01vOK</Setting>
  </Item>
  <Item Name="TEST5_INT007" Category="" ClassName="HL7Loader.bs.INT007Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5007</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01v1MB</Setting>
  </Item>
  <Item Name="TEST5_INT009" Category="" ClassName="HL7Loader.bs.INT009Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5009</Setting>
    <Setting Target="Host" Name="XDataBlockName"></Setting>
  </Item>
  <Item Name="TEST5_INT011" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5011</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v2</Setting>
  </Item>
  <Item Name="TEST5_INT003" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5003</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01v3</Setting>
  </Item>
  <Item Name="TEST5_INT008" Category="" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5008</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01vOK</Setting>
  </Item>
</Production>
}

}
