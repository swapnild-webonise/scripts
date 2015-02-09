import time
from fabric.api import cd, env, run
from fabric.contrib.files import exists
from fabric.operations import sudo
from fabric.api import *

env.hosts = ['deploy@10.10.1.168']
env.user = "deploy"
env.key_filename = "/home/webonise/.ssh/id_rsa"

app_name = "RorApp"
doc_root = "rorproject"

global new_release
global doc_root

scm_repo = "git@github.com:shital-webonise/rorapp.git"

#def host_type():
def install_ruby():
        sudo('apt-get update')
        sudo('apt-get install git-core curl zlib1g-dev build-essential libssl-dev -y')
        sudo('apt-get install libreadline-dev libyaml-dev libsqlite3-dev sqlite3 -y')
        sudo('apt-get install libxml2-dev libxslt1-dev libcurl4-openssl-dev -y')
        sudo('apt-get install python-software-properties -y')

def setup_ruby():
        run('cd')
        sudo('wget http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz')
        sudo('tar -xzvf ruby-2.1.3.tar.gz')
        with cd("ruby-2.1.3/"):
                sudo('./configure')
                sudo('make')
                sudo('make install')
                run('ruby -v')
                sudo('echo "gem: --no-ri --no-rdoc" > ~/.gemrc')

def install_rails():
        sudo('gem install rails -V')

def deploy_setup():
        sudo('apt-get install libmysqlclient-dev')
        if not exists("/var/www/%s" % doc_root):
           run("mkdir -p /var/www/%s" % doc_root)
           with cd("/var/www/%s" % doc_root):      ## clone code fron git
               run("mkdir -p /var/www/%s/shared" %doc_root)
               run("mkdir -p /var/www/%s/shared/config" % doc_root)
               run("mkdir -p /var/www/%s/releases" % doc_root)

def set_database():
	run("echo 'create database ror' | mysql -u root -p'machine'")
#	run("create database ror")
#	run("exit")


def deploy():
          ts = run("date +%Y%m%d%H%M%S")  #timestamp
          global shared_path
          global new_release
          global doc_root

          new_release = "/var/www/%s/releases/%s/" % (doc_root,ts)    ### new release dir
          shared_path = "/var/www/%s/shared" % doc_root
          run("mkdir -p %s" %new_release)
          with cd(new_release):
            run("git clone %s %s" %(scm_repo,new_release))
            run('bundle install')
            deploy_symlink()

def deploy_symlink():
          with cd(new_release):
            run("ln -s /var/www/%s/shared/config/database.yml %s/." % (doc_root,new_release))
            with cd("/var/www/%s" % doc_root):
#               run("unlink current")
                run("ln -s %s /var/www/%s/current" %(new_release,doc_root))
                run("cp %s/config/database.yml %s/config/." % (shared_path,new_release))
                with cd(new_release):
                    run('rake db:migrate')
def install_passenger():
  sudo('gem install passenger -V')

def deployment():
   print("Enter the Following Operations which you want to perform ")
   print("1. HOst_Type ")
   print("2. Install Ruby ")
   print("3. Setup Ruby ")
   print("4. Install Rails ")
   print("5. Install PAssenger")
   print("6. Create directory stucture ")
   print("7.Deploy An app ")
   print("8. Create symlink")
   options = {
   #      1:host_type,
         2:install_ruby,
         3:setup_ruby,
         4:install_rails,
         5:install_passenger,
         6:deploy_setup,
         7:deploy,
         8:deploy_symlink
     }
   num=input("Please Enter : ")
   options[num]()
