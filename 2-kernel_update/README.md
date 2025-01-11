- название выполняемого задания;
- текст задания;
-;
- особенности проектирования и реализации решения, 
- заметки, если считаете, что имеет смысл их зафиксировать в репозитории.




###  **Kernel update**

# **Ранее установлено ПО**
- **VirtualBox** - среда виртуализации;
- **Vagrant** - ПО для создания и конфигурирования виртуальной среды;
- **Git** - система контроля версий.


# **Домашняя работа**

Все дальнейшие действия были проверены при использовании Vagrant 2.4.0, VirtualBox 7.0.14, хостовая ОС: Ubuntu 22.04 Desktop. 
В лабораторной работе используются Vagrant boxes с CentOS 8 Stream.

Создадим Vagrantfile, в котором будут указаны параметры нашей ВМ:

sudo  vagrant init

sudo dir /opt/vagrant
sudo cd /opt/vagrant

sudo nano Vagrantfile
-----------------------------------------------------------
# Описываем Виртуальные машины
MACHINES = {
  # Указываем имя ВМ "kernel update"
  :"kernel-update" => {
              #Какой vm box будем использовать
              :box_name => "centos/8",
              #Указываем box_version   НАДО не 4.3.4, а 1.0.0
              :box_version => "1.0.0",
              #Указываем количество ядер ВМ
              :cpus => 2,
              #Указываем количество ОЗУ в мегабайтах
              :memory => 1024,
            }
}
# Указываем рабочее зеркало источника boxов
ENV['VAGRANT_SERVER_URL'] = 'http://vagrant.elab.pro'
Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    # Отключаем проброс общей папки в ВМ
    config.vm.synced_folder ".", "/vagrant", disabled: true
    # Применяем конфигурацию ВМ
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box_name]
      box.vm.box_version = boxconfig[:box_version]
      box.vm.host_name = boxname.to_s
      box.vm.provider "virtualbox" do |v|
        v.memory = boxconfig[:memory]
        v.cpus = boxconfig[:cpus]
      end
    end
  end
end
-------------------------------------------------------------

vagrant up

vagrant ssh

uname -r
# 4.18.0-240.1.1.el8_3.x86_64

# Решаем проблему с Centos* и невозможностью скачать с репозитория:
sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/CentOS-*.repo
sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/CentOS-*.repo
sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/CentOS-*.repo
yum update
yum upgrade


sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
sudo yum --enablerepo elrepo-kernel install kernel-ml -y

1) Обновить конфигурацию загрузчика:
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

2) Выбрать загрузку нового ядра по-умолчанию:
sudo grub2-set-default 0

sudo reboot

uname -r
# 4.18.0-348.7.1.el8_5.x86_64

На этом обновление ядра закончено.
































