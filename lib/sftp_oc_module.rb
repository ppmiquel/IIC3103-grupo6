

    require 'net/sftp'


def saveSftpOc()
  #nos conectamos
  session = Net::SFTP.start('mare.ing.puc.cl', 'integra6', :password => 'BSnt6txv', :port =>22)
  sftp = Net::SFTP::Session.new(session)
    sftp.dir.foreach("/pedidos") do |archivo|

      myfile.csv /my/dir/myfile.csv


end
