object MyREST_Service: TMyREST_Service
  OldCreateOrder = False
  OnCreate = ServiceCreate
  DisplayName = 'My REST Service'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
end
