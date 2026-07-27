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
  <Setting Target="Adapter" Name="ReArm">1</Setting>
  <Setting Target="Adapter" Name="Services">INT003_TEST5,INT007_TEST5,INT008_TEST5,INT009_TEST5,INT011_TEST5</Setting>
  <Item Name="HL7 Dispatch 5001" Category="TEST1" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="15.134.154.17" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5001</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5002" Category="TEST2" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="15.134.154.17" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5002</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5003" Category="TEST3" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5003</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5004" Category="TEST4" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5004</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5005" Category="TEST5" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">15.134.154.17</Setting>
    <Setting Target="Adapter" Name="Port">5005</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="HL7 Dispatch 5006" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
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
  <Item Name="INT001_TEST3" Category="TEST3" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST3</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5003</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01,
ORMR01</Setting>
  </Item>
  <Item Name="INT002_TEST1" Category="TEST1" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST1</Setting>
    <Setting Target="Host" Name="MessageVolume">2,2,2,2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5001</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01,
ORUR01,
ORMO01,
SIUS12</Setting>
  </Item>
  <Item Name="INT003_TEST4" Category="TEST4" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST4</Setting>
    <Setting Target="Host" Name="MessageVolume">1</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5004</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01vOK,
ORUR01vNOOBX</Setting>
  </Item>
  <Item Name="INT003_TEST5" Category="TEST5" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="Send malformed ADT and ORU messages
" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">2,2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5005</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01vNOOBX,
ORUR01</Setting>
  </Item>
  <Item Name="INT004_TEST2" Category="TEST2" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST2</Setting>
    <Setting Target="Host" Name="MessageVolume">10</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5002</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v231</Setting>
  </Item>
  <Item Name="INT005_TEST2" Category="TEST2" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST2</Setting>
    <Setting Target="Host" Name="MessageVolume">5</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5002</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v24,
ADTA01v231</Setting>
  </Item>
  <Item Name="INT006_TEST3" Category="TEST3" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST3</Setting>
    <Setting Target="Host" Name="MessageVolume">10</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5003</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v24</Setting>
  </Item>
  <Item Name="INT011_TEST4" Category="TEST4" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST4</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5004</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v24NONSTANDARD,
ORUR01vNONSTANDARD</Setting>
  </Item>
  <Item Name="INT012_TEST4" Category="TEST4" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST4</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5004</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01vOK,
ORUR01vNONSTANDARD</Setting>
  </Item>
  <Item Name="INT013_TEST4" Category="TEST4" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST4</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5004</Setting>
    <Setting Target="Host" Name="XDataBlockName">-ORUR01vNONSTANDARD,
-ORUR01vOK</Setting>
  </Item>
  <Item Name="INT008_TEST5" Category="TEST5" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="Send regular ORU and ORM messages" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5005</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01,
ORMR01</Setting>
  </Item>
  <Item Name="INT011_TEST5" Category="TEST5" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="Send ADT with non-standard coded values." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5005</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v24NONSTANDARD</Setting>
  </Item>
  <Item Name="INT009_TEST5" Category="TEST5" ClassName="HL7Loader.bs.INT009Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="Send ORU Messages with varying OBX element  numbers 20/48/80 obx&apos;s" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5005</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01v20,
ORUR01v40,
ORUR01v80</Setting>
  </Item>
  <Item Name="INT007_TEST5" Category="TEST5" ClassName="HL7Loader.bs.INT007Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="Send Multiple PDF Attachment Sizes" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST5</Setting>
    <Setting Target="Host" Name="MessageVolume">1</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5005</Setting>
    <Setting Target="Host" Name="XDataBlockName">ORUR01v1MB,
ORUR01v5MB,
ORUR01v10MB,
ORUR01v20MB,
ORUR01v40MB</Setting>
  </Item>
  <Item Name="All Test4 HL7" Category="TEST4" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST4</Setting>
    <Setting Target="Host" Name="MessageVolume">1</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5004</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v24GOOD,
ADTA01v24BAD,
ADTA01v24EXCLUDE,
ADTA01v24NONSTANDARD,
ORUR01vOK,
ORUR01vNOOBX,
ORUR01vNONSTANDARD,
ORUR01vREQUIRED</Setting>
  </Item>
  <Item Name="All Test3 HL7" Category="TEST3" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST3</Setting>
    <Setting Target="Host" Name="MessageVolume">2</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5003</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v24,
-ADTA01v231,
ORUR01,
ORMR01</Setting>
  </Item>
  <Item Name="All Test2 HL7" Category="TEST2" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST2</Setting>
    <Setting Target="Host" Name="MessageVolume">5</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5002</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01v24,
ADTA01v231</Setting>
  </Item>
  <Item Name="All Test1 HL7" Category="TEST1" ClassName="HL7Loader.bs.HL7Generator" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SampleMessagesClass">HL7Loader.hl7.TEST1</Setting>
    <Setting Target="Host" Name="MessageVolume">50</Setting>
    <Setting Target="Adapter" Name="CallInterval">99999</Setting>
    <Setting Target="Host" Name="MessageSendDelay">2</Setting>
    <Setting Target="Host" Name="Targets">HL7 Dispatch 5001</Setting>
    <Setting Target="Host" Name="XDataBlockName">ADTA01,
ORUR01,
ORMO01,
SIUS12</Setting>
  </Item>
</Production>
}

}
