require 'socket'

class RBCPHeader
    READ = 0xC0 # 0xC0(16) 192(10)  1100_0000(2)
    WRITE= 0x80 #          128(10)  1000_0000(2)
    def initialize(rw, id, dataLength, address)
        @verType = 0xff
			# 0xff : 1111_1111
			# 0x80 : 1000_0000
        @cmdFlag = rw & 0xff 
        @id = id & 0xff
        @dataLength = dataLength & 0xff
        @address = address & 0xffffffff
    end

# a & b : 論理積はそれぞれのオペランドの各ビットを比較し、
# それぞれが1であれば1をそうでなければ0という算術
# 1000_0000 & 1111_1111 = 1000_0000 
# a | b : 論理和は、ビットの一方が1であれば1という算術
# 0000_1111 | 1111_0000 = 1111_1111

    def self.fromBin(str)
        $logger.debug "	info(str)            : #{str[0].unpack('C*')[0]}"
        $logger.debug "	info(str) read/write : #{str[1].unpack('C*')[0]}"
        $logger.debug "	info(str) id         : #{str[2].unpack('C*')[0]}"
        $logger.debug "	info(str) dataLength : #{str[3].unpack('C*')[0]}"
        $logger.debug "	info(str) addressDeci: #{str[4, 4].unpack('N')[0]}"
        RBCPHeader.new(str[1].unpack('C')[0], 
                       str[2].unpack('C')[0], 
                       str[3].unpack('C')[0], 
                       str[4, 4].unpack('N')[0])
    end

    def to_s
        str = String.new
        if RUBY_VERSION >= '1.9.0'
            str.force_encoding('ASCII-8BIT')
        end
        str << @verType
        str << @cmdFlag
        str << @id
        str << @dataLength
        str << [@address].pack('N')
    end
    attr_accessor :verType, :cmdFlag, :id, :dataLength, :address
end

class RBCPError < Exception; end

class RBCP
    def initialize(host, port)
        @host = host
        @port = port
        @id = 0
    end

    def read(address, dataLength)
        readData = "".encode('ASCII-8BIT')
        while dataLength > 0 do
            dataLength1Packet = [dataLength, 255].min
            #puts 'RBCP::read address = %08X, length = %d' [address,  dataLength1Packet] ##DEBUG
            readData << com(RBCPHeader::READ, address, dataLength1Packet, '')
            dataLength -= dataLength1Packet
            address += dataLength1Packet
        end
        readData
    end

    def read8bit(address, dataLength)
        read(address, dataLength).unpack('C*')
    end

    def read16bit(address, dataLength)
        read(address, dataLength * 2).unpack('n*')
    end

    def read32bit(address, dataLength)
        read(address, dataLength * 4).unpack('N*')
    end

    def write(address, data)
        if data.is_a?(Fixnum)
            data = [data]
        end
        if data.is_a?(Array)
            data = data.pack('C*')
        end

        remainDataLength = data.length
        dataIndex = 0

        while remainDataLength > 0
            dataLength1Packet = [remainDataLength, 255].min
            dataToWrite       = data[dataIndex, dataLength1Packet]

            #puts '	RBCP::write => Now WRITE: address=%08X,  index=%d,  dataToWrite=%02X,  length1Packet=%d' % 
            #     [address + dataIndex,  dataIndex,  dataToWrite.getbyte(0),  dataLength1Packet] ##DEBUG

            com(RBCPHeader::WRITE, address + dataIndex, dataLength1Packet, dataToWrite)
            remainDataLength -= dataLength1Packet
            dataIndex        += dataLength1Packet
        end
    end

    def write8bit(address, data)
        write(address, data)
    end

    def write16bit(address, data)
        if data.is_a?(Fixnum)
            data = [data]
        end
        write(address, data.pack('n*'))
    end

    def write32bit(address, data)
        if data.is_a?(Fixnum)
            data = [data]
        end
        write(address, data.pack('N*'))
    end

    def com(rw, address, dataLength, data)
        retries = 0
        maxRetries = 1 
        begin
      	  return comSub(rw, address, dataLength, data)
        rescue RBCPError => err
          $logger.debug "RBCP::com <someting fatal happend!>"
      	  puts err.message
          retries += 1
        retry if retries < maxRetries
          raise err
        end
    end

   def comSub(rw, address, dataLength, data)
   	sock = UDPSocket.open()  
      begin
         # IPアドレスとポートを指定
         sock.bind("0.0.0.0", 0)

         header = RBCPHeader.new(rw, @id, dataLength, address) 

         if RUBY_VERSION >= '1.9.0'
         	data.force_encoding('ASCII-8BIT')
         end

			$logger.debug "	header.to_s:  length   = #{header.to_s.length}  "
			$logger.debug "	data       :  length   = #{data.length}  "

         dataToBeSent = header.to_s + data
			$logger.debug "	dataToBeSent: length   = #{dataToBeSent.length}  "
			$logger.debug "	dataToBeSent: arr_size = #{dataToBeSent.size}  "
         $logger.debug "	show the array while considering char strings as byte strings:
                        => #{dataToBeSent.unpack('C*')}"

         if sock.send(dataToBeSent, 0, @host, @port) != dataToBeSent.length
            raise RBCPError.new("cannot send data")
         end

         # wait for 1 seconds until ACK is received
      	#$logger.debug "RBCP::comSub wait for 1 seconds until ACK is received"
			sel = IO::select([sock], nil, nil, 1)
         raise RBCPError.new("Timeout") if sel == nil

			# recv(maxlen, flags = 0) -> String
			# ソケットからデータを受け取り、文字列として返します。 
			# maxlen は受け取る最大の長さを指定します。
         receivedData = sock.recv(255+8) 
         $logger.debug "	receivedData: length   = #{receivedData.length}  "
         $logger.debug "	receivedData: arr_size = #{receivedData.size}  "
			$logger.debug "	show the array while considering char strings as byte strings:
                        => #{receivedData.unpack('C*')}" 
	
			# C* 8bit 符号なし整数
   		# N* unsigned long (32bit 符号なし整数)
			#puts receivedData.unpack('C*') # 文字列をバイト列と見なして数値配列
         #puts receivedData.each_byte {|b| printf("%x ", b) } # 16進数表示

         validate(rw, address, dataLength, data, receivedData)
      ensure
         sock.close
      	@id = (@id + 1) & 0xff
      end
      receivedData.slice!(0, 8)
      receivedData
	end
   private :com

   # READ = 0xC0 # 0xC0(16) 192(10)  1100_0000(2)
   # WRITE= 0x80 #          128(10)  1000_0000(2)
	# 0X88 136 10001000
	# 0X89 137 10001001 

	def validate(rw, address, dataLength, data, receivedData)
   	header = RBCPHeader.fromBin(receivedData)
      #$logger.debug "	RBCP::validate header.dataLength   = #{header.dataLength}  "
      #$logger.debug "	RBCP::validate receivedData.length = #{receivedData.length}  "
      if RUBY_VERSION >= '1.9.0'
      	raise RBCPError.new("Invalid Ver Type")   if receivedData.getbyte(0) != 0xff
      else
         raise RBCPError.new("Invalid Ver Type")   if receivedData[0] != 0xff
      end

  		if header.cmdFlag != (rw | 0x08)
      	if header.cmdFlag & 0x01
         	raise RBCPError.new("Bus Error")
         else
            raise RBCPError.new("Invalid CMD Flag")
         end
      end
      raise RBCPError.new("Invalid ID")         if header.id != @id
      raise RBCPError.new("Invalid DataLength") if header.dataLength != dataLength
      raise RBCPError.new("Invalid Address")    if header.address != address
      raise RBCPError.new("Frame Error")        if header.dataLength != receivedData.length - 8
    end
    private :validate
end
