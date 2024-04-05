tell application "Viscosity"
if the state of the first connection is not "Connected" then 
  connect "Red Hat Global VPN"
  repeat while the state of the first connection is not "Connected"
    delay 0.5
  end repeat
else 
  display notification "VPN Already Connected." with title "Viscosity"
end if
end tell
