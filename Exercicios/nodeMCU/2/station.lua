wificonf = {
    ssid = "nomedarede",
    pwd = "senha",
    save = false,
    got_ip_cb = function (con)
                  print (con.IP)
                end
  }
  
  wifi.sta.config(wificonf)
  print("modo: ".. wifi.setmode(wifi.STATION))
  