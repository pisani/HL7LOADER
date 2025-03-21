Class test.NewProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="test.NewProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="TCPOut_1" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">9001</Setting>
  </Item>
  <Item Name="TCPOut_2" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">9002</Setting>
  </Item>
  <Item Name="TCPOut_3" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">9003</Setting>
  </Item>
  <Item Name="TCPOut_4" Category="" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">9004</Setting>
  </Item>
  <Item Name="test.Distribute" Category="" ClassName="test.Distribute" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="TCPIn_1" Category="" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Port">9001</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">test.ProcessHL7Message</Setting>
  </Item>
  <Item Name="TCPIn_2" Category="" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Port">9002</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">test.ProcessHL7Message</Setting>
  </Item>
  <Item Name="TCPIn_3" Category="" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Port">9003</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">test.ProcessHL7Message</Setting>
  </Item>
  <Item Name="TCPIn_4" Category="" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Port">9004</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">test.ProcessHL7Message</Setting>
  </Item>
  <Item Name="test.MSGGenerator" Category="" ClassName="test.MSGGenerator" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="MessageCount">10</Setting>
    <Setting Target="Adapter" Name="CallInterval">100</Setting>
  </Item>
  <Item Name="test.ProcessHL7Message" Category="" ClassName="test.ProcessHL7Message" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
