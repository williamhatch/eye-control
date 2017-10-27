
class XLogger
	def self.info(str)
		@@tlogger ||= Logger.new('foo.txt')
		@@tlogger.info str
	end
end
