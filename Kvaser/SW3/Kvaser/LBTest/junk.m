for cnt = 1:1000
    write(UdpHandle,UdpMessage(1:place),"uint8",IpString(AtpCfg.Udp.HostIP), AtpCfg.Udp.HostPort  );
    cnt
    pause(1);
end