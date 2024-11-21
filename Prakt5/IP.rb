class IPAddressValidator
  def self.main(ip_addresses)
    ip_addresses.each do |ip|
      if ip.strip.empty?
        puts "Empty string is not a valid IP address"
        next
      end

      if ip.strip != ip || ip.include?(' ')
        puts "#{ip} false, because it contains leading/trailing or internal spaces"
        next
      end

      unless ip =~ /\A\d+(\.\d+){3}\z/
        puts "#{ip} false, because it contains invalid characters or incorrect format"
        next
      end

      octets = ip.split('.')

      if octets.length != 4
        puts "#{ip} false, because it contains #{octets.length} octets, but it must contain exactly 4"
        next
      end

      valid = octets.all? do |octet|
        if octet.start_with?('0') && octet.length > 1
          puts "#{ip} false, because it contains an octet with leading zeros"
          false
        elsif octet.to_i < 0 || octet.to_i > 255
          puts "#{ip} false, because it contains an octet #{octet} out of range 0-255"
          false
        else
          true
        end
      end

      puts "#{ip} #{valid}" if valid
    end
  end
end


ip_addresses_to_test = [
  "192.168.1.1",            # Валідні IP
  "255.255.255.255",
  "0.0.0.0",
  "192.168.001.1",          # Ведучі нулі
  "256.256.256.256",        # Октет поза діапазоном
  "192.168.1.a",            # Неприпустимі символи
  "172.16..1",              # Порожні октети
  "192.168.50.1.1",         # Зайві октети
  "",                       # Порожній рядок
  " 192.168.50.1 ",         # Пробіли
]

IPAddressValidator.main(ip_addresses_to_test)
