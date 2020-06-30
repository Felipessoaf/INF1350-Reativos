wificonf = {
    ssid = "Ed_2G",
    pwd = "EspacoEducacao",
    save = false,
    got_ip_cb = function (con)
                  print (con.IP)
                end
  }
  
  wifi.sta.config(wificonf)
  print("modo: ".. wifi.setmode(wifi.STATION))
  